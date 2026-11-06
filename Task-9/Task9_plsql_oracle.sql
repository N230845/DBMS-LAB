SET SERVEROUTPUT ON;
--  Task A
-- Rating classification function
CREATE OR REPLACE FUNCTION classify_rating(p_rating IN NUMBER)
RETURN VARCHAR2 IS
BEGIN
  IF p_rating IS NULL THEN RETURN 'Not Rated';
  ELSIF p_rating<0 OR p_rating>5 THEN RETURN 'Invalid Rating';
  ELSIF p_rating>=4.5 THEN RETURN 'Excellent';
  ELSIF p_rating>=4.0 THEN RETURN 'Very Good';
  ELSIF p_rating>=3.0 THEN RETURN 'Good';
  ELSE RETURN 'Needs Improvement';
  END IF;
END;
/
-- Test including NULL
BEGIN
  DBMS_OUTPUT.PUT_LINE('Rating tests:');
  DBMS_OUTPUT.PUT_LINE('4.8='||classify_rating(4.8));
  DBMS_OUTPUT.PUT_LINE('4.2='||classify_rating(4.2));
  DBMS_OUTPUT.PUT_LINE('3.5='||classify_rating(3.5));
  DBMS_OUTPUT.PUT_LINE('2.4='||classify_rating(2.4));
  DBMS_OUTPUT.PUT_LINE('NULL='||classify_rating(NULL));
END;
/

--  Task B 
--  Individual application details
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE application_details(p_application_id IN Apps.AppID%TYPE) 
IS
    v_name Apps.AppName%TYPE; 
    v_rating Apps.Rating%TYPE; 
    v_price Apps.Price%TYPE;
    v_downloads Apps.Downloads%TYPE; 
    v_developer Developers.DeveloperName%TYPE;
    v_publisher Publishers.PublisherName%TYPE;
    v_category Categories.CategoryName%TYPE;
BEGIN
    SELECT a.AppName,a.Rating,a.Price,a.Downloads,d.DeveloperName,p.PublisherName,c.CategoryName
    INTO v_name,v_rating,v_price,v_downloads,v_developer,v_publisher,v_category FROM Apps a JOIN Developers d ON d.DeveloperID=a.DeveloperID
    JOIN Publishers p ON p.PublisherID=a.PublisherID JOIN Categories c ON c.CategoryID=a.CategoryID WHERE a.AppID=p_application_id;
    DBMS_OUTPUT.PUT_LINE('Application ID:'||p_application_id);
    DBMS_OUTPUT.PUT_LINE('Application Name:'||v_name);
    DBMS_OUTPUT.PUT_LINE('Rating:'||NVL(TO_CHAR(v_rating),'NULL'));
    DBMS_OUTPUT.PUT_LINE('Price:'||v_price||' | Downloads: '||v_downloads);
    DBMS_OUTPUT.PUT_LINE('Developer:'||v_developer||' | Publisher: '||v_publisher||' | Category: '||v_category);
EXCEPTION WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Application not found');
          WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('Data error: duplicate application ID');
          WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Application details error: '||SQLERRM);
END;
/
--  Task C
--  Developer application count
SET SERVEROUTPUT ON;
CREATE OR REPLACE FUNCTION get_developer_app_count(p_developer_id IN Developers.DeveloperID%TYPE)
RETURN NUMBER IS v_count NUMBER;
BEGIN 
    SELECT COUNT(*) INTO v_count FROM Apps WHERE DeveloperID=p_developer_id; 
    RETURN v_count;
END;
/
SELECT d.DeveloperID, d.DeveloperName, get_developer_app_count(d.DeveloperID) AS NumberOfApplications
FROM Developers d ORDER BY d.DeveloperID;

-- Level 1 
-- Q1: category summary
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE category_application_summary(p_category_id IN Categories.CategoryID%TYPE) 
IS
    v_name Categories.CategoryName%TYPE; 
    v_total NUMBER;
    v_free NUMBER; 
    v_paid NUMBER; 
    v_avg NUMBER;
BEGIN
    SELECT CategoryName INTO v_name FROM Categories WHERE CategoryID=p_category_id;
    SELECT COUNT(*),NVL(SUM(CASE WHEN Price=0 THEN 1 ELSE 0 END),0),NVL(SUM(CASE WHEN Price>0 THEN 1 ELSE 0 END),0), AVG(Rating)
    INTO v_total,v_free,v_paid,v_avg FROM Apps WHERE CategoryID=p_category_id;
    DBMS_OUTPUT.PUT_LINE('Category:'||v_name||'| Total:'||v_total||'| Free:'||v_free||'|Paid:'||v_paid||'| Average rating:'||NVL(TO_CHAR(ROUND(v_avg,2)),'N/A'));
