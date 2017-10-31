/*
Implementa un proc que permita mostrar los registros de la tabla aeropuerto,
donde se visualiza el nombre del pais, defina de manera
cabecera del listado 
*/

--Creando procedimiento
create procedure muestraAeropuerto
as
	select aer.idaero as [codigo],
			aer.nombre as [aeropuerto],
			pai.pais as [pais]
		from aeropuerto aer
		join pais pai on aer.idpais=pais.idpais
go

--ejecutar el procedimiento
exec muestraAeropuerto

go

/*
procedimiento almacenado que permita mostrar los registros de la tabla pasajero
donde se visualice el nombre del distrito por medio de la funcion muestraPais() y la
descripcion del cargo, defina de manera adecuada la cabecera del listado
*/

--paso 1
if OBJECT_ID('muestrapais') is not null
begin
	drop function dbo.muestrapais
end
go
--paso 2

create function muestraPais(@id char(4))
returns varchar(30)
as
begin
	return(select pa.pais
			from pais pa
			where pa.IDPAIS=@id)
end
go

--paso3
create procedure muestraPasajero
as
	select pas.idpasajero as [codigo]
	pas.nombres as [pasajero],
	dbo.muestraPais(pas.idpais) as [pais],
	pas.email
	from pasajero pas
go
--paso 4 probar procedimiento almacenado
exec muestraPasajero
----------------------------------------------------------------------------------------------
--actividad crear un procedimiento almacenado que muestre el listado de los paises y su total de pasajero
--recuerden utilizar los 4 pasos

	SELECT pai.PAIS AS [PAIS], count(pas.IDPASAJERO) AS [Pasajero]
	FROM PAIS pai JOIN PASAJERO pas ON pai.IDPAIS = pas.IDPAIS
	GROUP BY PAIS


if OBJECT_ID('retornaPaises') is not null
begin
	drop function dbo.retornaPaises
end
go

if OBJECT_ID('retornaPasajeros') is not null
begin
	drop function dbo.retornaPasajeros
end
go

if OBJECT_ID('procedimientoFinal') is not null
begin
	drop function dbo.procedimientoFinal
end
go

CREATE FUNCTION retornaPaises()
RETURNS VARCHAR(30)
AS
BEGIN
	RETURN(SELECT PAIS.PAIS
	FROM PAIS)
END

GO

CREATE FUNCTION retornaPasajeros()
RETURNS VARCHAR(30)
AS
BEGIN
	RETURN(SELECT COUNT(PASAJERO.IDPASAJERO)
			FROM PASAJERO)
END

GO

CREATE PROCEDURE procedimientoFinal
AS
	SELECT DBO.retornaPaises() AS [PAISES], DBO.retornaPasajeros() AS [PASAJEROS]
GO

EXEC dbo.procedimientoFinal