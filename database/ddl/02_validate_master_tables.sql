WHENEVER SQLERROR EXIT SQL.SQLCODE
WHENEVER OSERROR EXIT FAILURE
SET SERVEROUTPUT ON
SET VERIFY OFF

DECLARE
    l_tables       PLS_INTEGER;
    l_primary_keys PLS_INTEGER;
    l_unique_keys  PLS_INTEGER;
    l_foreign_keys PLS_INTEGER;
    l_item_check   PLS_INTEGER;
BEGIN
    SELECT COUNT(*)
      INTO l_tables
      FROM USER_TABLES
     WHERE TABLE_NAME IN (
         'COMPANIES', 'UOMS', 'CUSTOMERS', 'SUPPLIERS',
         'SITES', 'ITEMS', 'WAREHOUSES'
     );

    SELECT COUNT(*) INTO l_primary_keys
      FROM USER_CONSTRAINTS
     WHERE CONSTRAINT_TYPE = 'P'
       AND TABLE_NAME IN (
         'COMPANIES', 'UOMS', 'CUSTOMERS', 'SUPPLIERS',
         'SITES', 'ITEMS', 'WAREHOUSES'
     );

    SELECT COUNT(*) INTO l_unique_keys
      FROM USER_CONSTRAINTS
     WHERE CONSTRAINT_TYPE = 'U'
       AND TABLE_NAME IN (
         'COMPANIES', 'UOMS', 'CUSTOMERS', 'SUPPLIERS',
         'SITES', 'ITEMS', 'WAREHOUSES'
     );

    SELECT COUNT(*) INTO l_foreign_keys
      FROM USER_CONSTRAINTS
     WHERE CONSTRAINT_TYPE = 'R'
       AND TABLE_NAME IN (
         'COMPANIES', 'UOMS', 'CUSTOMERS', 'SUPPLIERS',
         'SITES', 'ITEMS', 'WAREHOUSES'
     );

    SELECT COUNT(*) INTO l_item_check
      FROM USER_CONSTRAINTS
     WHERE TABLE_NAME = 'ITEMS'
       AND CONSTRAINT_TYPE = 'C'
       AND UPPER(SEARCH_CONDITION_VC) LIKE '%RAW%'
       AND UPPER(SEARCH_CONDITION_VC) LIKE '%FINISHED%'
       AND UPPER(SEARCH_CONDITION_VC) LIKE '%ITEM_TYPE%';

    DBMS_OUTPUT.PUT_LINE('Tables: ' || l_tables);
    DBMS_OUTPUT.PUT_LINE('Primary keys: ' || l_primary_keys);
    DBMS_OUTPUT.PUT_LINE('Unique constraints: ' || l_unique_keys);
    DBMS_OUTPUT.PUT_LINE('Foreign keys: ' || l_foreign_keys);
    DBMS_OUTPUT.PUT_LINE('ITEM_TYPE check: ' || l_item_check);

    IF l_tables <> 7
       OR l_primary_keys <> 7
       OR l_unique_keys <> 7
       OR l_foreign_keys <> 3
       OR l_item_check <> 1
    THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Master-data schema validation failed.'
        );
    END IF;

    DBMS_OUTPUT.PUT_LINE('VALIDATION PASSED');
END;
/
EXIT SUCCESS