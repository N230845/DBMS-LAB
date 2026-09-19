USE PlaystoreDB;
-- Level 1
SELECT COUNT(*) FROM Apps;
SELECT AVG(Rating) FROM Apps;
SELECT MAX(Rating) FROM Apps;
SELECT MIN(Rating) FROM Apps;
SELECT SUM(Downloads) FROM Apps;
SELECT * FROM Apps ORDER BY Rating DESC;

-- Level1
SELECT CategoryID,COUNT(CategoryID) FROM Apps GROUP BY CategoryID;
SELECT CategoryID,AVG(Rating) FROM Apps GROUP BY CategoryID;
SELECT MAX(Price),MIN(Price) FROM Apps;
SELECT * FROM Apps ORDER BY Downloads DESC;
SELECT DeveloperID,COUNT(DeveloperID) FROM Apps GROUP BY  DeveloperID;
SELECT CategoryID,COUNT(CategoryID) FROM Apps GROUP BY CategoryID HAVING COUNT(CategoryID)>1;

-- Level 2
SELECT DeveloperID,SUM(Downloads) FROM Apps GROUP BY DeveloperID;
SELECT PublisherID,AVG(Rating) FROM Apps GROUP BY PublisherID;
SELECT DeveloperID,COUNT(DeveloperID) AS DeveloperHavingMoreThanOneApplication FROM Apps GROUP BY DeveloperID HAVING COUNT(DeveloperID)>1;
SELECT CategoryID,AVG(Rating) FROM Apps GROUP BY CategoryID HAVING AVG(Rating)>4.3;
SELECT CategoryID,COUNT(CategoryID) AS CategoryCount FROM Apps GROUP BY CategoryID ORDER BY CategoryCount DESC;
SELECT * FROM Apps WHERE Rating =(SELECT MAX(Rating) FROM Apps);
SELECT DeveloperID,SUM(Price) FROM Apps GROUP BY DeveloperID;