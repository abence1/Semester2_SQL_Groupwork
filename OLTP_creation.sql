DROP TABLE IF EXISTS EventMan.EventSuppliers
DROP TABLE IF EXISTS EventMan.EventParticipants
DROP TABLE IF EXISTS EventMan.ParticipantStatus
DROP TABLE IF EXISTS EventMan.Service
DROP TABLE IF EXISTS EventMan.Suppliers
DROP TABLE IF EXISTS EventMan.Participants
DROP TABLE IF EXISTS EventMan.Payments
DROP TABLE IF EXISTS EventMan.Events
DROP TABLE IF EXISTS EventMan.Clients
DROP TABLE IF EXISTS EventMan.EventType
DROP TABLE IF EXISTS EventMan.EventStatus
;
CREATE TABLE EventMan.EventStatus
(
    statusid INT NOT NULL IDENTITY PRIMARY KEY,
    status VARCHAR(100),
    modifiedon datetime
)
CREATE TABLE EventMan.EventType
(
    typeid INT NOT NULL IDENTITY PRIMARY KEY,
    typename VARCHAR(100),
    modifiedon datetime
)
CREATE TABLE EventMan.Clients
(
    clientid INT NOT NULL IDENTITY PRIMARY KEY,
    firstname VARCHAR(100),
    lastname VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(100),
    modifiedon datetime
)
CREATE TABLE EventMan.Events
(
    eventid INT NOT NULL IDENTITY PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(100),
    startdate DATETIME,
    enddate DATETIME,
    typeid INT NOT NULL FOREIGN KEY REFERENCES EventMan.EventType(typeid),
    clientid INT NOT NULL FOREIGN KEY REFERENCES EventMan.Clients(clientid),
    budget INT,
    statusid INT NOT NULL FOREIGN KEY REFERENCES EventMan.EventStatus(statusid),
    modifiedon datetime
)
CREATE TABLE EventMan.Payments
(
    paymentid INT NOT NULL IDENTITY PRIMARY KEY,
    amount INT,
    eventid INT NOT NULL FOREIGN KEY REFERENCES EventMan.Events(eventid),
    date DATETIME,
    modifiedon datetime
)
CREATE TABLE EventMan.Participants
(
    partid INT NOT NULL IDENTITY PRIMARY KEY,
    firstname VARCHAR(100),
    lastname VARCHAR(100),
    email VARCHAR(100),
    modifiedon datetime
)
CREATE TABLE EventMan.Suppliers
(
    supplierid INT NOT NULL IDENTITY PRIMARY KEY,
    company VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(100),
    modifiedon datetime
)
CREATE TABLE EventMan.Service
(
    serviceid INT NOT NULL IDENTITY PRIMARY KEY,
    servicename VARCHAR(100),
    modifiedon datetime
)
CREATE TABLE EventMan.ParticipantStatus
(
    statusid INT NOT NULL IDENTITY PRIMARY KEY,
    status VARCHAR(100),
    modifiedon datetime
)
CREATE TABLE EventMan.EventParticipants
(
    eventid INT NOT NULL FOREIGN KEY REFERENCES EventMan.Events(eventid),
    partid INT NOT NULL FOREIGN KEY REFERENCES EventMan.Participants(partid),
    statusid INT NOT NULL FOREIGN KEY REFERENCES EventMan.ParticipantStatus(statusid),
    CONSTRAINT PK_EventParticipants PRIMARY KEY (eventid, partid),
    modifiedon datetime
)
CREATE TABLE EventMan.EventSuppliers
(
    id INT NOT NULL IDENTITY PRIMARY KEY,
    eventid INT NOT NULL FOREIGN KEY REFERENCES EventMan.Events(eventid),
    supplierid INT NOT NULL FOREIGN KEY REFERENCES Eventman.Suppliers(supplierid),
    serviceid INT NOT NULL FOREIGN KEY REFERENCES EventMan.Service(serviceid),
    cost INT NOT NULL,
    modifiedon datetime
)
GO
CREATE OR ALTER TRIGGER trigger_timestamp_EventStatus
ON Eventman.EventStatus
FOR INSERT, UPDATE
AS
BEGIN 
    UPDATE es SET modifiedon = GETDATE()
    FROM EventMan.EventStatus es
    INNER JOIN inserted i ON i.statusid = es.statusid
