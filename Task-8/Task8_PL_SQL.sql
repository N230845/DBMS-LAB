-- Task1
SET SERVEROUTPUT ON;
BEGIN 
    DBMS_OUTPUT.PUT_LINE('Welcome to PlaySToreDB');
END;
/
-- Task3
SET SERVEROUTPUT ON;
DECLARE
    v_name Apps.AppName%TYPE;
    v_rating Apps.Rating%TYPE;
BEGIN
    SELECT AppName,Rating INTO v_name,v_rating FROM Apps WHERE AppID=1001;
    DBMS_OUTPUT.PUT_LINE('Application Name:'|| v_name);
    DBMS_OUTPUT.PUT_LINE('Application Rating:'|| v_rating);
END;
/

-- LEVEL 0
-- 1
SET SERVEROUTPUT ON;
DECLARE 
    v_name Apps.AppName%TYPE;
    v_price Apps.Price%TYPE;
    v_discount NUMBER;
BEGIN
    SELECT AppName,Price INTO v_name,v_price FROM Apps WHERE AppID=1006;
    v_discount:=v_price*0.10;
    DBMS_OUTPUT.PUT_LINE('Application Name:'|| v_name);
    DBMS_OUTPUT.PUT_LINE('Application Price:'|| v_price);
    DBMS_OUTPUT.PUT_LINE('10% of Price:'|| v_discount);
END;
/

-- 2
SET SERVEROUTPUT ON;
DECLARE
    v_name Apps.AppName%TYPE;
    v_rating Apps.Rating%TYPE;
    v_price Apps.Price%TYPE;
    v_downloads Apps.Downloads%TYPE;
BEGIN
    SELECT AppNAme,Rating,Price,Downloads INTO v_name,v_rating,v_price,v_downloads FROM Apps WHERE AppID=1006;
    DBMS_OUTPUT.PUT_LINE('Application Name:'|| v_name);
    DBMS_OUTPUT.PUT_LINE('Application Rating:'|| v_rating);
    DBMS_OUTPUT.PUT_LINE('Application Price:'|| v_price);
    DBMS_OUTPUT.PUT_LINE('Application Downloads:'|| v_downloads);
END;
/

-- 3
SET SERVEROUTPUT ON;
DECLARE 
    v_rating NUMBER:=4.6;
BEGIN
    IF v_rating>=4.5 THEN DBMS_OUTPUT.PUT_LINE('HIghly Rated');
    ELSIF v_rating >=3.5 THEN DBMS_OUTPUT.PUT_LINE('Moderately Rated');
    ELSE DBMS_OUTPUT.PUT_LINE('Low Rated');
    END IF;
END;
/

-- 4
CREATE FUNCTION check_app_price(p_price NUMBER)
RETURN VARCHAR2
IS
BEGIN   
    IF p_price>0 THEN RETURN 'Paid App';
    ELSE RETURN 'Free App';
    END IF;
END;
/
SELECT check_app_price(100) AS Application_Type FROM dual;
SELECT check_app_price(0) AS Application_Type FROM dual;

-- 5
SET SERVEROUTPUT ON;
DECLARE v_num NUMBER:=1;
BEGIN
    LOOP 
        DBMS_OUTPUT.PUT_LINE(v_num);
        v_num:=v_num+1;
        EXIT WHEN v_num>10;
    END LOOP;
END;
/
     
-- LEVEL 1
-- 1
SET SERVEROUTPUT ON;
CREATE PROCEDURE classify_app_rating(p_app_id IN NUMBER)
IS 
    v_rating Apps.Rating%TYPE;
BEGIN 
    SELECT Rating INTO v_rating FROM Apps WHERE AppID=p_app_id;
    IF v_rating >=4.5 THEN
        DBMS_OUTPUT.PUT_LINE('Excellent Application');
    ELSIF v_rating>=4.0 THEN
        DBMS_OUTPUT.PUT_LINE('Good Application');
    ELSIF v_rating>=3.5 THEN 
        DBMS_OUTPUT.PUT_LINE('Average Application');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Low Rated Application');
    END IF;
END;
/
EXEC classify_app_rating(1005);

-- 2
SET SERVEROUTPUT ON;
CREATE FUNCTION get_rating_apps(p_app_id NUMBER)
RETURN NUMBER
IS
    v_rating Apps.Rating%TYPE;
BEGIN 
    SELECT Rating INTO v_rating FROM Apps WHERE AppID=p_app_id;
    RETURN v_rating;
END;
/
SELECT get_rating_apps(1005) AS Rating FROM dual;
select AppName,get_rating_apps(1005) AS Rating FROM Apps;

-- LEVEL 2
-- 1
SET SERVEROUTPUT ON;
DECLARE 
    CURSOR app_cursor IS
        SELECT AppName,Rating,Price,Downloads FROM Apps;
