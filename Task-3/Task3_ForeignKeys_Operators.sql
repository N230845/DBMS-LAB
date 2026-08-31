USE PlayStoreDB;
-- Level0
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