END
GO
CREATE OR ALTER TRIGGER trigger_timestamp_EventType
ON EventMan.EventType
FOR INSERT, UPDATE
AS
BEGIN 
    UPDATE et SET modifiedon = GETDATE()
    FROM EventMan.EventType et
    INNER JOIN inserted i ON i.typeid = et.typeid
END
GO
CREATE OR ALTER TRIGGER trigger_timestamp_Clients
ON EventMan.Clients
FOR INSERT, UPDATE
AS
BEGIN 
    UPDATE c SET modifiedon = GETDATE()
    FROM EventMan.Clients c
    INNER JOIN inserted i ON i.clientid = c.clientid
END
GO
CREATE OR ALTER TRIGGER trigger_timestamp_Events
ON EventMan.Events
FOR INSERT, UPDATE
AS
BEGIN 
    UPDATE e SET modifiedon = GETDATE()
    FROM EventMan.Events e
    INNER JOIN inserted i ON i.eventid = e.eventid
END
GO
CREATE OR ALTER TRIGGER trigger_timestamp_Payments
ON EventMan.Payments
FOR INSERT, UPDATE
AS
BEGIN 
    UPDATE p SET modifiedon = GETDATE()
    FROM EventMan.Payments p
    INNER JOIN inserted i ON i.paymentid = p.paymentid
END
GO
CREATE OR ALTER TRIGGER trigger_timestamp_Participants
ON EventMan.Participants
FOR INSERT, UPDATE
AS
BEGIN 
    UPDATE p SET modifiedon = GETDATE()
    FROM EventMan.Participants p
    INNER JOIN inserted i ON i.partid = p.partid
END
GO
CREATE OR ALTER TRIGGER trigger_timestamp_Suppliers
ON EventMan.Suppliers
FOR INSERT, UPDATE
AS
BEGIN 
    UPDATE s SET modifiedon = GETDATE()
    FROM EventMan.Suppliers s
    INNER JOIN inserted i ON i.supplierid = s.supplierid
END
GO
CREATE OR ALTER TRIGGER trigger_timestamp_Service
ON EventMan.Service
FOR INSERT, UPDATE
AS
BEGIN 
    UPDATE s SET modifiedon = GETDATE()
    FROM EventMan.Service s
    INNER JOIN inserted i ON i.serviceid = s.serviceid
END
GO
CREATE OR ALTER TRIGGER trigger_timestamp_ParticipantStatus
ON EventMan.ParticipantStatus
FOR INSERT, UPDATE
AS
BEGIN 
    UPDATE ps SET modifiedon = GETDATE()
    FROM EventMan.ParticipantStatus ps
    INNER JOIN inserted i ON i.statusid = ps.statusid
END
GO
CREATE OR ALTER TRIGGER trigger_timestamp_EventParticipants
ON EventMan.EventParticipants
FOR INSERT, UPDATE
AS
BEGIN 
    UPDATE ep SET modifiedon = GETDATE()
    FROM EventMan.EventParticipants ep
    INNER JOIN inserted i ON i.eventid = ep.eventid AND i.partid = ep.partid
END
GO
CREATE OR ALTER TRIGGER trigger_timestamp_EventSuppliers
ON EventMan.EventSuppliers
FOR INSERT, UPDATE
AS
BEGIN 
    UPDATE es SET modifiedon = GETDATE()
    FROM EventMan.EventSuppliers es
    INNER JOIN inserted i ON i.id = es.id
END