EXCEPTION 
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Category not found');
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Category summary error:'||SQLERRM);
END;
/

-- 2: price classification and query
SET SERVEROUTPUT ON;
CREATE OR REPLACE FUNCTION classify_app_price(p_price IN NUMBER) 
RETURN VARCHAR2 IS
BEGIN
    IF p_price IS NULL THEN RETURN 'Unknown';
    ELSIF p_price < 0 THEN RETURN 'Invalid Price';
    ELSIF p_price=0 THEN RETURN 'Free';
    ELSIF p_price<=100 THEN RETURN 'Budget';
    ELSIF p_price<=500 THEN RETURN 'Premium';
    ELSE RETURN 'High Premium';
    END IF;
END;
/
SELECT AppID,AppName,Price,classify_app_price(Price) AS PriceCategory FROM Apps ORDER BY AppID;

-- 3: rating decision
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE application_rating_decision(p_app_id IN Apps.AppID%TYPE) 
IS
    v_rating Apps.Rating%TYPE;
BEGIN
    SELECT Rating INTO v_rating FROM Apps WHERE AppID=p_app_id;
    IF v_rating IS NULL THEN DBMS_OUTPUT.PUT_LINE('Rating Not Available');
    ELSIF v_rating>=4.5 THEN DBMS_OUTPUT.PUT_LINE('Highly Rated Application');
    ELSIF v_rating>=4.0 THEN DBMS_OUTPUT.PUT_LINE('Good Application');
    ELSIF v_rating>=3.0 THEN DBMS_OUTPUT.PUT_LINE('Average Application');
    ELSE DBMS_OUTPUT.PUT_LINE('Low Rated Application'); END IF;
EXCEPTION 
WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Application not found');
END;
/
EXEC application_rating_decision(1001);

-- Level 2 
-- 1: counter loops
SET SERVEROUTPUT ON;
BEGIN
  DECLARE i PLS_INTEGER:=1; 
    BEGIN
    LOOP DBMS_OUTPUT.PUT_LINE('Simple LOOP: application review #'||i); 
    EXIT WHEN i>=10; i:=i+1;
    END LOOP;
    i:=1; 
    WHILE i<=10 
    LOOP DBMS_OUTPUT.PUT_LINE('WHILE LOOP: application review #'||i); i:=i+1; 
    END LOOP;
    FOR j IN 1..10 
    LOOP DBMS_OUTPUT.PUT_LINE('FOR LOOP: application review #'||j); 
    END LOOP;
    END;
END;
/

-- 2: explicit cursor, attributes, and cursor FOR LOOP
SET SERVEROUTPUT ON;
DECLARE CURSOR c_apps IS SELECT AppID,AppName,Rating,Price,Downloads FROM Apps ORDER BY AppID;
    v_row c_apps%ROWTYPE;
BEGIN
    OPEN c_apps; 
    DBMS_OUTPUT.PUT_LINE('Cursor open='||CASE WHEN c_apps%ISOPEN THEN 'YES' ELSE 'NO' END);
    LOOP 
    FETCH c_apps INTO v_row; 
    EXIT WHEN c_apps%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_row.AppID||' | '||v_row.AppName||' | '||NVL(TO_CHAR(v_row.Rating),'NULL')||
      ' | '||v_row.Price||' | '||v_row.Downloads||' (row '||c_apps%ROWCOUNT||')');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Fetched rows='||c_apps%ROWCOUNT||' found='||CASE WHEN c_apps%FOUND THEN 'YES' ELSE 'NO' END);
    CLOSE c_apps;
    FOR r IN (SELECT AppID,AppName,Rating,Price,Downloads FROM Apps ORDER BY AppID) LOOP
    DBMS_OUTPUT.PUT_LINE('FOR: '||r.AppID||' | '||r.AppName||' | '||NVL(TO_CHAR(r.Rating),'NULL')||' | '||r.Price||' | '||r.Downloads);
    END LOOP;
END;
/

-- 3: validate and update rating
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE update_app_rating(p_application_id IN Apps.AppID%TYPE,p_new_rating IN NUMBER)
IS
    v_name Apps.AppName%TYPE;
    v_rating Apps.Rating%TYPE;