BEGIN
    FOR app_rec IN app_cursor
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Application Name: ' || app_rec.AppName ||
            ' | Rating: ' || app_rec.Rating ||
            ' | Price: ' || app_rec.Price ||
            ' | Downloads: ' || app_rec.Downloads
        );
    END LOOP;
END;
/

-- 2
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE find_application(p_app_id IN NUMBER)
IS
    v_name Apps.AppName%TYPE;
    v_rating Apps.Rating%TYPE;
    v_price Apps.Price%TYPE;
BEGIN
    SELECT AppName,Rating,Price INTO v_name,v_rating,v_price 
    FROM Apps WHERE AppID=p_app_id;
    DBMS_OUTPUT.PUT_LINE('Application NAme:' ||v_name);
    DBMS_OUTPUT.PUT_LINE('Rating: ' || v_rating);
    DBMS_OUTPUT.PUT_LINE('Price: ' || v_price);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Application not found');
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('An error occured');
END ;
/
EXEC find_application(1008);
EXEC find_application(2000);
   
-- Optional
-- 1
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE update_app_rating(p_app_id IN NUMBER,p_new_rating IN NUMBER)
IS 
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM Apps WHERE AppID=p_app_id;
    IF v_count >0 THEN
        UPDATE Apps SET Rating=p_new_rating WHERE AppID=p_app_id;
        DBMS_OUTPUT.PUT_LINE('Rating updated successfully');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Application not found');
    END IF;
END;
/
EXEC update_app_rating(1001,6.8);

-- 2
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE classify_using_case(p_rating IN NUMBER)
IS v_category VARCHAR2(30);
BEGIN
    v_category :=
        CASE 
            WHEN p_rating>= 4.5 THEN 'Excellent'
            WHEN p_rating >= 4.0 THEN 'Good'
            WHEN p_rating >= 3.5 THEN 'Average'
            ELSE 'Low Rated'
        END;
    DBMS_OUTPUT.PUT_LINE('Classification: ' || v_category);
END;
/
EXEC classify_using_case(4.7);

-- 3
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE display_app_developer(p_app_id IN NUMBER)
IS
    v_app_id Apps.AppID%TYPE;
    v_app_name Apps.AppName%TYPE;
    v_rating Apps.Rating%TYPE;
    v_price Apps.Price%TYPE;
    v_developer_id Developers.DeveloperID%TYPE;
    v_developer_name Developers.DeveloperName%TYPE;
    v_country Developers.Country%TYPE;
BEGIN
    SELECT A.AppID, A.AppName, A.Rating, A.Price,
           D.DeveloperID, D.DeveloperName, D.Country
    INTO v_app_id, v_app_name, v_rating, v_price,
         v_developer_id, v_developer_name, v_country
    FROM Apps A JOIN Developers D ON A.DeveloperID = D.DeveloperID
    WHERE A.AppID = p_app_id;
    DBMS_OUTPUT.PUT_LINE('App ID: ' || v_app_id);
    DBMS_OUTPUT.PUT_LINE('App Name: ' || v_app_name);
    DBMS_OUTPUT.PUT_LINE('Rating: ' || v_rating);
    DBMS_OUTPUT.PUT_LINE('Price: ' || v_price);
    DBMS_OUTPUT.PUT_LINE('Developer ID: ' || v_developer_id);
    DBMS_OUTPUT.PUT_LINE('Developer Name: ' || v_developer_name);
    DBMS_OUTPUT.PUT_LINE('Country: ' || v_country);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Application or developer details not found');
END;
/
EXEC display_app_developer(1003);

-- 4
SET SERVEROUTPUT ON;
DECLARE
    CURSOR app_cursor IS
        SELECT AppID, AppName, Rating, Downloads
        FROM Apps;
BEGIN
    FOR app_rec IN app_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('App ID: ' || app_rec.AppID ||
            ' | App Name: ' || app_rec.AppName ||
            ' | Rating: ' || app_rec.Rating ||
            ' | Downloads: ' || app_rec.Downloads
        );
    END LOOP;
END;
/

-- 5
SET SERVEROUTPUT ON;
CREATE OR REPLACE FUNCTION get_rating_classification(p_rating IN NUMBER)
RETURN VARCHAR2
IS
BEGIN
    RETURN
        CASE
            WHEN p_rating >= 4.5 THEN 'Excellent'
            WHEN p_rating >= 4.0 THEN 'Good'
            WHEN p_rating >= 3.5 THEN 'Average'
            ELSE 'Low Rated'
        END;
END;
/
SELECT get_rating_classification(4.7) AS Classification FROM dual;
SELECT AppID,AppName,Rating,get_rating_classification(Rating) AS Classification FROM Apps;