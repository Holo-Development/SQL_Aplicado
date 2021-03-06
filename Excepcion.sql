----------------------------------------------------------
--HOY VAMOS A TRABAJAR CON CONTROL DE ERRORES :O
--LOS ERRORES EN EL CODIGO DE TRANSACT_SQL SE PUEDEN PROCESAR
--MEDIANDIANTE UNA CONSTRUCCION TRY ... CATCH SIMILAR A LAS
--CARACTERISTICAS DE CONTROL DE EXCEPCIONES DE LOS LENGUAJE
--MICROSOFT VISUAL C++ Y MICROSOFT VISUAL C#
----------------------------------------------------------
BEGIN TRY
	SELECT 1/0
END TRY
-- SE UTILIZA EL BLOQUE CATCH CONTROLA LA EXCEPCION, EL CONTROL
-- SE TRANSFIERE A LA PRIMERA INSTRUCCION DE UN PROCEDIMIENTO ALMACENADO O
-- UN TRIGGERS
BEGIN CATCH
	SELECT
		ERROR_NUMBER()AS ERROR_NUMBER,
		ERROR_SEVERITY() AS ERROR_SEVERITY ,
		ERROR_STATE()AS ERROR_STATE,
		ERROR_PROCEDURE() AS ERROR_PROCEDURE,
		ERROR_LINE() AS ERROR_LINE,
		ERROR_MESSAGE() AS ERROR_MESSAGE
END CATCH
GO
-- UN BLOQUE CATCH SIEMPRE DEBE ESTAR SEGUIDO O UNIDO A UN BLOQUE DE TRY
-- LAS CONSTRUCCIONES DE TRY... CATCH PUEDE ESTAR ANIDADAS
-- PARA CONTROLAR UN ERROR QUE SE PRODUCE EN UN BLOQUE CATCH DETERMINADO , ESCRIBA UN BLOQUE TRY
-- LOS ERRORES CON UNA GRAVEDAD DE 10 O INFERIOR SE CONSIDERA ADVERTENCIAS O MENSAJES INFORMATICOS,
-- LOS BLOQUES TRY.. CATCH NO LO CONTROLAN
--------------------------------------------------------------------------------------------------------
-- LAS FUNCIONES DE ERROR PREDETERMINADOS POR MSS SON:
-- ERROR_NUMBER: DEVUELVE UN NUMERO DE ERROR :(
-- ERROR_MESSAGE: DEVUELVE UN TEXTO COMPLETO DEL MENSAJE DE ERROR, EL TEXTO INCLUYE LOS VALORES
				--SIMULADOS PARA LOS PARAMETROS SUSTITUIBLES, COMO LONGITUDES, ETC
-- ERROR_SEVERITY: DEVUELVE LA GRAVEDAD DEL ERROR
-- ERROR_STATE: DEVUELVE EL NUMERO DE ESTADO DEL ERROR
-- ERROR_LINE: DEVUELVE EL NUMERO DE LINEA DENTRO DE LA RUTINA EN QUE SE PRODUJO EL ERROR
-- ERROR_PROCEDURE: DEVUELVE EL NOMBRE DEL PROCEDIMIENTO ALMACENADO DESENCADENADOR EN QUE SE PRODUJO EL ERROR
----------------------------------------------------------------------------------------------------------
-- hoy en ava link del google drive (con los permisos asignados) 19:00
-- ma�ana subo la primera nota de ssa (sql server aplicado)