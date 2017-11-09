--Crea una base de datos con el nombre Falabella viajes con las siguientes especificaciones:
CREATE DATABASE FALABELLAVIAJES
ON PRIMARY
(
	NAME='FALABELLAVIAJES_PRI',
	FILENAME='C:\AGENCIA_sql\falabella_viajes.MDF',
	SIZE=10MB,
	MAXSIZE=60,
	FILEGROWTH=5%
)
LOG ON
(
	NAME='FALABELLAVIAJES_LOG',
	FILENAME='C:\AGENCIA_sql\falabella_viajes.LDF',
	SIZE=9MB,
	MAXSIZE=20MB,
	FILEGROWTH=20%
)
GO

USE FALABELLAVIAJES
GO
SP_HELPFILE FALABELLAVIAJES_PRI

GO

USE FALABELLAVIAJES
GO
SP_HELPFILE FALABELLAVIAJES_LOG

GO
--Se debe mostrar los pasajeros que no han hecho reserva aún. Recuerde que debe utilizar
--JOINS.
SELECT *
FROM PASAJERO LEFT JOIN PAGO
ON PASAJERO.IDPASAJERO = PAGO.IDPASAJERO
LEFT JOIN RESERVA
ON RESERVA.IDRESERVA = PAGO.IDRESERVA
WHERE ISNULL(PAGO.MONTO,0) = 0
GO
--Se deberá crear un procedimiento almacenado que permita mostrar los países que aún no
--tienen pasajero registrado.
CREATE PROCEDURE MUESTRAPAISSINREGISTROS
AS
	SELECT PAIS.PAIS
	FROM PAIS LEFT JOIN PASAJERO
	ON PAIS.IDPAIS = PASAJERO.IDPAIS
	LEFT JOIN PAGO
	ON PAGO.IDPASAJERO = PASAJERO.IDPASAJERO
	GROUP BY PAIS
	HAVING ISNULL(COUNT(PASAJERO.IDPASAJERO),0)=0

EXEC MUESTRAPAISSINREGISTROS

--Deberá crear un procedimiento almacenado con parámetro de entrada, mostrar las
--reservas de un determinado pasajero para este caso deberá considerar como parámetro
--de entrada el nombre del pasajero, defina de manera adecuada la cabecera del listado e
--implemente un mensaje de error en el caso que el pasajero no exista.
GO
CREATE PROCEDURE MUESTRAREGISTROSPASAJERO(@NOMBRE VARCHAR(50))
AS
	SELECT DISTINCT(PASAJERO.NOMBRES), RESERVA.*
	FROM RESERVA JOIN PAGO
	ON RESERVA.IDRESERVA = PAGO.IDRESERVA
	JOIN PASAJERO 
	ON PAGO.IDPASAJERO = PASAJERO.IDPASAJERO
	WHERE PASAJERO.NOMBRES = @NOMBRE
GO
EXEC MUESTRAREGISTROSPASAJERO @NOMBRE = 'KARLA GALLEGOS SILVA'
GO

--Deberá crear un procedimiento almacenado en donde se debe mostrar el listado de los
--países y su total de pasajeros.
CREATE PROCEDURE MUESTRAPAISYCANTIDADPASAJEROS
AS
	SELECT PAIS.PAIS, COUNT(PASAJERO.IDPASAJERO) AS [CANTIDAD PASAJEROS]
	FROM PASAJERO JOIN PAIS
	ON PASAJERO.IDPAIS = PAIS.IDPAIS
	GROUP BY PAIS
GO

EXEC MUESTRAPAISYCANTIDADPASAJEROS

--Procedimiento almacenado que permita registrar a un nuevo pasajero para este caso
--deberá definir como parámetros de entrada todos los campos referentes al pasajero a
--excepción del IDPAIS; aquí deberá ingresar el nombre del país, en caso no existe emitir un
--mensaje de “País no registrado en la Base”. Finalmente, si el pasajero se registra
--correctamente emitir un mensaje de “Pasajero registrado con éxito”.

SELECT * FROM PAIS ORDER BY PAIS ASC
GO

CREATE FUNCTION VERIFICARPAIS(@PAIS VARCHAR(30))
RETURNS CHAR(4)
AS
BEGIN
	DECLARE @NOMBREPAIS CHAR(30) = 'ARGENTINA'
	SET @NOMBREPAIS =
	CASE @NOMBREPAIS
	WHEN 'ARGENTINA' THEN '0002' 
	WHEN 'BOLIVIA' THEN  '0009'
	WHEN 'BRASIL' THEN '0005'
	WHEN 'CHILE' THEN '0003'
	WHEN 'ECUADOR' THEN '0004'
	WHEN 'EEUU' THEN '0012'
	WHEN 'HONDURAS' THEN '0011'
	WHEN 'MEXICO' THEN '0010'
	WHEN 'PARAGUAY' THEN '0007'
	WHEN 'PERU' THEN '001'
	WHEN 'PUERTO RICO' THEN '0013'
	WHEN 'URUGUAY' THEN '0008'
	WHEN 'VENEZUELA' THEN '0006'
	ELSE 'País no registrado en la Base'
	END
	RETURN @NOMBREPAIS
