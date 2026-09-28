USE PlaystoreDB;
-- LEVEL 0
-- 1
SET SQL_SAFE_UPDATES=0;
SET autocommit=0;
UPDATE Apps  SET Rating=4.8 WHERE AppName='Google Keep';
COMMIT;
SELECT * FROM Apps WHERE AppName='Google Keep';
-- 2
SELECT * FROM Apps WHERE AppName = 'BYJUS Learning';
UPDATE Apps SET Price = 8 WHERE AppName = 'BYJUS Learning';
SELECT * FROM Apps WHERE AppName = 'BYJUS Learning';
ROLLBACK;
SELECT * FROM Apps WHERE AppName = 'BYJUS Learning';
-- 3
INSERT INTO Apps VALUES(1009,'ChatGPT',103,202,302,4.8,100000000,333);
COMMIT;
SELECT * FROM Apps WHERE AppName='ChatGPT';
-- 4
SELECT * FROM Developers;
INSERT INTO Developers VALUES(106,'Apple Inc','USA',1976);
SELECT * FROM Developers;
ROLLBACK;
SELECT * FROM Developers;
-- 5
UPDATE Apps SET Rating=5.0 WHERE AppName='Instagram';
SELECT * FROM Apps WHERE AppName='Instagram';
SAVEPOINT RatingUpdate;

-- LEVEL 1
-- 1
UPDATE Apps SET Rating=6.0 WHERE AppName='Spotify';
SAVEPOINT SP1;
UPDATE Apps SET Rating=5.3 WHERE AppName='Temple Run';
SELECT * FROM Apps WHERE AppName='Temple Run';
-- 2
UPDATE Apps SET Rating=4.2 WHERE AppName='Temple Run';
SAVEPOINT SP;
SELECT * FROM Apps WHERE AppName='Temple Run';
UPDATE Apps SET Rating=7.9 WHERE AppName='Temple Run';
SELECT * FROM Apps WHERE AppName='Temple Run';
ROLLBACK TO SAVEPOINT SP;
SELECT * FROM Apps WHERE AppName='Temple Run';
-- 3
INSERT INTO Apps VALUES(1010,'Google Maps',104,203,305,4.8,1000000,0.00);
SELECT * FROM Apps WHERE AppName='Google Maps';
SAVEPOINT SP2;
UPDATE Apps SET Price=400 WHERE AppName='Google Maps';
ROLLBACK TO SAVEPOINT SP2;
SELECT * FROM Apps WHERE AppName='Google Maps';
-- 4
CREATE USER 'susmitha'@'localhost' IDENTIFIED BY 'susmitha088';
GRANT SELECT ON Apps TO 'susmitha'@'localhost';
SHOW GRANTS FOR 'susmitha'@'localhost';
-- 5
GRANT SELECT,INSERT ON Apps to 'susmitha'@'localhost';
SHOW GRANTS FOR 'susmitha'@'localhost';
-- 6
REVOKE SELECT,INSERT ON Apps FROM 'susmitha'@'localhost';
SHOW GRANTS FOR 'susmitha'@'localhost';

-- LEVEL 2
-- 1
UPDATE Apps SET Price=700 WHERE AppName='Canva';
SAVEPOINT SP3;
SELECT * FROM Apps WHERE AppName='Canva';
UPDATE Apps SET Price=1000 WHERE AppName='Canva';
SELECT * FROM Apps WHERE AppName='Canva';
ROLLBACK TO SAVEPOINT SP3;
SELECT * FROM Apps WHERE AppName='Canva';
-- 2
SELECT * FROM Categories;
INSERT INTO Categories VALUES 
(306,'Cooking',13),
(307,'Gardening',9);
SAVEPOINT SP4;
SELECT * FROM Categories;
UPDATE Categories SET MinimumAge=12 WHERE CategoryName='Cooking';
SELECT * FROM Categories;
ROLLBACK TO SAVEPOINT SP4;
SELECT * FROM Categories;
-- 3
GRANT SELECT,INSERT,UPDATE ON Apps TO 'susmitha'@'localhost';
SHOW GRANTS FOR 'susmitha'@'localhost';
-- 4
REVOKE UPDATE ON Apps FROM 'susmitha'@'localhost';
SHOW GRANTS FOR 'susmitha'@'localhost';
-- 5
GRANT UPDATE ON Developers TO 'susmitha'@'localhost';
SHOW GRANTS FOR 'susmitha'@'localhost';
REVOKE UPDATE ON Developers FROM 'susmitha'@'localhost';
SHOW GRANTS FOR 'susmitha'@'localhost';
-- 6
INSERT INTO Apps VALUES(1011,'Google Drive',103,202,301,4.6,1000000,0.00);
SELECT * FROM Apps;
UPDATE Apps SET Rating=0 WHERE AppName='Google Drive';
SELECT * FROM Apps;
DELETE FROM Apps WHERE AppID=1011;
COMMIT;
SELECT * FROM Apps;
-- 7
SELECT * FROM Apps;
UPDATE Apps SET AppName='GammaAI' WHERE AppName='ChatGPT';
COMMIT;
SELECT * FROM Apps;
UPDATE Apps SET AppName='ChatGPT' WHERE AppName='GammaAI';
SELECT * FROM Apps;
ROLLBACK;
SELECT * FROM Apps;
