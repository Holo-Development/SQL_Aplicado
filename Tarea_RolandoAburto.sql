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
--Se debe mostrar los pasajeros que no han hecho reserva a�n. Recuerde que debe utilizar
--JOINS.
SELECT *
FROM PASAJERO LEFT JOIN PAGO
ON PASAJERO.IDPASAJERO = PAGO.IDPASAJERO
LEFT JOIN RESERVA
ON RESERVA.IDRESERVA = PAGO.IDRESERVA
WHERE ISNULL(PAGO.MONTO,0) = 0
GO
--Se deber� crear un procedimiento almacenado que permita mostrar los pa�ses que a�n no
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

--Deber� crear un procedimiento almacenado con par�metro de entrada, mostrar las
--reservas de un determinado pasajero para este caso deber� considerar como par�metro
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

--Deber� crear un procedimiento almacenado en donde se debe mostrar el listado de los
--pa�ses y su total de pasajeros.
CREATE PROCEDURE MUESTRAPAISYCANTIDADPASAJEROS
AS
	SELECT PAIS.PAIS, COUNT(PASAJERO.IDPASAJERO) AS [CANTIDAD PASAJEROS]
	FROM PASAJERO JOIN PAIS
	ON PASAJERO.IDPAIS = PAIS.IDPAIS
	GROUP BY PAIS
GO

EXEC MUESTRAPAISYCANTIDADPASAJEROS

--Procedimiento almacenado que permita registrar a un nuevo pasajero para este caso
--deber� definir como par�metros de entrada todos los campos referentes al pasajero a
--excepci�n del IDPAIS; aqu� deber� ingresar el nombre del pa�s, en caso no existe emitir un
--mensaje de �Pa�s no registrado en la Base�. Finalmente, si el pasajero se registra
--correctamente emitir un mensaje de �Pasajero registrado con �xito�.

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
	ELSE 'Pa�s no registrado en la Base'
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

--Procedimiento que permita registrar un nuevo Pa�s para lo cual deber� definir como
--par�metro de entrada al nombre del pa�s, aqu� se deber� comprobar que dicho pa�s no
--haya sido registrado antes si fuera el caso emitir un mensaje de �Pa�s ya registrado�, el
--c�digo de este pa�s es autogenerado por lo tanto no se ingresara como par�metro.
--Finalmente, si todo es correcto emitir un mensaje de �Pa�s registrado correctamente�.
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

--Se deber� crear un procedimiento en donde deber� controlar el registro de un pago de un
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

EXEC REGISTROPAGOCLIENTENUEVO @IDPASAJERO = '2222', @NOMBRE = 'VOH MISMO', @PAIS = 'CHILE', @TELEFONO = '111111111', @EMAIL = '�E@�E.CL', @NUMEROPAGO = '2222222', @IDRESERVA = '656', @FECHA = '2014-06-21', @MONTO = 0.0  

--Se super� el nivel m�ximo de anidamiento de vistas, procedimientos almacenados, funciones o desencadenadores (l�mite: 32).



--Se deber� crear una funci�n en donde deber� retornar el promedio de pasajeros
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
--Se deber� crear una funci�n promedio en donde deber� mostrar cuantos pasajeros son
--del pa�s argentina.
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

--Se deber� crear un informe en donde la funci�n deber� sacar el promedio de todos los
--costos de los pasajeros que fueron inscritos en la base de datos. Recuerden que se tiene
--que probar esta funci�n en la base de datos.
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

--Se deber� crear una funci�n en donde se deber� mostrar los puntos acumulados x mes y
--a�o de todos los pasajeros.

--NO EXISTE EL ATRIBUTO O TABLA PUNTOS ACUMULADOS ;)


--Se necesita saber cu�les son los pa�ses m�s visitados y cu�l es la cantidad de pesos
--ganados por esos destinos.

SELECT PAIS.PAIS, COUNT(PASAJERO.IDPAIS) AS [NUMERO VIAJES], SUM(PAGO.MONTO) AS [MONTO GANADO]
FROM PAIS JOIN PASAJERO
ON PAIS.IDPAIS = PASAJERO.IDPAIS
JOIN PAGO
ON PASAJERO.IDPASAJERO = PAGO.IDPASAJERO
GROUP BY PAIS.PAIS
ORDER BY SUM(PAGO.MONTO) DESC

--Usted mu�streme un ejemplo de c�mo se utiliza los siguientes temas en sql server
--a. Cursores en la base de datos
--b. If en la base de datos
--c. Joins al menos 3 en la base de datos
--d. Estructura del while en la base de datos
--e. Trabajando con like , between , in dependiendo las condiciones de b�squeda en la
--base de datos.
--f. Control de Errores que se pueden producir en la base de datos
--Es recomendable que el c�digo que usted crea aplicando estos conceptos est�n
--relacionado con la base de datos de la agencia de viaje

