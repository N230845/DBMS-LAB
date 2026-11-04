USE PlayStoreDB;
SHOW TABLES;
DESC Apps;
DESCRIBE Developers;
DESCRIBE Publishers;
DESCRIBE Categories;
-- Task2 First MYSQL Program
DELIMITER //
CREATE PROCEDURE welcome_playstore()
BEGIN SELECT 'Welcome to PlayStoreDB'; END//
DELIMITER ;
CALL welcome_playstore();
-- Task 4
DELIMITER //
CREATE PROCEDURE display_app_details(IN p_app_id INT)
BEGIN
	DECLARE v_name VARCHAR(255);
    DECLARE v_rating DECIMAL(3,2);
    SELECT AppName,Rating INTO v_name,v_rating FROM Apps WHERE AppID=p_app_id;
    SELECT v_name AS Application_Name,v_rating AS Application_Rating;
END //
DELIMITER ;
CALL display_app_details(1001);

-- LEVEL 0
-- 1
DELIMITER //
CREATE PROCEDURE calculate_app_price_discount(IN p_app_id INT)
BEGIN
	DECLARE v_name VARCHAR(20); 
	DECLARE v_price DECIMAL(10,2);
    DECLARE v_discount DECIMAL(10,2);
    SELECT AppName,Price INTO v_name,v_price FROM Apps WHERE AppID=p_app_id;
    SET v_discount=v_price*0.10;
    SELECT v_name as App_Name,v_price AS Application_Price,v_discount AS Ten_Percent_Price;
END //
DELIMITER ;
CALL calculate_app_price_discount(1005);

-- 2
DELIMITER //
CREATE PROCEDURE show_app_details(IN p_app_id INT)
BEGIN
	DECLARE v_name VARCHAR(20);
    DECLARE v_rating DECIMAL(3,2);
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_downloads BIGINT;
    SELECT AppName,Rating,Price,Downloads INTO v_name,v_rating,v_price,v_downloads FROM Apps WHERE AppID=p_app_id;
    SELECT v_name AS App_Name,v_rating AS App_Rating,v_price AS App_Price,v_downloads AS App_Downloads;
END //
DELIMITER ;
CALL show_app_details(1005);

-- 3
DELIMITER //
CREATE PROCEDURE classify_rating(IN p_rating DECIMAL(3,2))
BEGIN
	IF p_rating>=4.5 THEN SELECT 'Highly Rated' AS Rating_Category;
    ELSEIF p_rating>=3.5 THEN SELECT 'Moderately Rated' AS Rating_Category;
    ELSE SELECT 'Low Rated' AS Rating_Category;
    END IF;
END //
DELIMITER ;
CALL classify_rating(4.8);

-- 4
DELIMITER //
CREATE FUNCTION check_app_price(p_price DECIMAL(10,2))
RETURNS VARCHAR(30)
DETERMINISTIC  
BEGIN 
	IF p_price >0 THEN RETURN 'Paid App';
    ELSE RETURN 'Free App';
    END IF;
END //
DELIMITER ;
SELECT check_app_price(100) AS Application_Type;
SELECT check_app_price(0) AS Application_Type;

-- 5
DELIMITER //
CREATE PROCEDURE display_numbers_1to10()
BEGIN
	DECLARE v_num INT DEFAULT 1;
    CREATE TEMPORARY TABLE temp_numbers(Number INT);
    WHILE v_num <=10 DO
		INSERT INTO temp_numbers VALUES(v_num);
        SET v_num=v_num+1;
	END WHILE;
	SELECT * FROM temp_numbers;
    DROP TEMPORARY TABLE temp_numbers;
END //
DELIMITER ;
CALL display_numbers_1to10();
    
-- LEVEL 1
-- 1
DELIMITER //
CREATE PROCEDURE classify_application_rating(IN p_app_id INT)
BEGIN
	DECLARE v_rating DECIMAL(3,2);
    SELECT Rating INTO v_rating FROM Apps WHERE AppID=p_app_id;
    IF v_rating >=4.5 THEN SELECT 'Excellent Application' AS Rating_Category;
    ELSEIF v_rating>=4.0 THEN SELECT 'Good Application' AS Rating_Category;
    ELSEIF v_rating>=3.5 THEN SELECT 'Average Application' AS Rating_Category;
    ELSE SELECT 'Low Rated Application' AS Rating_Category;
    END IF;
END //
DELIMITER ;
CALL classify_application_rating(1006);

-- 2
DELIMITER //
CREATE FUNCTION app_rating_from_id(p_app_id INT)
RETURNS DECIMAL(2,1)
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE v_rating DECIMAL(2,1);
    SELECT Rating INTO v_rating FROM Apps WHERE AppID=p_app_id;
	RETURN v_rating;
