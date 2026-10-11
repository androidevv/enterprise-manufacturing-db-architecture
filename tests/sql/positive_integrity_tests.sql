SET SERVEROUTPUT ON
SET VERIFY OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- Positive integrity tests for MFG_OWNER.
-- Valid test rows are rolled back; identity sequence values may advance.

DECLARE
    v_company_id  companies.company_id%TYPE;
    v_site_id     sites.site_id%TYPE;
    v_site_name   sites.site_name%TYPE;
    v_count       PLS_INTEGER := 0;
BEGIN
    SAVEPOINT positive_test_start;

    -- Test 1: Insert a valid company.
    INSERT INTO companies (company_code, company_name)
    VALUES ('TEST_POSITIVE_CO', 'Positive Test Company')
    RETURNING company_id INTO v_company_id;

    SELECT COUNT(*)
      INTO v_count
      FROM companies
     WHERE company_id = v_company_id
       AND company_code = 'TEST_POSITIVE_CO';

    IF v_count <> 1 THEN
        RAISE_APPLICATION_ERROR(-20011, 'FAIL: Company insert verification.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('PASS: Valid company inserted.');
    
    -- Test 2: Insert a site referencing the new company.
    INSERT INTO sites (company_id, site_code, site_name)
    VALUES (v_company_id, 'TEST_POSITIVE_SITE', 'Positive Test Site')
    RETURNING site_id INTO v_site_id;

    SELECT COUNT(*)
      INTO v_count
      FROM sites
     WHERE site_id = v_site_id
       AND company_id = v_company_id
       AND site_code = 'TEST_POSITIVE_SITE';

    IF v_count <> 1 THEN
        RAISE_APPLICATION_ERROR(-20012, 'FAIL: Site insert verification.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('PASS: Valid site inserted with company foreign key.');

    -- Test 3: Update the valid site.
    UPDATE sites
       SET site_name = 'Updated Positive Test Site'
     WHERE site_id = v_site_id;

    IF SQL%ROWCOUNT <> 1 THEN
        RAISE_APPLICATION_ERROR(-20013, 'FAIL: Expected one site to update.');
    END IF;

    SELECT site_name
      INTO v_site_name
      FROM sites
     WHERE site_id = v_site_id;

    IF v_site_name <> 'Updated Positive Test Site' THEN
        RAISE_APPLICATION_ERROR(-20014, 'FAIL: Site update verification.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('PASS: Valid site update verified.');

    -- Remove all test DML.
    ROLLBACK TO positive_test_start;

    DBMS_OUTPUT.PUT_LINE('PASS: Test transaction rolled back.');
    DBMS_OUTPUT.PUT_LINE('Positive integrity tests passed: 3 of 3.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO positive_test_start;
        RAISE;
END;
/

EXIT SUCCESS ROLLBACK
