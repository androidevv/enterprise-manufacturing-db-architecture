SET SERVEROUTPUT ON
SET VERIFY OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- Expanded negative integrity regression tests for MFG_OWNER.
-- Uses existing business codes and valid parent IDs.
-- All test DML is rolled back. Identity sequence values may advance.

DECLARE
    v_company_code   companies.company_code%TYPE;
    v_customer_code  customers.customer_code%TYPE;
    v_item_code      items.item_code%TYPE;
    v_site_code      sites.site_code%TYPE;
    v_supplier_code  suppliers.supplier_code%TYPE;
    v_uom_code       uoms.uom_code%TYPE;
    v_warehouse_code warehouses.warehouse_code%TYPE;

    v_company_id companies.company_id%TYPE;
    v_site_id    sites.site_id%TYPE;
    v_uom_id     uoms.uom_id%TYPE;

    v_pass_count PLS_INTEGER := 0;

    PROCEDURE expect_error(
        p_test_name     IN VARCHAR2,
        p_expected_code IN NUMBER,
        p_sql           IN VARCHAR2
    ) IS
    BEGIN
        SAVEPOINT individual_test;

        BEGIN
            EXECUTE IMMEDIATE p_sql;

            ROLLBACK TO individual_test;

            RAISE_APPLICATION_ERROR(
                -20001,
                'FAIL: ' || p_test_name ||
                ' unexpectedly succeeded.'
            );
        EXCEPTION
            WHEN OTHERS THEN
                IF SQLCODE = -20001 THEN
                    RAISE;
                ELSIF SQLCODE = p_expected_code THEN
                    ROLLBACK TO individual_test;
                    v_pass_count := v_pass_count + 1;
                    DBMS_OUTPUT.PUT_LINE('PASS: ' || p_test_name);
                ELSE
                    ROLLBACK TO individual_test;
                    DBMS_OUTPUT.PUT_LINE(
                        'FAIL: ' || p_test_name || ' - ' || SQLERRM
                    );
                    RAISE;
                END IF;
        END;
    END expect_error;

