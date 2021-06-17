---------Query for searching all tables containing a column EntityID
SELECT      c.name  AS 'ColumnName'
            ,t.name AS 'TableName'
FROM        sys.columns c
JOIN        sys.tables  t   ON c.object_id = t.object_id
WHERE       c.name LIKE '%checkin%'
ORDER BY    TableName, ColumnName;

select * from FormHistory