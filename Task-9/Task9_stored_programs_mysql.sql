USE PlayStoreDB;

-- Task 1
-- Rating classification
DELIMITER //
CREATE FUNCTION classify_rating(p_rating DECIMAL(2,1)) RETURNS VARCHAR(30)
READS SQL DATA
BEGIN
	IF p_rating IS NULL THEN RETURN 'Not Rated';
	ELSEIF p_rating < 0 OR p_rating > 5 THEN RETURN 'Invalid Rating';
	ELSEIF p_rating >= 4.5 THEN RETURN 'Excellent';
	ELSEIF p_rating >= 4.0 THEN RETURN 'Very Good';
	ELSEIF p_rating >= 3.0 THEN RETURN 'Good';
	ELSE RETURN 'Needs Improvement';
	END IF;
END //
DELIMITER ;
-- Test with five values, including NULL
SELECT classify_rating(4.8) AS result UNION ALL SELECT classify_rating(4.2)
UNION ALL SELECT classify_rating(3.5) UNION ALL SELECT classify_rating(2.4)
UNION ALL SELECT classify_rating(NULL);

-- Task 2
-- Individual application details with NOT FOUND handler
DELIMITER //
CREATE PROCEDURE application_details(IN p_application_id INT)
BEGIN
	DECLARE v_done BOOL DEFAULT FALSE; 
	DECLARE v_name VARCHAR(60);
	DECLARE v_rating DECIMAL(2,1);
	DECLARE v_price DECIMAL(6,2);
	DECLARE v_downloads INT; 
	DECLARE v_developer VARCHAR(255);
	DECLARE v_publisher VARCHAR(255); 
	DECLARE v_category VARCHAR(255);
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done=TRUE;
	SELECT a.AppName,a.Rating,a.Price,a.Downloads,d.DeveloperName,p.PublisherName,c.CategoryName
	INTO v_name,v_rating,v_price,v_downloads,v_developer,v_publisher,v_category
	FROM Apps a JOIN Developers d ON d.DeveloperID=a.DeveloperID
	JOIN Publishers p ON p.PublisherID=a.PublisherID JOIN Categories c ON c.CategoryID=a.CategoryID
	WHERE a.AppID=p_application_id;
	IF v_done THEN SELECT 'Application not found' AS Message;
	ELSE SELECT p_application_id AS AppID,v_name AS AppName,v_rating AS Rating,v_price AS Price,
	v_downloads AS Downloads,v_developer AS DeveloperName,v_publisher AS PublisherName,v_category AS CategoryName; 
	END IF;
END //
DELIMITER ;
CALL application_details(1004);

-- Task 3
-- Developer application count (table-dependent; intentionally not DETERMINISTIC)
DELIMITER //
CREATE FUNCTION get_developer_app_count(p_developer_id INT)
RETURNS INT
READS SQL DATA
BEGIN 
	DECLARE v_count INT; 
    SELECT COUNT(*) INTO v_count FROM Apps WHERE DeveloperID=p_developer_id; 
    RETURN v_count; 
END //
DELIMITER ;
SELECT d.DeveloperID,d.DeveloperName,get_developer_app_count(d.DeveloperID) AS App_Count 
FROM Developers d ORDER BY d.DeveloperID;

-- LEVEL 1 
--  1 category summary
DELIMITER //
CREATE PROCEDURE category_application_summary(IN p_category_id INT)
BEGIN	
	DECLARE v_name VARCHAR(255); 
    DECLARE v_done BOOL DEFAULT FALSE;
	DECLARE v_total INT; 
    DECLARE v_free INT; 
    DECLARE v_paid INT; 
    DECLARE v_avg DECIMAL(2,1);
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done=TRUE;
	SELECT CategoryName INTO v_name FROM Categories WHERE CategoryID=p_category_id;
	IF v_done THEN SELECT 'Category not found' AS Message;
	ELSE
		SELECT COUNT(*),COALESCE(SUM(Price=0),0),COALESCE(SUM(Price>0),0),AVG(Rating)
		INTO v_total,v_free,v_paid,v_avg FROM Apps WHERE CategoryID=p_category_id;
    SELECT v_name AS CategoryName,v_total AS TotalApplications,v_free AS FreeApplications,
      v_paid AS PaidApplications,v_avg AS AverageRating;
	END IF;
END //
DELIMITER ;
CALL category_application_summary(301);

-- 2 price function and query
DELIMITER //
CREATE FUNCTION classify_app_price(p_price DECIMAL(6,2))
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
	IF p_price IS NULL THEN RETURN 'Unknown'; 
    ELSEIF p_price<0 THEN RETURN 'Invalid Price';
	ELSEIF p_price=0 THEN RETURN 'Free'; 
    ELSEIF p_price<=100 THEN RETURN 'Budget';
	ELSEIF p_price<=500 THEN RETURN 'Premium';
    ELSE RETURN 'High Premium'; END IF;
