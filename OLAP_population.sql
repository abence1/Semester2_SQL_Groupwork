TRUNCATE TABLE EventMan.Updatelog
MERGE INTO EventMan.DimSuppliers AS target
USING   (
            SELECT DISTINCT
                s.supplierid,
                se.servicename,
                s.company,
                s.email,
                s.phone
            FROM Eventman.Suppliers s
            INNER JOIN EventMan.EventSuppliers es ON es.supplierid = s.supplierid
            INNER JOIN EventMan.Service se ON se.serviceid = es.serviceid 
            WHERE s.modifiedon > isnull((
									SELECT MAX(time)
									FROM EventMan.UpdateLog ul
									WHERE ul.tablename = 'DimSuppliers'
								), 0)
    ) AS source
ON target.servicename = source.servicename AND target.supplierid = source.supplierid
WHEN MATCHED THEN
    UPDATE SET
        target.servicename = source.servicename,
        target.company = source.company,
        target.email = source.email,
        target.phone = source.phone
WHEN NOT MATCHED BY target THEN
    INSERT (supplierid, servicename, company, email, phone)
    VALUES (source.supplierid, source.servicename, source.company, source.email, source.phone)
;
MERGE INTO EventMan.DimClients AS target 
USING   (
            SELECT clientid, firstname, lastname, phone, email
            FROM EventMan.Clients
			WHERE modifiedon >	isnull((
									SELECT MAX(time)
									FROM EventMan.UpdateLog ul
									WHERE ul.tablename = 'DimClients'
								), 0)
        ) AS source
ON target.clientkey = source.clientid
WHEN MATCHED THEN
	UPDATE SET 
		target.firstname = source.firstname,
		target.lastname = source.lastname,
		target.phone = source.phone,
		target.email = source.email
WHEN NOT MATCHED BY target
THEN
	INSERT (clientkey, firstname, lastname, phone, email)
	VALUES (source.clientid, source.firstname, source.lastname, source.phone, source.email)
;
MERGE INTO EventMan.DimDetails AS target
USING	(
			SELECT DISTINCT
				e.eventid,
				e.name,
				e.location,
				e.startdate,
				e.enddate,
				es.status,
				et.typename
			FROM EventMan.Events e
			INNER JOIN EventMan.EventStatus es ON es.statusid = e.statusid
			INNER JOIN EventMan.EventType et ON et.typeid = e.typeid
			WHERE e.modifiedon > ISNULL((
				SELECT MAX(time)
				FROM EventMan.UpdateLog ul
				WHERE ul.tablename = 'DimDetails'
			), 0)
		) AS source
ON target.detailskey = source.eventid
WHEN MATCHED THEN
	UPDATE SET
		target.name = source.name,
		target.location = source.location,
		target.startdate = source.startdate,
		target.enddate = source.enddate,
		target.eventstatus = source.status,
		target.typename = source.typename
WHEN NOT MATCHED BY target THEN
	INSERT (detailskey, name, location, startdate, enddate, eventstatus, typename)
	VALUES (source.eventid, source.name, source.location, source.startdate, source.enddate, source.status, source.typename)
;
MERGE INTO EventMan.DimParticipant AS target
USING	(
			SELECT DISTINCT
				p.partid,
				ps.status,
				p.firstname,
				p.lastname,
				p.email
			FROM EventMan.Participants p
			INNER JOIN EventMan.EventParticipants ep ON ep.partid = p.partid
			INNER JOIN EventMan.ParticipantStatus ps ON ps.statusid = ep.statusid
			WHERE p.modifiedon > ISNULL((
				SELECT MAX(time)
				FROM EventMan.UpdateLog ul
				WHERE ul.tablename = 'DimParticipant'
			), 0)
		) AS source
ON target.partid = source.partid AND target.participantstatus = source.status
WHEN MATCHED THEN
	UPDATE SET
		target.participantstatus = source.status,
		target.firstname = source.firstname,
		target.lastname = source.lastname,
		target.email = source.email
WHEN NOT MATCHED BY target THEN
	INSERT (partid, participantstatus, firstname, lastname, email)
	VALUES (source.partid, source.status, source.firstname, source.lastname, source.email)
;
DECLARE @CurrentDate DATE;
DECLARE @EndDate DATE = '2030-12-31';

SELECT @CurrentDate = MIN(date) 
FROM EventMan.Payments;

WHILE @CurrentDate <= @EndDate
BEGIN
    INSERT INTO EventMan.DimDate (date)
    VALUES (@CurrentDate);
    SET @CurrentDate = DATEADD(day, 1, @CurrentDate);
END
;
MERGE INTO EventMan.FactEvent AS target
USING	(
            SELECT 
                p.paymentid,
                e.eventid,
                e.budget,
                p.amount AS payment_amount,
                (SELECT SUM(cost) FROM EventMan.EventSuppliers WHERE eventid = e.eventid) AS total_cost,
                (SELECT TOP 1 participantkey FROM EventMan.DimParticipant WHERE partid IN 
                        (SELECT partid FROM EventMan.EventParticipants WHERE eventid = e.eventid)) AS participantkey,
                dc.clientkey,
                dd.datekey,
                det.detailskey,
                (SELECT TOP 1 supplierkey FROM EventMan.DimSuppliers WHERE supplierid IN 
                        (SELECT supplierid FROM EventMan.EventSuppliers WHERE eventid = e.eventid)) AS supplierkey
            FROM EventMan.Payments p
            INNER JOIN EventMan.Events e ON p.eventid = e.eventid
            INNER JOIN EventMan.DimClients dc ON e.clientid = dc.clientkey
            INNER JOIN EventMan.DimDate dd ON CAST(p.[date] AS DATE) = CAST(dd.[date] AS DATE)
            INNER JOIN EventMan.DimDetails det ON e.eventid = det.detailskey
    ) AS source
ON target.paymentid = source.paymentid
WHEN MATCHED THEN
    UPDATE SET 
        target.budget = Source.budget,
        target.payment_amount = Source.payment_amount,
        target.cost = Source.total_cost,
        target.participantkey = Source.participantkey,
        target.clientkey = Source.clientkey,
        target.datekey = Source.datekey,
        target.detailskey = Source.detailskey,
        target.supplierkey = Source.supplierkey
WHEN NOT MATCHED BY target THEN
	INSERT (paymentid, budget, payment_amount, cost, participantkey, clientkey, datekey, detailskey, supplierkey)
	VALUES (Source.paymentid, Source.budget, Source.payment_amount, Source.total_cost, Source.participantkey, Source.clientkey, Source.datekey, Source.detailskey, Source.supplierkey)
;