BEGIN
    IF p_new_rating IS NULL OR p_new_rating<0 OR p_new_rating>5 THEN
    DBMS_OUTPUT.PUT_LINE('Invalid application rating'); RETURN; END IF;
    UPDATE Apps SET Rating=p_new_rating WHERE AppID=p_application_id;
    IF SQL%ROWCOUNT=0 THEN
    DBMS_OUTPUT.PUT_LINE('Application not found');
    RETURN; 
    END IF;
    SELECT AppName,Rating INTO v_name,v_rating FROM Apps WHERE AppID=p_application_id;
    DBMS_OUTPUT.PUT_LINE('Updated: '||p_application_id||' | '||v_name||' | rating='||v_rating);
EXCEPTION 
WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Update failed: '||SQLERRM); 
RAISE;
END;
/
 EXEC update_app_rating(1001,4.5);
 
 
-- 4: IN and IN OUT download update
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE update_download_count(p_application_id IN Apps.AppID%TYPE,p_additional_downloads IN NUMBER,p_total_downloads IN OUT NUMBER) 
IS 
    v_existing Apps.Downloads%TYPE;
BEGIN
    IF p_additional_downloads<0 THEN 
    RAISE_APPLICATION_ERROR(-20001,'Additional downloads cannot be negative');
    END IF;
    SELECT Downloads INTO v_existing FROM Apps WHERE AppID=p_application_id;
    p_total_downloads:=NVL(v_existing,0)+p_additional_downloads;
    UPDATE Apps SET Downloads=p_total_downloads WHERE AppID=p_application_id;
    DBMS_OUTPUT.PUT_LINE('Updated download count: '||p_total_downloads);
EXCEPTION 
WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Application not found');
WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Download update error: '||SQLERRM); RAISE;
END;
/
DECLARE n NUMBER:=0; 
BEGIN
    update_download_count(1001,100,n); 
    DBMS_OUTPUT.PUT_LINE('OUT='||n); 
END;
/
-- 5: exception handling example
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE application_exception_report(p_application_id IN Apps.AppID%TYPE) 
IS
    v_name Apps.AppName%TYPE;
    v_rating Apps.Rating%TYPE; 
    v_price Apps.Price%TYPE; 
    v_downloads Apps.Downloads%TYPE;
BEGIN
    SELECT AppName,Rating,Price,Downloads INTO v_name,v_rating,v_price,v_downloads FROM Apps WHERE AppID=p_application_id;
    DBMS_OUTPUT.PUT_LINE(v_name||' | rating='||NVL(TO_CHAR(v_rating),'NULL')||' | price='||v_price||' | downloads='||v_downloads);
EXCEPTION WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Application not found');
          WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('Data error: multiple rows found');
          WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Unexpected database error: '||SQLERRM);
END;
/
EXEC application_exception_report(1009);


-- Level 3 
-- 1: complete application report
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE process_application(p_application_id IN Apps.AppID%TYPE) 
IS
    v_name Apps.AppName%TYPE; 
    v_rating Apps.Rating%TYPE; 
    v_price Apps.Price%TYPE;
    v_downloads Apps.Downloads%TYPE;
    v_developer Developers.DeveloperName%TYPE; 
    v_publisher Publishers.PublisherName%TYPE; 
    v_category Categories.CategoryName%TYPE;
BEGIN
    SELECT a.AppName,a.Rating,a.Price,a.Downloads,d.DeveloperName,p.PublisherName,c.CategoryName
    INTO v_name,v_rating,v_price,v_downloads,v_developer,v_publisher,v_category
    FROM Apps a JOIN Developers d ON d.DeveloperID=a.DeveloperID JOIN Publishers p ON p.PublisherID=a.PublisherID
    JOIN Categories c ON c.CategoryID=a.CategoryID WHERE a.AppID=p_application_id;
    
    DBMS_OUTPUT.PUT_LINE('----------------------------------------'); 
    DBMS_OUTPUT.PUT_LINE('APPLICATION DETAILS REPORT');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Application ID    : '||p_application_id); 
    DBMS_OUTPUT.PUT_LINE('Application Name  : '||v_name);
    DBMS_OUTPUT.PUT_LINE('Developer Name    : '||v_developer);
    DBMS_OUTPUT.PUT_LINE('Publisher Name    : '||v_publisher);
    DBMS_OUTPUT.PUT_LINE('Category Name     : '||v_category); 
    DBMS_OUTPUT.PUT_LINE('Rating            : '||NVL(TO_CHAR(v_rating),'NULL'));
    DBMS_OUTPUT.PUT_LINE('Rating Category   : '||classify_rating(v_rating));
    DBMS_OUTPUT.PUT_LINE('Price             : '||v_price);
    DBMS_OUTPUT.PUT_LINE('Price Category    : '||CASE classify_app_price(v_price) WHEN 'Free' THEN 'Free Application' WHEN 'Budget' THEN 'Budget Application' WHEN 'Premium' THEN 'Premium Application' ELSE 'High Premium Application' END);
    DBMS_OUTPUT.PUT_LINE('Downloads         : '||v_downloads); 
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
EXCEPTION WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Application not found');
          WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('Data error: duplicate application ID');
          WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Processing error: '||SQLERRM);
