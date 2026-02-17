CREATE OR REPLACE FUNCTION pg_temp.mrp_integer_pk_utilization(schema_pattern text DEFAULT 'public'::text, table_name_pattern text DEFAULT '%'::text) RETURNS TABLE(table_name text, utilization numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
    rec RECORD;
    query_template TEXT;
    current_max_value BIGINT;
    max_possible_value NUMERIC;
    percentage NUMERIC;
    full_table_name TEXT;
BEGIN
    -- Find tables with a single-column integer primary key in the specified schema(s)
    FOR rec IN
        SELECT
          n.nspname AS table_schema,
          c.relname AS table_name,
          a.attname AS column_name,
          format_type(a.atttypid, a.atttypmod) AS data_type
        FROM pg_catalog.pg_constraint con
        JOIN pg_catalog.pg_class c
          ON c.oid = con.conrelid
        JOIN pg_catalog.pg_namespace n
          ON n.oid = c.relnamespace
        JOIN pg_catalog.pg_attribute a
          ON a.attrelid = c.oid
         AND a.attnum = con.conkey[1]
        WHERE con.contype = 'p'
          AND n.nspname ILIKE schema_pattern
          AND c.relname ILIKE table_name_pattern
          AND cardinality(con.conkey) = 1
          AND a.atttypid IN ('int2'::regtype, 'int4'::regtype, 'int8'::regtype)
        ORDER BY n.nspname, c.relname
    LOOP
        full_table_name := format('%I.%I', rec.table_schema, rec.table_name);

        -- Construct dynamic query to get the maximum value from the PK column
        -- format() with %I safely quotes identifiers (schema, table, column names)
        query_template := format('SELECT max(%I) FROM %s', rec.column_name, full_table_name);

        -- Execute the dynamic query
        BEGIN
            EXECUTE query_template INTO current_max_value;
        EXCEPTION
            WHEN OTHERS THEN
                -- Log warning and skip if query fails (e.g., permissions)
                RAISE WARNING 'Could not query max value for column % on table %: %',
                    rec.column_name, full_table_name, SQLERRM;
                CONTINUE; -- Skip to the next table
        END;

        -- Handle empty tables (max() returns NULL)
        IF current_max_value IS NULL THEN
            current_max_value := 0;
        END IF;

        -- Determine the maximum possible value for the integer type
        CASE rec.data_type
            WHEN 'smallint' THEN max_possible_value := 32767; -- (2^15 - 1)
            WHEN 'integer' THEN max_possible_value := 2147483647; -- (2^31 - 1)
            WHEN 'bigint' THEN max_possible_value := 9223372036854775807; -- (2^63 - 1)
            ELSE max_possible_value := 0; -- Should not happen based on WHERE clause
        END CASE;

        -- Calculate percentage, avoid division by zero
        IF max_possible_value > 0 THEN
            -- Cast to NUMERIC for accurate division before multiplying
            percentage := (current_max_value::numeric / max_possible_value);
        ELSE
            percentage := 0.0;
        END IF;

        -- Prepare results for the output table
        mrp_integer_pk_utilization.table_name := full_table_name;
        mrp_integer_pk_utilization.utilization := percentage;

        -- Return the current row
        RETURN NEXT;

    END LOOP;

    RETURN;
END;
$$;

\prompt 'schema (default public): ' mrp_integer_pk_utilization_schema
\prompt 'table name pattern (default %): ' mrp_integer_pk_utilization_table_pattern

select * from pg_temp.mrp_integer_pk_utilization(
  coalesce(nullif(:'mrp_integer_pk_utilization_schema', ''), 'public'),
  coalesce(nullif(:'mrp_integer_pk_utilization_table_pattern', ''), '%')
) order by utilization desc;