END //
DELIMITER ;
SELECT app_rating_from_id(1004) AS Rating;
SELECT AppName,app_rating_from_id(AppID) AS Rating FROM Apps;

-- LEVEL 2
-- 1
DELIMITER //
CREATE PROCEDURE display_all_apps()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_name VARCHAR(60);
    DECLARE v_rating DECIMAL(2,1);
    DECLARE v_price DECIMAL(6,2);
    DECLARE v_downloads BIGINT;
    DECLARE app_cursor CURSOR FOR 
		SELECT AppName,Rating,Price,Downloads FROM Apps;
	DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET done=TRUE;
	OPEN app_cursor;
    read_loop:LOOP
		FETCH app_cursor
        INTO v_name,v_rating,v_price,v_downloads;
        IF done THEN
			LEAVE read_loop;
		END IF;
        SELECT v_name AS Application_Name,v_rating AS Application_Rating,
        v_price AS Application_Price,v_downloads AS Application_DOwnloads;
	END LOOP;
    CLOSE app_cursor;
END //
DELIMITER ;
CALL display_all_apps();

-- 2
DELIMITER //
CREATE PROCEDURE find_app(IN app_id INT)
BEGIN
	DECLARE v_name VARCHAR(60);
    DECLARE v_rating DECIMAL(2,1);
    DECLARE v_price DECIMAL(6,2);
    DECLARE v_found BOOLEAN DEFAULT TRUE;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_found=FALSE;
    SELECT AppName,Rating,Price INTO v_name,v_rating,v_price
    FROM Apps WHERE AppID=app_id;
    IF v_found THEN
    SELECT v_name AS Application_Name,
               v_rating AS Rating,
               v_price AS Price;
    ELSE
        SELECT 'Application not found' AS Message;
    END IF;
END //
DELIMITER ;
CALL find_app(1008);
CALL find_app(2000);


-- Optional
-- 1
DELIMITER //
CREATE PROCEDURE update_app_rating(IN p_app_id INT,IN p_new_rating DECIMAL(2,1))
BEGIN
	DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count FROM Apps WHERE AppID = p_app_id;
	IF v_count > 0 THEN
        UPDATE Apps SET Rating = p_new_rating WHERE AppID = p_app_id;
        SELECT 'Rating updated successfully' AS Message;
    ELSE
        SELECT 'Application not found' AS Message;
    END IF;
END //
DELIMITER ;
CALL update_app_rating(1001,8.5);

-- 2
DELIMITER //
CREATE PROCEDURE classify_using_case(IN p_rating DECIMAL(3,2))
BEGIN
    DECLARE v_category VARCHAR(30);
    SET v_category=
        CASE
            WHEN p_rating >= 4.5 THEN 'Excellent'
            WHEN p_rating >= 4.0 THEN 'Good'
            WHEN p_rating >= 3.5 THEN 'Average'
            ELSE 'Low Rated'
        END;
    SELECT v_category AS Classification;
END //
DELIMITER ;
CALL classify_using_case(4.7);

-- 3
DELIMITER //
CREATE PROCEDURE display_app_developer(IN p_app_id INT)
BEGIN
    SELECT
        A.AppID AS Application_ID,
        A.AppName AS Application_Name,
        A.Rating,
        A.Price,
        D.DeveloperID AS Developer_ID,
        D.DeveloperName AS Developer_Name,
        D.Country FROM Apps A JOIN Developers D ON A.DeveloperID = D.DeveloperID WHERE A.AppID = p_app_id;
END //
DELIMITER ;
CALL display_app_developer(1003);

-- 4
DELIMITER //
CREATE PROCEDURE display_apps_cursor()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_app_id INT;
    DECLARE v_app_name VARCHAR(60);
    DECLARE v_rating DECIMAL(2,1);
    DECLARE v_downloads BIGINT;
    DECLARE app_cursor CURSOR FOR SELECT AppID, AppName, Rating, Downloads FROM Apps;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;
    OPEN app_cursor;
    read_loop: LOOP
        FETCH app_cursor
        INTO v_app_id, v_app_name, v_rating, v_downloads;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT v_app_id AS AppID,v_app_name AS AppName,v_rating AS Rating,v_downloads AS Downloads;
    END LOOP;
    CLOSE app_cursor;
END //
DELIMITER ;
CALL display_apps_cursor();

-- 5
DELIMITER //
CREATE FUNCTION get_rating_classification(p_rating DECIMAL(3,2))
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    RETURN
        CASE
            WHEN p_rating >= 4.5 THEN 'Excellent'
            WHEN p_rating >= 4.0 THEN 'Good'
            WHEN p_rating >= 3.5 THEN 'Average'
            ELSE 'Low Rated'
        END;
END //
DELIMITER ;
SELECT get_rating_classification(4.7) AS Classification;
SELECT AppID,AppName,Rating,get_rating_classification(Rating) AS Classification FROM Apps;