END
GO

IF OBJECT_ID('REGISTROPASAJEROS') IS NOT NULL
BEGIN
	DROP PROCEDURE REGISTROPASAJEROS
END
GO

CREATE PROCEDURE REGISTROPASAJEROS
(@IDPASAJERO CHAR(5), @NOMBRE VARCHAR(50),@PAIS VARCHAR(30), @TELEFONO CHAR(15), @EMAIL VARCHAR(50))
AS
	IF EXISTS(SELECT PASAJERO.* FROM PASAJERO
			WHERE IDPASAJERO = @IDPASAJERO
			AND NOMBRES = @NOMBRE AND IDPAIS = DBO.VERIFICARPAIS(@PAIS)
			AND TELEFONO = @TELEFONO AND EMAIL = @EMAIL)
	BEGIN
		PRINT 'EL PASAJERO YA EXISTE'
	END
	ELSE
	BEGIN
		INSERT INTO PASAJERO VALUES (@IDPASAJERO,@NOMBRE,DBO.VERIFICARPAIS(@PAIS),@TELEFONO,@EMAIL)
		PRINT 'PASAJERO INGRESADO CON EXITO'
	END

EXEC REGISTROPASAJEROS @IDPASAJERO='1111',@NOMBRE='ANDREA ELIZABETH QUINTRILEF ALMUNA', @PAIS = 'CHILE', @TELEFONO = '930341603',@EMAIL='ANDREQUINTRILEF@GMAIL.COM'

--Procedimiento que permita registrar un nuevo País para lo cual deberá definir como
--parámetro de entrada al nombre del país, aquí se deberá comprobar que dicho país no
--haya sido registrado antes si fuera el caso emitir un mensaje de “País ya registrado”, el
--código de este país es autogenerado por lo tanto no se ingresara como parámetro.
--Finalmente, si todo es correcto emitir un mensaje de “País registrado correctamente”.
GO

IF OBJECT_ID('REGISTRARPAIS') IS NOT NULL
BEGIN
	DROP PROCEDURE REGISTRARPAIS
END
GO


CREATE PROCEDURE REGISTRARPAIS
(@ID CHAR(4),@PAIS VARCHAR(30))
AS
	IF EXISTS(SELECT * FROM PAIS WHERE PAIS.IDPAIS = @ID AND PAIS.PAIS = @PAIS)
	BEGIN
		PRINT 'PAIS YA REGISTRADO'
	END
	ELSE
	BEGIN
		INSERT INTO PAIS VALUES(@ID,@PAIS)
		PRINT 'PAIS REGISTRADO CORRECTAMENTE'
	END

EXEC REGISTRARPAIS @ID = '0014',@PAIS = 'COSTA RICA'

--Se deberá crear un procedimiento en donde deberá controlar el registro de un pago de un
--nuevo cliente en la base de datos de la agencia. Recuerde utilizar if OBJECT_ID para
--eliminar un objeto que ya este creado en la base de datos de la agencia. Recuerde que se
--debe ejecutar el procedimiento almacenado.
SELECT * FROM PAGO

GO

CREATE PROCEDURE REGISTROPAGOCLIENTENUEVO
(@IDPASAJERO CHAR(5), @NOMBRE VARCHAR(50),@PAIS VARCHAR(30), @TELEFONO CHAR(15), @EMAIL VARCHAR(50), @NUMEROPAGO INT, @IDRESERVA INT, @FECHA DATE, @MONTO MONEY)
AS
	IF EXISTS(SELECT * FROM PAGO
				WHERE PAGO.NUMPAGO = @NUMEROPAGO AND PAGO.IDRESERVA = @IDRESERVA
				AND PAGO.IDPASAJERO = @IDPASAJERO AND PAGO.FECHA = @FECHA AND PAGO.MONTO = @MONTO)
	BEGIN
		PRINT 'OPERACION INVALIDA'
	END
	ELSE
	BEGIN TRY
		EXEC REGISTROPASAJEROS @IDPASAJERO = @IDPASAJERO,@NOMBRE = @NOMBRE, @PAIS = @PAIS, @TELEFONO = @TELEFONO, @EMAIL = @EMAIL
		INSERT INTO PAGO VALUES(@NUMEROPAGO, @IDRESERVA, @IDPASAJERO, @FECHA, @MONTO)
		PRINT 'PAGO Y NUEVO CLIENTE REGISTRADO'
	END TRY
	BEGIN CATCH
		SELECT
		ERROR_NUMBER()AS ERROR_NUMBER,
		ERROR_SEVERITY() AS ERROR_SEVERITY ,
		ERROR_STATE()AS ERROR_STATE,
		ERROR_PROCEDURE() AS ERROR_PROCEDURE,
		ERROR_LINE() AS ERROR_LINE,
		ERROR_MESSAGE() AS ERROR_MESSAGE
	END CATCH

