---------------------------------------------
					         -- TRABAJANDO CON MARGE
------------------------------------------------------------------------------------
--MERGE PERMITE COMBINR UN ORIGEN DE DATOS CON UNA TABLA O VISTA DE DESTINO
--SE PUEDE INSERTAR, ACTUALIZAR O ELIMINAR EN UNA SOLA INSTRUCCION UTILIZANDO MARGE
------------------------------------------------------------------------------------

DECLARE @IDPAS CHAR(5) = 'POO10' , @MON VARCHAR(40)='GUADALUPE ACOSTA FERRER', 
		@IDPAI CHAR(4) = '0003' , @FONO CHAR(15)='93847547' ,
		@EMA VARCHAR(40) = 'GACOSTA@GMAIL.COM'
MERGE PASAJERO AS TARGET
USING(SELECT @IDPAS , @MON , @IDPAI , @FONO , @EMA) AS
	 SOURCE(IDPASAJERO,NOMBRES,IDPAIS,TELEFONO,EMAIL)
	 ON(TARGET.IDPASAJERO=SOURCE.IDPASAJERO)
WHEN MATCHED THEN 
	 UPDATE SET IDPASAJERO=SOURCE.IDPASAJERO , NOMBRES = SOURCE.NOMBRES , 
				IDPAIS=SOURCE.IDPAIS , TELEFONO = SOURCE.TELEFONO , EMAIL = SOURCE.EMAIL

WHEN NOT MATCHED THEN
	INSERT VALUES(SOURCE.IDPASAJERO,SOURCE.NOMBRES,SOURCE.IDPAIS,SOURCE.TELEFONO,SOURCE.EMAIL);
GO

--------------------------------------------------------------------------------------
--VERIFICAR SI INGRESO LA INFORMACION
-------------------------------------------------------------------------------------

SELECT * FROM PASAJERO
GO

-------------------------------------------------------------------------------------
--TRABAJANDO CON OPERACIONES ARITMETICAS
-------------------------------------------------------------------------------------
SELECT '2 + (4+2)' AS [EXPRESION] ,
		2 + (4+2) AS [RESULTADOS]
GO

-------------------------------------------------------------------------------------
SELECT '2 + (4+2)' AS [EXPRESION] ,
		2 + (4+2) AS [RESULTADOS]
GO
PRINT 'LA EXPRESION 2+(4+2) TIENE COMO RESULTADO ' +
	   2+(4+2)
GO

-------------------------------------------------------------------------------------
DECLARE @PI FLOAT
SET @PI = 3.1415
SELECT @PI AS [VALOR PI]
GO
-----------------------------------------------------------------------------------
DECLARE @PI FLOAT
SET @PI = 3.1415
PRINT 'EL VALOR DE PI ES: ' + LTRIM(CAST(@PI AS FLOAT))
GO
----------------------------------------------------------------------------------
--APLICANDO ANY SOME
----------------------------------------------------------------------------------
--ESTAMOS DECLARANDO LAS VARIABLES Y SE INICIALIZADO
DECLARE @AÑO INT=2011
DECLARE @MONTO MONEY=10000
-- SI EL MONTO CUMPLE LA CONDICION ---
-- ANY Y SOME SON SINONIMO, CHEQUEAR SI ALGUNA FILA DE LA LISTA RESULTADO DE
-- UNA SUBCONSULTA SE ENCUENTRA EL VALOR ESPECIFICADO EN LA CONDICION

--COMPARA UN VALOR ESCAKAR CON LOS VALORES DE UN CAMPO Y DEVUELVE *TRUE* SI LA
--COMPARACION CON CADA VALOR DE LA LISTA DE LA SUBCONSULTA ES VERDADERAM SI NO FALSE
IF @MONTO > SOME(SELECT SUM(COSTO)
			FROM RESERVA
			GROUP BY YEAR(FECHA)
			HAVING YEAR(FECHA) = @AÑO)
PRINT 'EL MONTO NO SUPERA LA BASE ANUAL '
ELSE
PRINT 'EL MONTO CUMPLE CON LA BASE ANUAL'
GO