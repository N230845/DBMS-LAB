USE PlayStoreDB;
SELECT * FROM Developers;
SELECT * FROM Publishers;
SELECT * FROM Categories;
SELECT * FROM Apps;
-- Level 1
-- 1
CREATE VIEW application_records_4 AS SELECT AppID,AppName,Rating,Price FROM Apps;
SELECT * FROM application_records;
-- 3
CREATE VIEW highly_rated_applications AS SELECT AppID, AppName,Rating FROM Apps WHERE Rating>=4.5;
SELECT * FROM highly_rated_applications;
-- 4
CREATE VIEW free_apps AS SELECT AppName,Price FROM apps WHERE Price=0;
SELECT * FROM free_apps;
-- 5
SELECT * FROM highly_rated_applications;
-- 6
SHOW FULL TABLES WHERE TABLE_TYPE='VIEW';

-- Level 2
-- 1
CREATE VIEW app_developers AS SELECT a.AppName,d.DeveloperName FROM Apps a  INNER JOIN Developers d ON a.DeveloperID=d.DeveloperID;
SELECT * FROM app_developers;
-- 2
CREATE VIEW app_publishers AS SELECT a.AppName,p.PublisherName FROM Apps a  INNER JOIN Publishers p ON a.PublisherID=p.PublisherID;
SELECT * FROM app_publishers;
-- 3
CREATE VIEW app_categories AS SELECT a.AppName,c.CategoryName FROM Apps a  INNER JOIN Categories c ON a.CategoryID=c.CategoryID;
SELECT * FROM app_categories;
-- 4
CREATE VIEW app_developer_country AS SELECT a.*,d.DeveloperName,d.Country FROM Apps a JOIN Developers d On a.DeveloperID=d.DeveloperID;
SELECT * FROM app_developer_country;
-- 5
CREATE VIEW app_count_categoriess AS SELECT COUNT(a.AppID) AS total_apps,c.CategoryName FROM Apps a  RIGHT JOIN Categories c
ON a.CategoryID=c.CategoryID GROUP BY c.CategoryName;
SELECT * FROM app_count_categoriess;
-- 6
CREATE VIEW app_count_developerss AS SELECT COUNT(a.AppID) AS total_apps,d.DeveloperName FROM Apps a  RIGHT JOIN Developers d ON 
a.DeveloperID=d.DeveloperID GROUP BY d.DeveloperName;
SELECT * FROM app_count_developerss;
-- 7
CREATE VIEW app_avrg_categoriess AS SELECT AVG(a.Rating) AS avg_apps,c.CategoryName FROM Apps a  RIGHT JOIN Categories c
ON a.CategoryID=c.CategoryID GROUP BY c.CategoryName;
SELECT * FROM app_avrg_categoriess;
-- 8
CREATE VIEW app_ratings AS SELECT a.AppName,a.Rating,d.DeveloperName FROM Apps a JOIN Developers d ON 
a.DeveloperID=d.DeveloperID WHERE a.Rating>4.3;
SELECT * FROM app_ratings;
-- 9
SELECT AppName,Developername FROM app_ratings WHERE Rating>4.3;
-- 10
SHOW CREATE VIEW app_developers;

-- Level 3
-- 2
CREATE VIEW developers_count1 AS SELECT d.DeveloperName,COUNT(a.AppName) AS Total_count FROM Apps a RIGHT JOIN Developers d ON a.DeveloperID=d.DeveloperID
GROUP BY d.DeveloperID,d.DeveloperName HAVING COUNT(a.AppID)>1;
SELECT * FROM developers_count1;
-- 3
CREATE VIEW minmax_category AS SELECT MIN(a.Rating) as Min_rating,MAX(a.Rating) AS Max_rating,c.CategoryName FROM Apps a RIGHT JOIN Categories c
ON a.CategoryID=c.categoryID GROUP BY c.CategoryName;
SELECT * FROM minmax_category;
-- 4
CREATE VIEW developed_apps AS SELECT d.DeveloperName,COUNT(a.AppName) AS Total_count FROM Apps a RIGHT JOIN 
Developers d ON a.DeveloperID=d.DeveloperID GROUP BY d.DeveloperName;
SELECT * FROM developed_apps;
-- 5
CREATE VIEW all_tables AS SELECT a.AppName,d.DeveloperName,p.PublisherName,c.CategoryName FROM Apps a INNER JOIN Developers d ON a.DeveloperID=d.DeveloperID 
INNER JOIN Publishers p ON a.PublisherID=p.PublisherID INNER JOIN Categories c ON a.CategoryID=c.CategoryID;
SELECT * FROM all_tables;
-- 6
CREATE VIEW HighlyRatedApp AS SELECT a.AppName,a.Rating,d.DeveloperName,c.CategoryName FROM Apps a INNER JOIN Developers d
ON a.DeveloperID = d.DeveloperID INNER JOIN Categories c ON a.CategoryID = c.CategoryID WHERE a.Rating >= 4.5;
SELECT * FROM HighlyRatedApp;
-- 7
 CREATE VIEW publish_count AS SELECT p.PublisherName,Count(a.AppID) AS Application_count,SUM(a.Downloads) AS
 total_Downloads FROM Publishers p  RIGHT JOIN Apps a On p.PublisherID=a.PublisherID GROUP BY p.PublisherID,p.PublisherName;
 SELECT * FROM publish_count;
-- 8 
 SELECT * FROM HighlyRatedApp WHERE Rating>=4.5 ORDER BY Rating DESC;
-- 9
CREATE VIEW app_rating_view AS SELECT AppID,AppName,Rating FROM Apps;
UPDATE app_rating_view SET Rating=5.5 WHERE AppID=1006;
SELECT * FROM app_rating_view;
SELECT * FROM Apps;
-- 10
DROP VIEW HighlyRatedApp;
SHOW FULL TABLES WHERE TABLE_TYPE='VIEW';