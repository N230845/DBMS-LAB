-- CREATE DATABASE PlaystoreDB;
USE PlaystoreDB;
DROP TABLE Developers;
CREATE TABLE Developers (
	DeveloperID INT PRIMARY KEY,
    DeveloperName VARCHAR(60)NOT NULL,
    Country VARCHAR(30),
    FoundedYear INT
    );
DROP TABLE Publishers;
CREATE TABLE Publishers (
	PublisherID INT PRIMARY KEY,
	PublisherName VARCHAR(60),
	HeadOffice VARCHAR(40),
	SupportEmail VARCHAR(60)
	);
DROP TABLE Categories;
CREATE TABLE Categories(
	CategoryId INT PRIMARY KEY,
	CategoryName VARCHAR(40),
	MinimumAge int
	);
DROP TABLE Apps;
CREATE TABLE Apps(
	AppID INT PRIMARY KEY,
    AppName VARCHAR(60),
    DeveloperID INT,
    PublisherId INT,
    CategoryID INT,
    Rating DECIMAL (2,1),
    Downloads BIGINT,
    Price DECIMAL(6,2)
    );
INSERT  INTO Developers VALUES
(101,'Google LLC','USA',1998),
(102,'Meta Platforms','USA',2004),
(103,'Spotify AB','Sweden',2006),
(104,'Canva Pty Ltd','Australia',2012),
(105,'BYJUs','India',2011);
INSERT INTO Publishers VALUES
(201,'Google Play','California','support@google.com'),
(202,'Samsung Galaxy Store','Seoul','support@samsung.com'),
(203,'Huawei AppGallery','Shenzhen','support@huawei.com'),
(204,'Amazon AppStore','Seattle','support@amazon.com');
INSERT INTO Categories VALUES
(301,'Education',3),
(302,'Productivity',3),
(303,'Music',12),
(304,'Social',13),
(305,'Gaming',16);
INSERT INTO Apps VALUES
(1001,'Google Classroom',101,201,301,4.6,500000000,0),
(1002,'Google Keep',101,201,302,4.5,100000000,0),
(1003,'Instagram',102,201,304,4.4,5000000000,0),
(1004,'Spotify',103,201,303,4.5,1000000000,0),
(1005,'Canva',104,201,302,4.7,500000000,0),
(1006,'BYJUS Learning',105,201,301,4.3,100000000,299),
(1007,'Candy Crush',102,204,305,4.6,1000000000,0),
(1008,'Temple Run',104,203,305,4.2,500000000,0);
SELECT *FROM Developers;
SELECT *FROM Publishers;
SELECT * FROM Categories;
SELECT *FROM Apps;
DESC APPS;
-- level1
INSERT INTO Developers VALUES
(106,'OpenAI','USA',2015);
SELECT *FROM Developers;

INSERT INTO Categories VALUES
(306,'Artificial Intelligence',12);
SELECT *FROM Categories;

INSERT INTO Apps VALUES
(1009,'ChatGPT',103,202,302,4.8,100000000,0);
SELECT *FROM Apps;

-- SET SQL_SAFE_UPDATES=0;

UPDATE Apps 
SET Rating=4.5
WHERE AppName='Temple Run';
SELECT *FROM Apps;

DELETE FROM Developers
WHERE DeveloperID=105;
SELECT *FROM Developers;


-- level2
UPDATE Publishers
SET SupportEmail='Galaxy@samsung.com'
WHERE PublisherName='Samsung Galaxy Store';
SELECT *FROM Publishers;

INSERT INTO Apps VALUES
(1010,'Google Gemini',102,201,304,4.1,500000000,0.00),
(1011,'HomeScapes',103,203,304,4.9,1000000000,100);
SELECT *FROM Apps;

UPDATE Apps
SET Price=199
WHERE AppName='BYJUS Learning';
SELECT *FROM Apps;
 







