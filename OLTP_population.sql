INSERT INTO Eventman.EventStatus (status)
VALUES ('Planned')
        , ('Confirmed')
        , ('Canceled'),
        ('Completed')
;
INSERT INTO Eventman.ParticipantStatus (status)
SELECT DISTINCT Participant_Status
FROM Eventman.event
;
INSERT INTO Eventman.Clients (lastname, email, phone)
SELECT DISTINCT Client_Name, Client_Email, Client_Phone
FROM Eventman.event
;
INSERT INTO Eventman.EventType (typename)
SELECT DISTINCT Event_Type
FROM Eventman.event
;
INSERT INTO Eventman.Suppliers (company, email, phone)
SELECT DISTINCT Supplier_Name, Supplier_Email, Supplier_Phone
FROM Eventman.event
;
INSERT INTO Eventman.Service (servicename)
SELECT DISTINCT Service
FROM Eventman.event
;
INSERT INTO Eventman.Participants (lastname, email)
SELECT DISTINCT Participant_Name, Participant_Email
FROM Eventman.event
;
INSERT INTO Eventman.Events (name, location, startdate, budget, typeid, clientid, statusid)
SELECT DISTINCT Event_Name, Location, Event_Date, Budget, et.typeid, c.clientid, es.statusid
FROM Eventman.event JOIN Eventman.EventType et ON
    Eventman.event.Event_Type = et.typename
    JOIN Eventman.Clients c ON c.lastname = Eventman.event.Client_Name
    AND c.email = Eventman.event.Client_Email
    AND c.phone = Eventman.event.Client_Phone
    JOIN Eventman.EventStatus es on es.status = 'Confirmed'
;
INSERT INTO Eventman.Payments (amount, date, eventid)
SELECT DISTINCT e.Payment_amount, e.Payment_Date, ev.eventid
FROM Eventman.event e JOIN Eventman.Events ev ON e.Event_Name = ev.name
AND e.Event_Date = ev.startdate
AND e.Location = ev.location
;
INSERT INTO Eventman.EventParticipants (eventid, partid, statusid)
SELECT DISTINCT ev.eventid, p.partid, ps.statusid
FROM Eventman.event e JOIN Eventman.Events ev ON e.Event_Name = ev.name
AND e.Event_Date = ev.startdate
AND e.Location = ev.location
JOIN Eventman.Participants p ON e.Participant_Name = p.lastname
AND e.Participant_Email = p.email
JOIN Eventman.Participantstatus ps on e.Participant_Status = ps.status
;
INSERT INTO Eventman.EventSuppliers (eventid, supplierid, serviceid, cost)
SELECT DISTINCT ev.eventid, s.supplierid, ser.serviceid, e.Service_Cost
FROM Eventman.event e
JOIN Eventman.Events ev ON e.Event_Name = ev.name
AND e.location = ev.location
AND e.Event_Date = ev.startdate
JOIN Eventman.Suppliers s ON e.Supplier_Name = s.company
AND e.Supplier_Email = s.email
AND e.Supplier_Phone = s.phone
JOIN Eventman.Service ser ON e.Service = ser.servicename