--Estamos utilizando print para poder imprimir las variables
--declaradas en el declare
PRINT '*** RESUMEN DE NOTAS ***'
PRINT ''

--LLAMADO LAS VARIABLES

PRINT 'LA NOTA 1: '+CAST(@N1 AS CHAR(2))
PRINT 'LA NOTA 2: '+CAST(@N1 AS CHAR(2))
PRINT 'LA NOTA 3: '+CAST(@N1 AS CHAR(2))
PRINT 'LA NOTA 4: '+CAST(@N1 AS CHAR(2))
PRINT ''
PRINT'EL PROMEDIO ES: '+CAST(@PROMEDIO AS CHAR(5))

--CASO 2

DECLARE @N1 INT=12,@N2 INT=20, @N3 INT=15, @N4 INT=18, @PROMEDIO DECIMAL(5,2)

SET @PROMEDIO=(@N1+@N2+@N3+@N4)/4.

PRINT '*** RESUMEN DE DATOS ***'
PRINT ''
PRINT 'LA NOTA 1: '+ CAST(@N1 AS CHAR(2))
PRINT 'LA NOTA 2: '+ CAST(@N2 AS CHAR(2))
PRINT 'LA NOTA 3: '+ CAST(@N3 AS CHAR(2))
PRINT 'LA NOTA 4: '+ CAST(@N4 AS CHAR(2))
PRINT ''
PRINT 'EL PROMEDIO ES: '+CAST(@PROMEDIIO AS CHAR(5))
GO


DECLARE @PAIS VARCHAR(40)='PERU'

SELECT PAS.*
FROM PASAJERO PAS
WHERE PAS.IDPAIS=(SELECT IDPAIS
					FROM PAIS
					WHERE PAIS.PAIS=@PAIS)
GO
--CASO DESARROLLADO
--1.
DECLARE @PASAJE VARCHAR(40) = 'MARISOL DIAZ ZAMBRANO'
DECLARE @PAIS VARCHAR(40)
--2
SELECT @PAIS = PAI.PAIS
FROM PASAJERO PAS
JOIN PAIS PAI ON PAS.IDPAIS=PAI.IDPAIS
WHERE PAS.NOMBRES=@PASAJE
GO