EXEC REGISTROPAGOCLIENTENUEVO @IDPASAJERO = '2222', @NOMBRE = 'VOH MISMO', @PAIS = 'CHILE', @TELEFONO = '111111111', @EMAIL = 'ÑE@ÑE.CL', @NUMEROPAGO = '2222222', @IDRESERVA = '656', @FECHA = '2014-06-21', @MONTO = 0.0  

--Se superó el nivel máximo de anidamiento de vistas, procedimientos almacenados, funciones o desencadenadores (límite: 32).



--Se deberá crear una función en donde deberá retornar el promedio de pasajeros
--registrados en la base de datos.
GO

CREATE FUNCTION PROMEDIOPASAJEROS()
RETURNS DECIMAL
AS
BEGIN
	DECLARE @PROMEDIO DECIMAL

	SELECT @PROMEDIO = COUNT(EMAIL)
	FROM PASAJERO

	RETURN(SELECT AVG(@PROMEDIO) FROM PASAJERO)
END
GO

EXEC DBO.PROMEDIOPASAJEROS

GO
--Se deberá crear una función promedio en donde deberá mostrar cuantos pasajeros son
--del país argentina.
CREATE FUNCTION PROMEDIOPASAJEROSARGENTINA()
RETURNS DECIMAL
AS
BEGIN
	DECLARE @ALGO DECIMAL

	SELECT @ALGO=COUNT(EMAIL)
	FROM PASAJERO
	WHERE PASAJERO.IDPAIS = DBO.VERIFICARPAIS('ARGENTINA')
	
	RETURN(SELECT AVG(@ALGO)
	FROM PASAJERO
	WHERE PASAJERO.IDPAIS = DBO.VERIFICARPAIS('ARGENTINA'))
END
GO

EXEC DBO.PROMEDIOPASAJEROSARGENTINA

--Se deberá crear un informe en donde la función deberá sacar el promedio de todos los
--costos de los pasajeros que fueron inscritos en la base de datos. Recuerden que se tiene
--que probar esta función en la base de datos.
GO

IF OBJECT_ID('PROMEDIOSDEPAGOPORPASAJERO') IS NOT NULL
BEGIN
	DROP PROCEDURE PROMEDIOSDEPAGOPORPASAJERO
END
GO

CREATE PROCEDURE PROMEDIOSDEPAGOPORPASAJERO
AS
	BEGIN
		DECLARE @MONTOPROMEDIO INT=0
		DECLARE @NOMBRE VARCHAR(100) = ''
		DECLARE CURSORSI CURSOR
		FOR SELECT NOMBRES, AVG(PAGO.MONTO)
			FROM PAGO JOIN PASAJERO 
			ON PAGO.IDPASAJERO = PASAJERO.IDPASAJERO 
			GROUP BY PASAJERO.NOMBRES
			OPEN CURSORSI

			FETCH CURSORSI INTO @NOMBRE, @MONTOPROMEDIO
			PRINT 'INFOME DE PROMEDIOS DE PAGOS DE PASAJEROS'
			PRINT '**********************************'
			WHILE @@FETCH_STATUS = 0
			BEGIN
				PRINT '* NOMBRE:'+TRIM(@NOMBRE)+'    *'
				PRINT '* PROMEDIO: '+CAST(@MONTOPROMEDIO AS VARCHAR(50))+'                 *'
				PRINT '**********************************'
				FETCH CURSORSI INTO @NOMBRE, @MONTOPROMEDIO
			END
			CLOSE CURSORSI
			DEALLOCATE CURSORSI
	END

EXEC PROMEDIOSDEPAGOPORPASAJERO

--Se deberá crear una función en donde se deberá mostrar los puntos acumulados x mes y
--año de todos los pasajeros.

--NO EXISTE EL ATRIBUTO O TABLA PUNTOS ACUMULADOS ;)


--Se necesita saber cuáles son los países más visitados y cuál es la cantidad de pesos
--ganados por esos destinos.

SELECT PAIS.PAIS, COUNT(PASAJERO.IDPAIS) AS [NUMERO VIAJES], SUM(PAGO.MONTO) AS [MONTO GANADO]
FROM PAIS JOIN PASAJERO
ON PAIS.IDPAIS = PASAJERO.IDPAIS
JOIN PAGO
ON PASAJERO.IDPASAJERO = PAGO.IDPASAJERO
GROUP BY PAIS.PAIS
ORDER BY SUM(PAGO.MONTO) DESC

--Usted muéstreme un ejemplo de cómo se utiliza los siguientes temas en sql server
--a. Cursores en la base de datos
--b. If en la base de datos
--c. Joins al menos 3 en la base de datos
--d. Estructura del while en la base de datos
--e. Trabajando con like , between , in dependiendo las condiciones de búsqueda en la
--base de datos.
--f. Control de Errores que se pueden producir en la base de datos
--Es recomendable que el código que usted crea aplicando estos conceptos estén
--relacionado con la base de datos de la agencia de viaje

