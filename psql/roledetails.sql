\prompt 'Enter role name: ' mrp_rolename
-- Cluster permissions not "on" anything else
SELECT
  'cluster' AS on,
  NULL AS name,
  unnest(
    CASE WHEN rolcanlogin THEN ARRAY['LOGIN'] ELSE ARRAY[]::text[] END
    || CASE WHEN rolsuper THEN ARRAY['SUPERUSER'] ELSE ARRAY[]::text[] END
    || CASE WHEN rolcreaterole THEN ARRAY['CREATE ROLE'] ELSE ARRAY[]::text[] END
    || CASE WHEN rolcreatedb THEN ARRAY['CREATE DATABASE'] ELSE ARRAY[]::text[] END
  ) AS privilege_type
FROM pg_roles
WHERE oid = quote_ident(:'mrp_rolename')::regrole

UNION ALL

-- Direct role memberships
SELECT 'role' AS on, groups.rolname AS name, 'MEMBER' AS privilege_type
FROM pg_auth_members mg
INNER JOIN pg_roles groups ON groups.oid = mg.roleid
INNER JOIN pg_roles members ON members.oid = mg.member
WHERE members.rolname = :'mrp_rolename'

-- Direct ACL or ownerships
UNION ALL (
  -- ACL or owned-by dependencies of the role - global or in the currently connected database
  WITH owned_or_acl AS (
    SELECT
      refobjid,  -- The referenced object: the role in this case
      classid,   -- The pg_class oid that the dependant object is in
      objid,     -- The oid of the dependant object in the table specified by classid
      deptype,   -- The dependency type: o==is owner, and might have acl, a==has acl and not owner
      objsubid   -- The 1-indexed column index for table column permissions. 0 otherwise.
    FROM pg_shdepend
    WHERE refobjid = quote_ident(:'mrp_rolename')::regrole
    AND refclassid='pg_catalog.pg_authid'::regclass
    AND deptype IN ('a', 'o')
    AND (dbid = 0 OR dbid = (SELECT oid FROM pg_database WHERE datname = current_database()))
  ),

  relkind_mapping(relkind, type) AS (
    VALUES
      ('r', 'table'),
      ('v', 'view'),
      ('m', 'materialized view'),
      ('f', 'foreign table'),
      ('p', 'partitioned table'),
      ('S', 'sequence')
  ),

  prokind_mapping(prokind, type) AS (
    VALUES
      ('f', 'function'),
      ('p', 'procedure'),
      ('a', 'aggregate function'),
      ('w', 'window function')
  ),

  typtype_mapping(typtype, type) AS (
    VALUES
      ('b', 'base type'),
      ('c', 'composite type'),
      ('e', 'enum type'),
      ('p', 'pseudo type'),
      ('r', 'range type'),
      ('m', 'multirange type'),
      ('d', 'domain')
  )

  -- Database ownership
  SELECT 'database' AS on, quote_ident(datname) AS name, 'OWNER' AS privilege_type
  FROM pg_database d
  INNER JOIN owned_or_acl a ON a.objid = d.oid
  WHERE classid = 'pg_database'::regclass AND deptype = 'o'

  UNION ALL

  -- Database privileges
  SELECT 'database' AS on, quote_ident(datname) AS name, privilege_type
  FROM pg_database d
  INNER JOIN owned_or_acl a ON a.objid = d.oid
  CROSS JOIN aclexplode(COALESCE(d.datacl, acldefault('d', d.datdba)))
  WHERE classid = 'pg_database'::regclass AND grantee = refobjid

  UNION ALL

  -- Schema ownership
  SELECT 'schema' AS on, n.oid::regnamespace::text AS name, 'OWNER' AS privilege_type
  FROM pg_namespace n
  INNER JOIN owned_or_acl a ON a.objid = n.oid
  WHERE classid = 'pg_namespace'::regclass AND deptype = 'o'

  UNION ALL

  -- Schema privileges
  SELECT 'schema' AS on, n.oid::regnamespace::text AS name, privilege_type
  FROM pg_namespace n
  INNER JOIN owned_or_acl a ON a.objid = n.oid
  CROSS JOIN aclexplode(COALESCE(n.nspacl, acldefault('n', n.nspowner)))
  WHERE classid = 'pg_namespace'::regclass AND grantee = refobjid

  UNION ALL

  -- Table(-like) ownership
  SELECT r.type AS on, c.oid::regclass::text AS name, 'OWNER' AS privilege_type
  FROM pg_class c
  INNER JOIN owned_or_acl a ON a.objid = c.oid
  INNER JOIN relkind_mapping r ON r.relkind = c.relkind
  WHERE classid = 'pg_class'::regclass AND deptype = 'o' AND objsubid = 0

  UNION ALL

  -- Table(-like) privileges
  SELECT r.type AS on, c.oid::regclass::text AS name, privilege_type
  FROM pg_class c
  INNER JOIN owned_or_acl a ON a.objid = c.oid
  CROSS JOIN aclexplode(COALESCE(c.relacl, acldefault('r', c.relowner)))
  INNER JOIN relkind_mapping r ON r.relkind = c.relkind
  WHERE classid = 'pg_class'::regclass AND grantee = refobjid AND objsubid = 0

  UNION ALL

  -- Column privileges
  SELECT 'table column', t.attrelid::regclass::text || '.' || quote_ident(attname) AS name, privilege_type
  FROM pg_attribute t
  INNER JOIN pg_class c ON c.oid = t.attrelid
  INNER JOIN owned_or_acl a ON a.objid = t.attrelid
  CROSS JOIN aclexplode(COALESCE(t.attacl, acldefault('c', c.relowner)))
  WHERE classid = 'pg_class'::regclass AND grantee = refobjid AND objsubid != 0

  UNION ALL

  -- Function and procdedure ownership
  SELECT m.type AS on, p.oid::regprocedure::text AS name, 'OWNER' AS privilege_type
  FROM pg_proc p
  INNER JOIN owned_or_acl a ON a.objid = p.oid
  INNER JOIN prokind_mapping m ON m.prokind = p.prokind
  WHERE classid = 'pg_proc'::regclass AND deptype = 'o'

  UNION ALL

  -- Function and procedure privileges
  SELECT m.type AS on, p.oid::regprocedure::text AS name, privilege_type
  FROM pg_proc p
  INNER JOIN owned_or_acl a ON a.objid = p.oid
  CROSS JOIN aclexplode(COALESCE(p.proacl, acldefault('f', p.proowner)))
  INNER JOIN prokind_mapping m ON m.prokind = p.prokind
  WHERE classid = 'pg_proc'::regclass AND grantee = refobjid

  UNION ALL

  -- Large object ownership
  SELECT 'large object' AS on, l.oid::text AS name, 'OWNER' AS privilege_type
  FROM pg_largeobject_metadata l
  INNER JOIN owned_or_acl a ON a.objid = l.oid
  WHERE classid = 'pg_largeobject'::regclass AND deptype = 'o'

  UNION ALL

  -- Large object privileges
  SELECT 'large object' AS on, l.oid::text AS name, privilege_type
  FROM pg_largeobject_metadata l
  INNER JOIN owned_or_acl a ON a.objid = l.oid
  CROSS JOIN aclexplode(COALESCE(l.lomacl, acldefault('L', l.lomowner)))
  WHERE classid = 'pg_largeobject'::regclass AND grantee = refobjid

  UNION ALL

  -- Type ownership
  SELECT m.type, t.oid::regtype::text AS name, 'OWNER' AS privilege_type
  FROM pg_type t
  INNER JOIN owned_or_acl a ON a.objid = t.oid
  INNER JOIN typtype_mapping m ON m.typtype = t.typtype
  WHERE classid = 'pg_type'::regclass AND deptype = 'o'

  UNION ALL

  -- Type privileges
  SELECT m.type, t.oid::regtype::text AS name, privilege_type
  FROM pg_type t
  INNER JOIN owned_or_acl a ON a.objid = t.oid
  CROSS JOIN aclexplode(COALESCE(t.typacl, acldefault('T', t.typowner)))
  INNER JOIN typtype_mapping m ON m.typtype = t.typtype
  WHERE classid = 'pg_type'::regclass AND grantee = refobjid

  UNION ALL

  -- Language ownership
  SELECT 'language' AS on, quote_ident(l.lanname) AS name, 'OWNER' AS privilege_type
  FROM pg_language l
  INNER JOIN owned_or_acl a ON a.objid = l.oid
  WHERE classid = 'pg_language'::regclass AND deptype = 'o'

  UNION ALL

  -- Language privileges
  SELECT 'language' AS on, quote_ident(l.lanname) AS name, privilege_type
  FROM pg_language l
  INNER JOIN owned_or_acl a ON a.objid = l.oid
  CROSS JOIN aclexplode(COALESCE(l.lanacl, acldefault('l', l.lanowner)))
  WHERE classid = 'pg_language'::regclass AND grantee = refobjid

  UNION ALL

  -- Tablespace ownership
  SELECT 'tablespace' AS on, quote_ident(t.spcname) AS name, 'OWNER' AS privilege_type
  FROM pg_tablespace t
  INNER JOIN owned_or_acl a ON a.objid = t.oid
  WHERE classid = 'pg_tablespace'::regclass AND deptype = 'o'

  UNION ALL

  -- Tablespace privileges
  SELECT 'tablespace' AS on, quote_ident(t.spcname) AS name, privilege_type
  FROM pg_tablespace t
  INNER JOIN owned_or_acl a ON a.objid = t.oid
  CROSS JOIN aclexplode(COALESCE(t.spcacl, acldefault('t', t.spcowner)))
  WHERE classid = 'pg_tablespace'::regclass AND grantee = refobjid

  UNION ALL

  -- Foreign data wrapper ownership
  SELECT 'foreign-data wrapper' AS on, quote_ident(f.fdwname) AS name, 'OWNER' AS privilege_type
  FROM pg_foreign_data_wrapper f
  INNER JOIN owned_or_acl a ON a.objid = f.oid
  WHERE classid = 'pg_foreign_data_wrapper'::regclass AND deptype = 'o'

  UNION ALL

  -- Foreign data wrapper privileges
  SELECT 'foreign-data wrapper' AS on, quote_ident(f.fdwname) AS name, privilege_type
  FROM pg_foreign_data_wrapper f
  INNER JOIN owned_or_acl a ON a.objid = f.oid
  CROSS JOIN aclexplode(COALESCE(f.fdwacl, acldefault('F', f.fdwowner)))
  WHERE classid = 'pg_foreign_data_wrapper'::regclass AND grantee = refobjid

  UNION ALL

  -- Foreign server ownership
  SELECT 'foreign server' AS on, quote_ident(f.srvname) AS name, 'OWNER' AS privilege_type
  FROM pg_foreign_server f
  INNER JOIN owned_or_acl a ON a.objid = f.oid
  WHERE classid = 'pg_foreign_server'::regclass AND deptype = 'o'

  UNION ALL

  -- Foreign server privileges
  SELECT 'foreign server' AS on, quote_ident(f.srvname) AS name, privilege_type
  FROM pg_foreign_server f
  INNER JOIN owned_or_acl a ON a.objid = f.oid
  CROSS JOIN aclexplode(COALESCE(f.srvacl, acldefault('S', f.srvowner)))
  WHERE classid = 'pg_foreign_server'::regclass AND grantee = refobjid

  UNION ALL

  -- Parameter privileges
  SELECT 'parameter' AS on, quote_ident(p.parname) AS name, privilege_type
  FROM pg_parameter_acl p
  INNER JOIN owned_or_acl a ON a.objid = p.oid
  CROSS JOIN aclexplode(p.paracl)
  WHERE classid = 'pg_parameter_acl'::regclass AND grantee = refobjid
);
