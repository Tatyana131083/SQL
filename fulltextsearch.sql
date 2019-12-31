SELECT *
FROM [Production].[ProductDescription]
WHERE CONTAINS([Description], 'RIDE')

SELECT *
FROM [Production].[ProductDescription]
WHERE FREETEXT([Description], 'RIDE')