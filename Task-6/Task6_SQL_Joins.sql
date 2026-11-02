USE PlayStoreDB;
-- Level 0
-- 1
SELECT a.AppName,d.DeveloperName FROM Apps a INNER JOIN Developers d ON a.DeveloperID=d.DeveloperID;
-- 2
SELECT a.AppName,p.PublisherName FROM Apps a INNER JOIN Publishers p ON a.PublisherID=p.PublisherID;
-- 3
SELECT a.AppName,c.CategoryName FROM Apps a INNER JOIN Categories c ON a.CategoryID=c.CategoryID;
-- 4
SELECT a.AppName,d.DeveloperName,p.PublisherName FROM Apps a INNER JOIN Developers d ON a.DeveloperID=d.DeveloperID 
INNER JOIN Publishers p ON a.PublisherID=p.PublisherID;
-- 7
SELECT c.CategoryName,a.AppName FROM Categories c LEFT JOIN Apps a ON c.CategoryID=a.CategoryID;

-- Level 1
-- 1
SELECT p.PublisherName,a.AppName FROM Publishers p LEFT JOIN Apps a ON p.PublisherID=a.PublisherID;
-- 2
SELECT a.AppName,p.PublisherName FROM Apps a RIGHT JOIN Publishers p ON a.PublisherId=p.PublisherID;
-- 4
SELECT a.AppName,d.DeveloperName,d.Country FROM Apps a INNER JOIN  Developers d ON a.DeveloperID=d.DeveloperID;
-- 5
SELECT a.AppName,d.DeveloperName,p.PublisherName,c.CategoryName FROM Apps a INNER JOIN Developers d ON a.DeveloperID=d.DeveloperID 
INNER JOIN Publishers p ON a.PublisherID=p.PublisherID INNER JOIN Categories c ON a.CategoryID=c.CategoryID;
-- 6
SELECT a.AppName,d.DeveloperName,d.Country FROM Apps a INNER JOIN  Developers d ON a.DeveloperID=d.DeveloperID 
WHERE d.Country='USA';
-- 7
SELECT a.AppName,c.CategoryName,p.PublisherName FROM Apps a INNER JOIN Categories c ON a.CategoryID=c.CategoryID
 INNER JOIN Publishers p ON a.PublisherId=p.PublisherID WHERE c.CategoryName='Gaming';
-- 8 
 SELECT a.AppName,d.DeveloperName,a.Rating FROM Apps a INNER JOIN Developers d ON a.DeveloperID=d.DeveloperID 
 WHERE a.Rating>4.5;
 
 -- Level 2
 -- 7
 SELECT d1.DeveloperName AS Developer1,d2.DeveloperName AS Developer2,d1.Country FROM Developers d1 JOIN Developers d2 ON d1.DeveloperID=d2.DeveloperID; 
 -- 8
SELECT p.PublisherName,c.CategoryName FROM Publishers p CROSS JOIN Categories c;
-- 9
SELECT p.Publishername,a.AppName FROM Publishers p LEFT JOIN Apps a ON p.PublisherID=a.PublisherID
UNION
SELECT p.Publishername,a.AppName FROM Publishers p RIGHT JOIN Apps a ON p.PublisherID=a.PublisherID;
-- 10
SELECT a.AppName,d.DeveloperName,p.PublisherName,c.CategoryName FROM Apps a INNER JOIN Developers d ON a.DeveloperID=d.DeveloperID 
INNER JOIN Publishers p ON a.PublisherID=p.PublisherID INNER JOIN Categories c ON a.CategoryID=c.CategoryID WHERE c.CategoryName IN('Gaming','Social');
-- 11
SELECT a.AppName,d.DeveloperName,c.CategoryName,a.Rating FROM Apps a INNER JOIN Developers d ON a.DeveloperID=d.DeveloperID 
INNER JOIN Categories c ON a.CategoryID=c.CategoryID WHERE a.Rating BETWEEN 4.3 AND 4.7;
-- 12
SELECT a.AppName,d.DeveloperName,d.Country FROM Apps a INNER JOIN Developers d ON a.DeveloperID=d.DeveloperID 
WHERE NOT d.Country='India';

-- Optional
-- 1
SELECT d. DeveloperName,d.Country,COUNT(a.AppID) AS Application_count,AVG(a.Rating) FROM Developers d Join Apps a ON d.DeveloperID=a.DeveloperID
GROUP BY d.DeveloperID,d.DeveloperName,d.Country HAVING COUNT(a.AppID)>1;
-- 2
SELECT UPPER(a.AppName),UPPER(d.DeveloperName),UPPER(d.Country) FROM Apps a INNER JOIN  Developers d ON a.DeveloperID=d.DeveloperID WHERE d.Country='USA';
-- 3
SELECT p.PublisherName,Count(a.AppID) AS Application_count,SUM(a.Downloads) AS total_Downloads FROM Publishers p JOIN Apps a On p.PublisherID=a.PublisherID
GROUP BY p.PublisherID,p.PublisherName ORDER BY total_Downloads DESC;
-- 4
SELECT a.AppName,d.DeveloperName,p.PublisherID,ROUND(a.Rating) AS Rating_Round FROM Apps a JOIN Developers d ON a.DeveloperID=d.DeveloperID JOIN Publishers p ON a.PublisherId=p.PublisherID;
-- 5
SELECT d.DeveloperName,a.AppName,p.PublisherName,CAST(d.FoundedYear AS CHAR) AS FOUNDED_YEAR FROM Developers d JOIN Apps a ON
d.DeveloperID=a.DeveloperID JOIN Publishers p ON p.PublisherID=a.PublisherID;
-- 6
SELECT c.CategoryName,COUNT(a.AppID) AS number_of_applications,AVG(a.Rating) AS average_rating FROM Categories c
JOIN Apps a ON c.CategoryID = a.CategoryID GROUP BY c.CategoryID,c.CategoryName HAVING AVG(a.Rating)>4.3
ORDER BY average_rating DESC;

