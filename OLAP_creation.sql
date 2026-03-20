DROP TABLE IF EXISTS EventMan.FactEvent
DROP TABLE IF EXISTS EventMan.DimSuppliers
DROP TABLE IF EXISTS EventMan.DimDetails
DROP TABLE IF EXISTS EventMan.DimParticipant
DROP TABLE IF EXISTS EventMan.DimClients
DROP TABLE IF EXISTS EventMan.DimDate
;
CREATE TABLE EventMan.DimSuppliers
(
	supplierkey INT NOT NULL IDENTITY PRIMARY KEY,
	supplierid INT,
	servicename NVARCHAR(100),
	company NVARCHAR(100),
	email NVARCHAR(100),
	phone NVARCHAR(100)
)
CREATE TABLE EventMan.DimDetails
(
	detailskey INT NOT NULL PRIMARY KEY,
	name NVARCHAR(100),
	location NVARCHAR(100),
	startdate DATETIME,
	enddate DATETIME,
	eventstatus NVARCHAR(100),
	typename NVARCHAR(100)
)
CREATE TABLE EventMan.DimParticipant
(
	participantkey INT NOT NULL PRIMARY KEY IDENTITY,
	partid INT,
	participantstatus NVARCHAR(100),
	firstname NVARCHAR(100),
	lastname NVARCHAR(100),
	email NVARCHAR(100)
)
CREATE TABLE EventMan.DimClients
(
	clientkey INT NOT NULL  PRIMARY KEY,
	firstname NVARCHAR(100),
	lastname NVARCHAR(100),
	phone NVARCHAR(100),
	email NVARCHAR(100)
)
CREATE TABLE EventMan.DimDate
(
	datekey INT NOT NULL PRIMARY KEY IDENTITY,
	[date] DATETIME NOT NULL
)
CREATE TABLE EventMan.FactEvent
(
	eventkey INT NOT NULL PRIMARY KEY IDENTITY,
	paymentid INT, 
	budget INT,
	payment_amount INT,
	cost INT,
	participantkey INT NOT NULL FOREIGN KEY REFERENCES EventMan.DimParticipant(participantkey),
	clientkey INT NOT NULL FOREIGN KEY REFERENCES EventMan.DimClients(clientkey),
	datekey INT NOT NULL FOREIGN KEY REFERENCES EventMan.DimDate(datekey),
	detailskey INT NOT NULL FOREIGN KEY REFERENCES EventMan.Dimdetails(detailskey),
	supplierkey INT NOT NULL FOREIGN KEY REFERENCES EventMan.DimSuppliers(supplierkey)
)
;
GO
;
CREATE OR ALTER TRIGGER trigger_update_DimSuppliers
ON EventMan.DimSuppliers
AFTER UPDATE, INSERT, DELETE
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Eventman.UpdateLog WHERE tablename = 'DimSuppliers' AND [time] = GETDATE())
    BEGIN
        INSERT INTO EventMan.UpdateLog (tablename, [time])
        VALUES ('DimSuppliers', GETDATE())
    END
END
;
GO
;
CREATE OR ALTER TRIGGER trigger_update_DimClients
ON EventMan.DimClients
AFTER UPDATE, INSERT, DELETE
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Eventman.UpdateLog WHERE tablename = 'DimClients' AND [time] = GETDATE()) 
    BEGIN
        INSERT INTO EventMan.UpdateLog (tablename, [time])
        VALUES ('DimClients', GETDATE())
    END
END
;
GO
;
CREATE OR ALTER TRIGGER trigger_update_DimDetails
ON EventMan.DimDetails
AFTER UPDATE, INSERT, DELETE
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Eventman.UpdateLog WHERE tablename = 'DimDetails' AND [time] = GETDATE())
    BEGIN
        INSERT INTO EventMan.UpdateLog (tablename, [time])
        VALUES ('DimDetails', GETDATE())
    END
END
;
GO
;
CREATE OR ALTER TRIGGER trigger_update_DimParticipant
ON EventMan.DimParticipant
AFTER UPDATE, INSERT, DELETE
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Eventman.UpdateLog WHERE tablename = 'DimParticipant' AND [time] = GETDATE())
    BEGIN
        INSERT INTO EventMan.UpdateLog (tablename, [time])
        VALUES ('DimParticipant', GETDATE())
    END
END
;
GO
;
CREATE OR ALTER TRIGGER trigger_update_FactEvent
ON EventMan.FactEvent
AFTER UPDATE, INSERT, DELETE
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM Eventman.UpdateLog WHERE tablename = 'FactEvent' AND [time] = GETDATE()) 
    BEGIN
        INSERT INTO EventMan.UpdateLog (tablename, [time])
        VALUES ('FactEvent', GETDATE())
    END
END