END //
DELIMITER ;
SELECT a.AppID,a.AppName,a.Price,classify_app_price(Price) AS App_Price_Category FROM Apps a ORDER BY a.AppID;

-- 3 rating decision
DELIMITER //
CREATE PROCEDURE app_rating_dec(IN p_app_id INT)
BEGIN
	DECLARE v_name VARCHAR(60);
	DECLARE v_rating DECIMAL(2,1); 
    DECLARE v_done BOOL DEFAULT FALSE;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done=TRUE;
	SELECT AppName,Rating INTO v_name,v_rating FROM Apps WHERE AppID=p_app_id;
	IF v_done THEN SELECT v_name AS AppName, 'Application not found' AS Message;
	ELSEIF v_rating IS NULL THEN SELECT  v_name AS AppName,'Rating Not Available' AS Message;
	ELSEIF v_rating>=4.5 THEN SELECT  v_name AS AppName,'Highly Rated Application' AS Message;
	ELSEIF v_rating>=4.0 THEN SELECT  v_name AS AppName,'Good Application' AS Message;
	ELSEIF v_rating>=3.0 THEN SELECT  v_name AS AppName,'Average Application' AS Message;
	ELSE SELECT  v_name AS AppName,'Low Rated Application' AS Message;
    END IF;
END //
DELIMITER ;
CALL app_rating_dec(1001);

-- LEVEL 2
-- 1  LOOP, WHILE, REPEAT
DELIMITER //
CREATE PROCEDURE show_application_loops()
BEGIN
	DECLARE i INT DEFAULT 1;
	simple_loop: LOOP 
		SELECT CONCAT('LOOP: application review #',i) AS Message; 
		IF i>=10 THEN LEAVE simple_loop; 
        END IF; 
        SET i=i+1; 
	END LOOP;
	SET i=1; 
    WHILE i<=10 DO 
		SELECT CONCAT('WHILE: application review #',i) AS Message; 
    SET i=i+1; 
    END WHILE;
	SET i=1; 
    REPEAT SELECT CONCAT('REPEAT: application review #',i) AS Message; 
    SET i=i+1; UNTIL i>10 
    END REPEAT;
END //
DELIMITER ;
CALL show_application_loops();

-- 2 cursor and NOT FOUND handler
DELIMITER //
CREATE PROCEDURE review_all_applications()
BEGIN
	DECLARE v_done BOOL DEFAULT FALSE; 
    DECLARE v_id INT; 
    DECLARE v_name VARCHAR(60);
	DECLARE v_rating DECIMAL(2,1); 
    DECLARE v_price DECIMAL(6,2); 
    DECLARE v_downloads INT;
	DECLARE c_cursor CURSOR FOR SELECT AppID,AppName,Rating,Price,Downloads FROM Apps ORDER BY AppID;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done=TRUE;
	OPEN c_cursor;
	app_loop: LOOP
		FETCH c_cursor INTO v_id,v_name,v_rating,v_price,v_downloads;
		IF v_done THEN LEAVE app_loop; 
        END IF;
		SELECT v_id AS AppID,v_name AS AppName,v_rating AS Rating,v_price AS Price,v_downloads AS Downloads;
	END LOOP;
	CLOSE c_cursor;
END //
DELIMITER ;
CALL review_all_applications();


-- 3 validated update and updated record
DELIMITER //
CREATE PROCEDURE update_application_rating(IN p_application_id INT,IN p_new_rating DECIMAL(2,1))
BEGIN
	DECLARE v_exists INT DEFAULT 0;
	IF p_new_rating IS NULL OR p_new_rating<0 OR p_new_rating>5 THEN SELECT 'Invalid application rating' AS Message;
	ELSE
		SELECT COUNT(*) INTO v_exists FROM Apps WHERE AppID=p_application_id;
		IF v_exists=0 THEN SELECT 'Application not found' AS Message;
		ELSE
		UPDATE Apps SET Rating=p_new_rating WHERE AppID=p_application_id;
		SELECT AppID,AppName,Rating,Price,Downloads FROM Apps WHERE AppID=p_application_id;
		END IF;
	END IF;
END //
DELIMITER ;
CALL update_application_rating(1001,4.5);

