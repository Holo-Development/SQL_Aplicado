USE [AGENCIA]
DECLARE MICURSORBAS CURSOR
	FOR SELECT * FROM PASAJERO
OPEN MICURSORBAS

FETCH NEXT FROM MICURSORBAS
GO
CLOSE MICURSORBAS
GO
DEALLOCATE MICURSORBAS
GO
-------------------------------------------------------
-- TRABAJANDO CON CURSORES CASO 2 APLICANDO VARIABLES
-------------------------------------------------------
--DECLARANDO LAS VARIABLES
DECLARE @IDPA CHAR(5), @NOM CHAR(30), @PAI CHAR(30), 
		@TEL CHAR(15), @EMA VARCHAR(40), @TOTAL INT=0
--DECLARANDO EL CURSOR CON LAS RESTRICCIONES QUE YO QUIERO
DECLARE MICURSOR CURSOR
FOR SELECT PAS.IDPASAJERO, PAS.NOMBRES, PAI.PAIS, PAS.TELEFONO, PAS.EMAIL
	FROM PASAJERO PAS
	JOIN PAIS PAI 
	ON PAS.IDPAIS = PAI.IDPAIS
OPEN MICURSOR

FETCH MICURSOR INTO @IDPA, @NOM , @PAI, @TEL, @EMA
PRINT 'CODIGO	PASAJERO	PAIS	TELEFONO	EMAIL '
PRINT '------------------------------------------------------------'
WHILE @@FETCH_STATUS=0 
BEGIN 
	SET @TOTAL += 1
PRINT @IDPA+SPACE(5)+@NOM+SPACE(5)+@PAI+SPACE(5)+@TEL+SPACE(5)+@EMA
FETCH MICURSOR INTO @IDPA , @NOM , @PAI, @TEL, @EMA
END

PRINT 'EL TOTAL DE PASAJEROS ES:>>' + CAST(@TOTAL AS CHAR(6))
CLOSE MICURSOR
DEALLOCATE MICURSOR

-- TRABAJANDO CON FUNCIONES --

CREATE FUNCTION MESLETRAS(@FECHA DATE)
RETURNS VARCHAR(20)
AS
BEGIN
DECLARE @NOMBRE VARCHAR(20)
SET @NOMBRE = 
		CASE DATENAME(MONTH,@FECHA)
		WHEN 'JANUARY' THEN 'ENERO'
		WHEN 'FEBRUARY' THEN 'FEBRERO'
		WHEN 'MARCH' THEN 'MARZO'
		WHEN 'APRIL' THEN 'ABRIL'
		WHEN 'MAY' THEN 'MAYO'
		WHEN 'JUNE' THEN 'JUNIO'
		WHEN 'JULY' THEN 'JULIO'
		WHEN 'AUGUST' THEN 'AGOSTO'
		WHEN 'SEPTEMBER' THEN 'SEPTIEMBRE'
		WHEN 'OCTOBER' THEN 'OCTUBRE'
		WHEN 'NOVEMBER' THEN 'NOVIEMBRE'
		WHEN 'DECEMBER' THEN 'DICIEMBRE'
END
RETURN @NOMBRE
END
GO
-------------------------------------
--PROBAR LA FUNCION
---------------------------------------
SELECT DBO.MESLETRAS(GETDATE()) AS [MES ACTUAL]
GO

DECLARE @FEC DATE=GETDATE()
PRINT 'LA FECHA'+CAST(@FEC AS VARCHAR(15)) +'TIENE COMO MAS A:' +DBA.MISLETRAS(GETDATE())
GO
SELECT PAG.IDRESERVA AS [NUMERO RESERVA],
	   PAS.NOMBRES AS [PASAJERO],
	   CAST(DAY(FECHA) AS CHAR(2))+'DE'+DBO.MESLETRAS(FECHA)+'DEL'+CAST(YEAR(FECHA) AS CHAR(4)) AS [FECHA],
	   PAG.MONTO AS [MONTO DE PAGO]
	   FROM PAGO PAG
	   JOIN PASAJERO PAS ON PAG.IDPASAJERO=PAS.IDPASAJERO
GO
	    

/*ALTER FUNCTION MIPROMEDIO(@VALOR1 INT , @VALOR2 INT)
RETURNS DECIMAL (10,2)
AS
BEGIN
	DECLARE @RESULTADO DECIMAL(10,2)
	SET @RESULTADO=(@VALOR1+@VALOR2)/2.0
	RETURN @RESULTADO
END
GO
SELECT DBO.MIPROMEDIO(12,13) AS
*/