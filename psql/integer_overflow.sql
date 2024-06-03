SELECT
    seqs.relname AS sequence,
    format_type(s.seqtypid, NULL) sequence_datatype,
    CONCAT(tbls.relname, '.', attrs.attname) AS owned_by,
    format_type(attrs.atttypid, atttypmod) AS column_datatype,
    pg_sequence_last_value(seqs.oid::regclass) AS last_sequence_value,
    TO_CHAR((
        CASE WHEN format_type(s.seqtypid, NULL) = 'smallint' THEN
            (pg_sequence_last_value(seqs.relname::regclass) / 32767::float)
        WHEN format_type(s.seqtypid, NULL) = 'integer' THEN
            (pg_sequence_last_value(seqs.relname::regclass) / 2147483647::float)
        WHEN format_type(s.seqtypid, NULL) = 'bigint' THEN
            (pg_sequence_last_value(seqs.relname::regclass) / 9223372036854775807::float)
        END) * 100, 'fm9999999999999999999990D00%') AS sequence_percent,
    TO_CHAR((
        CASE WHEN format_type(attrs.atttypid, NULL) = 'smallint' THEN
            (pg_sequence_last_value(seqs.relname::regclass) / 32767::float)
        WHEN format_type(attrs.atttypid, NULL) = 'integer' THEN
            (pg_sequence_last_value(seqs.relname::regclass) / 2147483647::float)
        WHEN format_type(attrs.atttypid, NULL) = 'bigint' THEN
            (pg_sequence_last_value(seqs.relname::regclass) / 9223372036854775807::float)
        END) * 100, 'fm9999999999999999999990D00%') AS column_percent
FROM
    pg_depend d
    JOIN pg_class AS seqs ON seqs.relkind = 'S'
        AND seqs.oid = d.objid
    JOIN pg_class AS tbls ON tbls.relkind = 'r'
        AND tbls.oid = d.refobjid
    JOIN pg_attribute AS attrs ON attrs.attrelid = d.refobjid
        AND attrs.attnum = d.refobjsubid
    JOIN pg_sequence s ON s.seqrelid = seqs.oid
WHERE
    d.deptype = 'a'
    AND d.classid = 1259
ORDER BY
  CASE WHEN format_type(attrs.atttypid, NULL) = 'smallint' THEN
      (pg_sequence_last_value(seqs.relname::regclass) / 32767::float)
  WHEN format_type(attrs.atttypid, NULL) = 'integer' THEN
      (pg_sequence_last_value(seqs.relname::regclass) / 2147483647::float)
  WHEN format_type(attrs.atttypid, NULL) = 'bigint' THEN
      (pg_sequence_last_value(seqs.relname::regclass) / 9223372036854775807::float)
  END DESC NULLS LAST
;
