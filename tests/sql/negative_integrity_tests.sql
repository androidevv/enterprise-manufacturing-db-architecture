SET SERVEROUTPUT ON
SET VERIFY OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

-- Negative integrity regression tests for MFG_OWNER.
-- Run as MFG_OWNER against the FREEPDB1 service.
-- Test DML is rolled back; identity sequence values may still advance.

DECLARE
    v_pass_count PLS_INTEGER := 0;

    PROCEDURE expect_error(
        p_test_name     IN VARCHAR2,
        p_expected_code IN NUMBER,
        p_sql           IN VARCHAR2
    ) IS
    BEGIN
        SAVEPOINT test_start;

        BEGIN
            EXECUTE IMMEDIATE p_sql;

            ROLLBACK TO test_start;

            RAISE_APPLICATION_ERROR(
                -20001,
                'FAIL: ' || p_test_name ||
                ' did not raise the expected Oracle error.'
            );
        EXCEPTION
            WHEN OTHERS THEN
                IF SQLCODE = -20001 THEN
                    RAISE;
                ELSIF SQLCODE = p_expected_code THEN
                    ROLLBACK TO test_start;

                    DBMS_OUTPUT.PUT_LINE(
                        'PASS: ' || p_test_name ||
                        ' (ORA-' ||
                        LPAD(TO_CHAR(ABS(p_expected_code)), 5, '0') ||
                        ').'
                    );

                    v_pass_count := v_pass_count + 1;
                ELSE
                    ROLLBACK TO test_start;

                    DBMS_OUTPUT.PUT_LINE(
                        'FAIL: ' || p_test_name ||
                        '; expected ORA-' ||
                        LPAD(TO_CHAR(ABS(p_expected_code)), 5, '0') ||
                        ', received ' || SQLERRM
                    );

                    RAISE;
                END IF;
        END;
    END expect_error;

BEGIN
    expect_error(
        'Duplicate company code rejected',
        -1,
        q'[
            INSERT INTO companies (company_code, company_name)
            VALUES ('DEMO', 'Duplicate Test Company')
        ]'
    );

    expect_error(
        'Invalid item type rejected',
        -2290,
        q'[
            INSERT INTO items
                (item_code, item_name, item_type, uom_id)
            VALUES
                ('TEST_INVALID_TYPE', 'Test Invalid Type', 'INVALID', 1)
        ]'
    );

    expect_error(
        'Invalid UOM foreign key rejected',
        -2291,
        q'[
            INSERT INTO items
                (item_code, item_name, item_type, uom_id)
            VALUES
                ('TEST_INVALID_UOM', 'Test Invalid UOM', 'RAW', 999999999)
        ]'
    );

    ROLLBACK;

    DBMS_OUTPUT.PUT_LINE(
        'Negative integrity tests passed: ' ||
        v_pass_count || ' of 3.'
    );
END;
/

EXIT SUCCESS ROLLBACK