BEGIN
    SAVEPOINT expanded_test_start;

    -- Retrieve existing codes and valid parent IDs.
    SELECT company_code INTO v_company_code
      FROM companies WHERE ROWNUM = 1;

    SELECT customer_code INTO v_customer_code
      FROM customers WHERE ROWNUM = 1;

    SELECT item_code INTO v_item_code
      FROM items WHERE ROWNUM = 1;

    SELECT site_code INTO v_site_code
      FROM sites WHERE ROWNUM = 1;

    SELECT supplier_code INTO v_supplier_code
      FROM suppliers WHERE ROWNUM = 1;

    SELECT uom_code INTO v_uom_code
      FROM uoms WHERE ROWNUM = 1;

    SELECT warehouse_code INTO v_warehouse_code
      FROM warehouses WHERE ROWNUM = 1;

    SELECT company_id INTO v_company_id
      FROM sites WHERE ROWNUM = 1;

    SELECT site_id INTO v_site_id
      FROM warehouses WHERE ROWNUM = 1;

    SELECT uom_id INTO v_uom_id
      FROM items WHERE ROWNUM = 1;

    -- 1-7: Duplicate business codes must be rejected.
    expect_error(
        'Duplicate COMPANIES.COMPANY_CODE',
        -1,
        'INSERT INTO companies (company_code, company_name) VALUES (' ||
        DBMS_ASSERT.ENQUOTE_LITERAL(v_company_code) ||
        ', ''Duplicate Test'')'
    );

    expect_error(
        'Duplicate CUSTOMERS.CUSTOMER_CODE',
        -1,
        'INSERT INTO customers (customer_code, customer_name) VALUES (' ||
        DBMS_ASSERT.ENQUOTE_LITERAL(v_customer_code) ||
        ', ''Duplicate Test'')'
    );

    expect_error(
        'Duplicate ITEMS.ITEM_CODE',
        -1,
        'INSERT INTO items (item_code, item_name, item_type, uom_id) VALUES (' ||
        DBMS_ASSERT.ENQUOTE_LITERAL(v_item_code) ||
        ', ''Duplicate Test'', ''RAW'', ' || TO_CHAR(v_uom_id) || ')'
    );

    expect_error(
        'Duplicate SITES.SITE_CODE',
        -1,
        'INSERT INTO sites (company_id, site_code, site_name) VALUES (' ||
        TO_CHAR(v_company_id) || ', ' ||
        DBMS_ASSERT.ENQUOTE_LITERAL(v_site_code) ||
        ', ''Duplicate Test'')'
    );

    expect_error(
        'Duplicate SUPPLIERS.SUPPLIER_CODE',
        -1,
        'INSERT INTO suppliers (supplier_code, supplier_name) VALUES (' ||
        DBMS_ASSERT.ENQUOTE_LITERAL(v_supplier_code) ||
        ', ''Duplicate Test'')'
    );

    expect_error(
        'Duplicate UOMS.UOM_CODE',
        -1,
        'INSERT INTO uoms (uom_code, uom_name) VALUES (' ||
        DBMS_ASSERT.ENQUOTE_LITERAL(v_uom_code) ||
        ', ''Duplicate Test'')'
    );

    expect_error(
        'Duplicate WAREHOUSES.WAREHOUSE_CODE',
        -1,
        'INSERT INTO warehouses (site_id, warehouse_code, warehouse_name) VALUES (' ||
        TO_CHAR(v_site_id) || ', ' ||
        DBMS_ASSERT.ENQUOTE_LITERAL(v_warehouse_code) ||
        ', ''Duplicate Test'')'
    );

    -- 8-14: Required business-code columns must reject NULL.
    expect_error(
        'COMPANIES rejects NULL company code',
        -1400,
        'INSERT INTO companies (company_code, company_name) VALUES (NULL, ''Test'')'
    );

    expect_error(
        'CUSTOMERS rejects NULL customer code',
        -1400,
        'INSERT INTO customers (customer_code, customer_name) VALUES (NULL, ''Test'')'
    );

    expect_error(
        'ITEMS rejects NULL item code',
        -1400,
        'INSERT INTO items (item_code, item_name, item_type, uom_id) VALUES (NULL, ''Test'', ''RAW'', ' ||
        TO_CHAR(v_uom_id) || ')'
    );

    expect_error(
        'SITES rejects NULL site code',
        -1400,
        'INSERT INTO sites (company_id, site_code, site_name) VALUES (' ||
        TO_CHAR(v_company_id) || ', NULL, ''Test'')'
    );

    expect_error(
        'SUPPLIERS rejects NULL supplier code',
        -1400,
        'INSERT INTO suppliers (supplier_code, supplier_name) VALUES (NULL, ''Test'')'
    );

    expect_error(
        'UOMS rejects NULL UOM code',
        -1400,
        'INSERT INTO uoms (uom_code, uom_name) VALUES (NULL, ''Test'')'
    );

    expect_error(
        'WAREHOUSES rejects NULL warehouse code',
        -1400,
        'INSERT INTO warehouses (site_id, warehouse_code, warehouse_name) VALUES (' ||
        TO_CHAR(v_site_id) || ', NULL, ''Test'')'
    );

    -- 15-16: Invalid foreign keys must be rejected.
    expect_error(
        'SITES rejects nonexistent COMPANY_ID',
        -2291,
        'INSERT INTO sites (company_id, site_code, site_name) VALUES ' ||
        '(999999999, ''TEST_BAD_COMPANY_FK'', ''Test'')'
    );

    expect_error(
        'WAREHOUSES rejects nonexistent SITE_ID',
        -2291,
        'INSERT INTO warehouses (site_id, warehouse_code, warehouse_name) VALUES ' ||
        '(999999999, ''TEST_BAD_SITE_FK'', ''Test'')'
    );

    ROLLBACK TO expanded_test_start;

    DBMS_OUTPUT.PUT_LINE(
        'Expanded negative tests passed: ' || v_pass_count || ' of 16.'
    );
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO expanded_test_start;
        RAISE;
END;
/

EXIT SUCCESS ROLLBACK