-- 4  INOUT parameter
DELIMITER //
CREATE PROCEDURE update_download_count(IN p_application_id INT,IN p_additional_downloads INT,INOUT p_total_downloads INT)
BEGIN
	DECLARE v_existing INT;
    DECLARE v_done BOOL DEFAULT FALSE;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done=TRUE;
	IF p_additional_downloads<0 THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Additional downloads cannot be negative';
	END IF;
	SELECT Downloads INTO v_existing FROM Apps WHERE AppID=p_application_id;
	IF v_done THEN SELECT 'Application not found' AS Message;
	ELSE
		SET p_total_downloads=COALESCE(v_existing,0)+p_additional_downloads;
	UPDATE Apps SET Downloads=p_total_downloads WHERE AppID=p_application_id;
    SELECT p_total_downloads AS UpdatedDownloadCount;
	END IF;
END //
DELIMITER ;
SET @total_downloads=0; 
CALL update_download_count(1001,100,@total_downloads); 
SELECT @total_downloads;


-- 5  NOT FOUND and SQLEXCEPTION handling
DELIMITER //
CREATE PROCEDURE application_exception_report(IN p_application_id INT)
BEGIN
	DECLARE v_done BOOL DEFAULT FALSE; 
    DECLARE v_name VARCHAR(60); 
    DECLARE v_rating DECIMAL(2,1);
	DECLARE v_price DECIMAL(6,2);
    DECLARE v_downloads INT;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done=TRUE;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT 'Unexpected database error while retrieving application' AS Message;
	SELECT AppName,Rating,Price,Downloads INTO v_name,v_rating,v_price,v_downloads 
    FROM Apps WHERE AppID=p_application_id;
	IF v_done THEN SELECT 'Application not found' AS Message;
	ELSE SELECT v_name AS AppName,v_rating AS Rating,v_price AS Price,v_downloads AS Downloads; 
    END IF;
END //
DELIMITER ;
CALL application_exception_report(2000);

-- LEVEL 3
-- 1 complete application report
DELIMITER //
CREATE PROCEDURE process_application(IN p_application_id INT)
BEGIN
	DECLARE v_done BOOL DEFAULT FALSE; 
    DECLARE v_name VARCHAR(60); 
    DECLARE v_rating DECIMAL(2,1);
	DECLARE v_price DECIMAL(6,2);
    DECLARE v_downloads INT; 
    DECLARE v_developer VARCHAR(255);
	DECLARE v_publisher VARCHAR(255);
    DECLARE v_category VARCHAR(255); 
    DECLARE v_rating_category VARCHAR(30);
	DECLARE v_price_category VARCHAR(40);
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done=TRUE;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT 'Application processing error' AS Message;
	SELECT a.AppName,a.Rating,a.Price,a.Downloads,d.DeveloperName,p.PublisherName,c.CategoryName
    INTO v_name,v_rating,v_price,v_downloads,v_developer,v_publisher,v_category
    FROM Apps a JOIN Developers d ON d.DeveloperID=a.DeveloperID
    JOIN Publishers p ON p.PublisherID=a.PublisherID JOIN Categories c ON c.CategoryID=a.CategoryID
	WHERE a.AppID=p_application_id;
	IF v_done THEN SELECT 'Application not found' AS Message;
	ELSE
		SET v_rating_category=classify_rating(v_rating);
		SET v_price_category=CASE classify_app_price(v_price) WHEN 'Free' THEN 'Free Application'
		WHEN 'Budget' THEN 'Budget Application' WHEN 'Premium' THEN 'Premium Application' 
        ELSE 'High Premium Application' 
	END;
    SELECT '----------------------------------------' AS ReportHeader;
    SELECT 'APPLICATION DETAILS REPORT' AS ReportTitle;
    SELECT p_application_id AS `Application ID`,v_name AS `Application Name`,v_developer AS `Developer Name`,
      v_publisher AS `Publisher Name`,v_category AS `Category Name`,v_rating AS Rating,
      v_rating_category AS `Rating Category`,v_price AS Price,v_price_category AS `Price Category`,
      v_downloads AS Downloads;
	END IF;
END //
DELIMITER ;
CALL process_application(1001);
-- 2 cursor aggregate processing for developers with applications
DELIMITER //
CREATE PROCEDURE developer_application_cursor_report()
BEGIN
	DECLARE v_done BOOL DEFAULT FALSE; 
    DECLARE v_id INT; 
    DECLARE v_name VARCHAR(255);
	DECLARE v_count INT; 
    DECLARE v_avg DECIMAL(5,2); 
    DECLARE v_downloads BIGINT;
	DECLARE c_devs CURSOR FOR 
		SELECT d.DeveloperID,d.DeveloperName,COUNT(a.AppID),AVG(a.Rating),COALESCE(SUM(a.Downloads),0)
		FROM Developers d JOIN Apps a ON a.DeveloperID=d.DeveloperID
		GROUP BY d.DeveloperID,d.DeveloperName ORDER BY d.DeveloperID;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done=TRUE;
	OPEN c_devs;
	dev_loop: LOOP
		FETCH c_devs INTO v_id,v_name,v_count,v_avg,v_downloads;
        IF v_done THEN LEAVE dev_loop; 
        END IF;
		SELECT v_id AS DeveloperID,v_name AS DeveloperName,v_count AS NumberOfApplications,
		v_avg AS AverageApplicationRating,v_downloads AS TotalDownloads;
	END LOOP; 
    CLOSE c_devs;
