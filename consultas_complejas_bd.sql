SELECT COUNT(*) AS [TOTAL PERSONAS]
FROM PASAJERO
GO

-------------------------------------

SELECT COUNT(ALL IDPASAJERO) AS [TOTAL PASAJERO]
FROM PASAJERO
GO

DECLARE @TOTAL INT
SELECT @TOTAL=COUNT(*)
FROM PASAJERO

PRINT 'TOTAL DE PASAJEROS ES:'+CAST(@TOTAL AS CHAR(3))
GO

SELECT PAI.PAIS AS [PAIS], COUNT(*) AS [TOTAL PASAJEROS]
FROM PASAJERO PAS
	JOIN PAIS PAI ON PAS.IDPAIS=PAI.IDPAIS
	GROUP BY PAI.PAIS

GO

SELECT PAI.PAIS AS [PAIS], COUNT(*) AS [TOTAL PASAJEROS]
	FROM PASAJERO PAS
	JOIN PAIS PAI ON PAS.IDPAIS=PAI.IDPAIS
	GROUP BY PAI.PAIS
	HAVING COUNT(*) > 1

GO

SELECT PAI.PAIS AS [PAIS], COUNT(DISTINCT PAS.NOMBRES) AS [TOTAL PASAJEROS], SUM(MONTO) AS [MONTO ACUMULADO]
	FROM PASAJERO PAS
	JOIN PAIS PAI ON PAS.IDPAIS=PAI.IDPAIS
	JOIN PAGO PAG ON PAS.IDPASAJERO=PAG.IDPASAJERO
GROUP BY PAI.PAIS

GO

DECLARE @MAXIMO INT
SELECT @MAXIMO=MAX(MONTO)
FROM PAGO

SELECT PAS.*
	FROM PASAJERO PAS
	WHERE PAS.IDPASAJERO=(SELECT IDPASAJERO
							FROM PAGO
							WHERE MONTO=@MAXIMO)

GO

DECLARE @MAXIMO INT, @MINIMO INT
SELECT @MAXIMO=MAX(MONTO), @MINIMO=MIN(MONTO) 
FROM PAGO

SELECT PAS.*, PAG.MONTO AS MONTO_MAX
FROM PASAJERO PAS
JOIN PAGO PAG ON PAS.IDPASAJERO=PAG.IDPASAJERO
WHERE PAG.MONTO=@MAXIMO
UNION
SELECT PAS.*, PAG.MONTO AS MONTO_MIN
FROM PASAJERO PAS
JOIN PAGO PAG ON PAS.IDPASAJERO=PAG.IDPASAJERO
WHERE PAG.MONTO=@MINIMO
GO

SELECT 'PASAJERO' AS [TABLA],
	COUNT(*) AS [TOTAL]
	FROM PASAJERO

UNION
SELECT 'PAIS' AS [TABLA],
	COUNT(*) AS [TOTAL]
	FROM PAIS
UNION
SELECT 'RESERVA' AS [TABLA],
	COUNT(*) AS [TOTAL]
	FROM RESERVA
GO
