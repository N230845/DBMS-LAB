USE PlayStoreDB;
-- Level 0
ALTER TABLE Apps
ADD CONSTRAINT fk_developer_new
FOREIGN KEY(DeveloperID)
REFERENCES Developers(DeveloperID);

ALTER TABLE Apps
ADD CONSTRAINT fk_publisher_new
FOREIGN KEY(PublisherID)
REFERENCES Publishers(PublisherID);

ALTER TABLE Apps
ADD CONSTRAINT fk_category_new
FOREIGN KEY(CategoryID)
REFERENCES Categories(CategoryID);

SELECT *FROM Apps
WHERE Rating>4.5;

SELECT *FROM Apps 
WHERE Price=0;

SELECT *FROM Apps
WHERE CategoryID=305;

-- Level 1
SELECT *FROM Apps
WHERE Downloads>500000000;

SELECT *FROM Apps
WHERE Rating BETWEEN 4.3 AND 4.7;

SELECT *FROM Apps
WHERE Price IN(0,299);

SELECT *FROM Apps
WHERE AppName LIKE 'G%';

SELECT *FROM Apps
WHERE AppName LIKE'%Google%';

SELECT * FROM Apps
WHERE Rating>4.0 AND Downloads>500000000;

SELECT * FROM Apps
WHERE CategoryID=301 OR CategoryID=305;

-- Level 2
SELECT *FROM Apps
WHERE AppName NOT LIKE'G%';

SELECT *FROM Apps
WHERE Rating<4.5 OR Downloads>1000000000;

SELECT *FROM Developers 
WHERE DeveloperName LIKE '%a%';

SELECT * FROM Apps
WHERE Price BETWEEN 0 AND 300;

SELECT * FROM Apps
WHERE PublisherID=201 OR  PublisherId=204;

INSERT INTO Apps VALUES
(1009,'ECINET',190,209,308,4.1,1000000000,0);
SELECT * FROM Apps;  -- Not inserting into the table and showing error

SELECT * FROM Apps
WHERE CategoryID NOT LIKE 305;