END //
DELIMITER ;
CALL developer_application_cursor_report();


-- 3  cursor calls the count function for every developer
DELIMITER //
CREATE PROCEDURE developer_portfolio_categories()
BEGIN
	DECLARE v_done BOOL DEFAULT FALSE; 
    DECLARE v_id INT; 
    DECLARE v_name VARCHAR(255);
	DECLARE v_count INT; 
    DECLARE v_category VARCHAR(30);
	DECLARE c_devs CURSOR FOR SELECT DeveloperID,DeveloperName FROM Developers ORDER BY DeveloperID;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done=TRUE;
	OPEN c_devs;
	dev_loop: LOOP
		FETCH c_devs INTO v_id,v_name; 
        IF v_done THEN LEAVE dev_loop; 
        END IF;
		SET v_count=get_developer_app_count(v_id);
		IF v_count=0 THEN SET v_category='No Applications'; 
        ELSEIF v_count<=2 THEN SET v_category='Small Portfolio'; 
        ELSE SET v_category='Large Portfolio'; 
        END IF;
		SELECT v_id AS DeveloperID,v_name AS DeveloperName,v_count AS ApplicationCount,v_category AS DeveloperApplicationCategory;
	END LOOP; 
    CLOSE c_devs;
END //
DELIMITER ;
CALL developer_portfolio_categories();

-- CHALLENGE QUESTION
-- PlayStore Application Processing Report
DELIMITER //
CREATE PROCEDURE generate_app_processing_report()
BEGIN
	  DECLARE v_done BOOL DEFAULT FALSE;
	  DECLARE v_id INT;
	  DECLARE v_name VARCHAR(60);
	  DECLARE v_developer VARCHAR(255);
	  DECLARE v_category VARCHAR(255);
	  DECLARE v_rating DECIMAL(2,1);
	  DECLARE v_price DECIMAL(6,2);
	  DECLARE v_app_downloads BIGINT;
	  DECLARE v_processed INT DEFAULT 0;
	  DECLARE v_free INT DEFAULT 0;
	  DECLARE v_paid INT DEFAULT 0;
	  DECLARE v_high_rated INT DEFAULT 0;
	  DECLARE v_total_downloads BIGINT DEFAULT 0;
	  DECLARE c_report CURSOR FOR
		SELECT a.AppID,a.AppName,d.DeveloperName,c.CategoryName,a.Rating,a.Price,a.Downloads FROM Apps a
		  LEFT JOIN Developers d ON d.DeveloperID=a.DeveloperID
		  LEFT JOIN Categories c ON c.CategoryID=a.CategoryID ORDER BY a.AppID;
	  DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
	  DECLARE EXIT HANDLER FOR SQLEXCEPTION
		SELECT 'Report generation error: a database error occurred' AS Message;
	  OPEN c_report;
	  report_loop: LOOP
		FETCH c_report INTO v_id, v_name, v_developer, v_category,v_rating, v_price, v_app_downloads;
		-- Stop before using variables when the cursor has no more rows.
		IF v_done THEN
		  LEAVE report_loop;
		END IF;
		SET v_processed=v_processed+1;
		IF COALESCE(v_price,0)=0 THEN SET v_free=v_free+1;
		ELSE SET v_paid=v_paid+1;
		END IF;
		IF v_rating>=4.5 THEN SET v_high_rated=v_high_rated+1;
		END IF;
		SET v_total_downloads=v_total_downloads+COALESCE(v_app_downloads,0);
		-- Return this application's report row.
		SELECT v_id AS `Application ID`,v_name AS `Application Name`,v_developer AS `Developer Name`,
			   v_category AS `Category Name`,v_rating AS `Application Rating`,classify_rating(v_rating) AS `Rating Category`,
			   v_price AS `Application Price`,classify_app_price(v_price) AS `Price Category`,v_app_downloads AS Downloads;
	  END LOOP;
	  CLOSE c_report;
	  -- Return the totals as the final result set.
	  SELECT v_processed AS `Total Applications Processed`,v_free AS `Total Free Applications`,
		v_paid AS `Total Paid Applications`,v_high_rated AS `Total Highly Rated Applications`,v_total_downloads AS `Total Downloads`;
END //
DELIMITER ;
CALL generate_app_processing_report();
SELECT COUNT(*) AS AppCount FROM Apps;