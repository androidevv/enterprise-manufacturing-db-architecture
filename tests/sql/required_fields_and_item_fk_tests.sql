SET SERVEROUTPUT ON
SET VERIFY OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

DECLARE
    v_company_id COMPANIES.COMPANY_ID%TYPE;
    v_site_id SITES.SITE_ID%TYPE;
    v_uom_id UOMS.UOM_ID%TYPE;
    v_tests_passed PLS_INTEGER := 0;

    PROCEDURE expect_error(
        p_description IN VARCHAR2,
        p_sql IN VARCHAR2,
        p_expected_code IN NUMBER
    ) IS
        v_actual_code NUMBER := NULL;
    BEGIN
        SAVEPOINT individual_test;

        BEGIN
            EXECUTE IMMEDIATE p_sql;
        EXCEPTION
            WHEN OTHERS THEN
                v_actual_code := SQLCODE;
        END;

        ROLLBACK TO individual_test;

        IF v_actual_code = p_expected_code THEN
            DBMS_OUTPUT.PUT_LINE('PASS: ' || p_description);
            v_tests_passed := v_tests_passed + 1;
        ELSIF v_actual_code IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('FAIL: ' || p_description ||
                                 ' unexpectedly succeeded.');
            RAISE_APPLICATION_ERROR(-20001,
                'Expected Oracle error ' || p_expected_code);
        ELSE
            DBMS_OUTPUT.PUT_LINE('FAIL: ' || p_description ||
                '; expected ' || p_expected_code ||
                ', received ' || v_actual_code);
            RAISE_APPLICATION_ERROR(-20002,
                'Unexpected Oracle error for ' || p_description);
        END IF;
    END expect_error;

BEGIN
    SAVEPOINT test_suite;

    SELECT company_id INTO v_company_id
    FROM companies WHERE ROWNUM = 1;

    SELECT site_id INTO v_site_id
    FROM sites WHERE ROWNUM = 1;

    SELECT uom_id INTO v_uom_id
    FROM uoms WHERE ROWNUM = 1;

    expect_error(
        'COMPANIES rejects NULL COMPANY_NAME',
        'INSERT INTO companies (company_code, company_name)
         VALUES (''TST_REQ_CO_NM'', NULL)',
        -1400
    );

    expect_error(
        'CUSTOMERS rejects NULL CUSTOMER_NAME',
        'INSERT INTO customers (customer_code, customer_name)
         VALUES (''TST_REQ_CUST_NM'', NULL)',
        -1400
    );

    expect_error(
        'ITEMS rejects NULL ITEM_NAME',
        'INSERT INTO items (item_code, item_name, item_type, uom_id)
         VALUES (''TST_REQ_ITEM_NM'', NULL, ''RAW'', ' ||
         v_uom_id || ')',
        -1400
    );

    expect_error(
        'ITEMS rejects NULL ITEM_TYPE',
        'INSERT INTO items (item_code, item_name, item_type, uom_id)
         VALUES (''TST_REQ_ITEM_TY'', ''Test item'', NULL, ' ||
         v_uom_id || ')',
        -1400
    );

    expect_error(
        'ITEMS rejects NULL UOM_ID',
        'INSERT INTO items (item_code, item_name, item_type, uom_id)
         VALUES (''TST_REQ_ITEM_UO'', ''Test item'', ''RAW'', NULL)',
        -1400
    );

    expect_error(
        'SITES rejects NULL SITE_NAME',
        'INSERT INTO sites (company_id, site_code, site_name)
         VALUES (' || v_company_id ||
         ', ''TST_REQ_SITE_NM'', NULL)',
        -1400
    );

    expect_error(
        'SUPPLIERS rejects NULL SUPPLIER_NAME',
        'INSERT INTO suppliers (supplier_code, supplier_name)
         VALUES (''TST_REQ_SUP_NM'', NULL)',
        -1400
    );

    expect_error(
        'UOMS rejects NULL UOM_NAME',
        'INSERT INTO uoms (uom_code, uom_name)
         VALUES (''QZ'', NULL)',
        -1400
    );

    expect_error(
        'WAREHOUSES rejects NULL WAREHOUSE_NAME',
        'INSERT INTO warehouses (site_id, warehouse_code, warehouse_name)
         VALUES (' || v_site_id ||
         ', ''TST_REQ_WH_NM'', NULL)',
        -1400
    );

    expect_error(
        'ITEMS rejects nonexistent UOM_ID',
        'INSERT INTO items (item_code, item_name, item_type, uom_id)
         VALUES (''TST_BAD_ITEM_UOM'', ''Test item'', ''RAW'', -999999)',
        -2291
    );

    ROLLBACK TO test_suite;

    DBMS_OUTPUT.PUT_LINE(
        'Required-field and item-FK tests passed: ' ||
        v_tests_passed || ' of 10.'
    );

    IF v_tests_passed <> 10 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Not all tests passed.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('PASS: Test changes rolled back.');
    ROLLBACK;
END;
/

EXIT SUCCESS ROLLBACK