END;
/
EXEC process_application(1003);


-- 2: aggregate cursor over developers with applications
SET SERVEROUT ON;
DECLARE CURSOR c_devs 
IS 
    SELECT d.DeveloperID,d.DeveloperName,COUNT(a.AppID) app_count,AVG(a.Rating) avg_rating,NVL(SUM(a.Downloads),0) downloads
    FROM Developers d JOIN Apps a ON a.DeveloperID=d.DeveloperID GROUP BY d.DeveloperID,d.DeveloperName ORDER BY d.DeveloperID;
BEGIN
    FOR r IN c_devs
    LOOP 
        DBMS_OUTPUT.PUT_LINE(r.DeveloperID||' | '||r.DeveloperName||' | Apps='||r.app_count||' | Avg rating='||NVL(TO_CHAR(ROUND(r.avg_rating,2)),'N/A')||' | Downloads='||r.downloads); 
    END LOOP;
END;
/

-- 3: cursor calls the count function for every developer
SET SERVEROUTPUT ON;
DECLARE CURSOR c_all_devs 
IS 
    SELECT DeveloperID,DeveloperName FROM Developers ORDER BY DeveloperID;
    v_count NUMBER;
    v_category VARCHAR2(30);
BEGIN
    FOR r IN c_all_devs 
    LOOP v_count:=get_developer_app_count(r.DeveloperID);
        IF v_count=0 THEN v_category:='No Applications'; 
        ELSIF v_count<=2 THEN v_category:='Small Portfolio'; 
        ELSE v_category:='Large Portfolio'; 
        END IF;
        DBMS_OUTPUT.PUT_LINE(r.DeveloperID||' | '||r.DeveloperName||' | '||v_count||' | '||v_category);
    END LOOP;
END;
/

-- Challenge: full application processing report and totals
SET SERVEROUTPUT ON;
DECLARE CURSOR c_report 
IS 
    SELECT a.AppID,a.AppName,d.DeveloperName,c.CategoryName,a.Rating,a.Price,a.Downloads
    FROM Apps a LEFT JOIN Developers d ON d.DeveloperID=a.DeveloperID
    LEFT JOIN Categories c ON c.CategoryID=a.CategoryID ORDER BY a.AppID;
    v_processed NUMBER:=0; 
    v_free NUMBER:=0; 
    v_paid NUMBER:=0; 
    v_high_rated NUMBER:=0;
    v_downloads NUMBER:=0;
BEGIN
    FOR r IN c_report
    LOOP
        v_processed:=v_processed+1; 
        IF NVL(r.Price,0)=0 THEN v_free:=v_free+1; 
        ELSE v_paid:=v_paid+1;
        END IF;
        IF r.Rating>=4.5 THEN v_high_rated:=v_high_rated+1;
        END IF; 
        v_downloads:=v_downloads+NVL(r.Downloads,0);
        DBMS_OUTPUT.PUT_LINE(r.AppID||' | '||r.AppName||' | '||NVL(r.DeveloperName,'N/A')||' | '||NVL(r.CategoryName,'N/A')||
          ' | '||NVL(TO_CHAR(r.Rating),'NULL')||' | '||classify_rating(r.Rating)||' | '||r.Price||' | '||classify_app_price(r.Price)||' | '||r.Downloads);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total Applications Processed: '||v_processed); DBMS_OUTPUT.PUT_LINE('Total Free Applications: '||v_free);
    DBMS_OUTPUT.PUT_LINE('Total Paid Applications: '||v_paid); DBMS_OUTPUT.PUT_LINE('Total Highly Rated Applications: '||v_high_rated);
    DBMS_OUTPUT.PUT_LINE('Total Downloads: '||v_downloads);
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Report generation error: '||SQLERRM); 
RAISE;
END;
/
