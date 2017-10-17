---Procedimiento Almacenado
/* Implementa un procedimiento almacenado que permita mostrar los registros de la Tabla AEROPUERTO
donde se visualize el nombre del pais, defina de manera adecuada la cabecera del listado*/


create procedure muestraaeropuerto
as
	select aer.idaero as [codigo],
		aer.nombre as [aeropuerto]
		pai.pais as [pais]
	from aeropuerto aer
	join pais pai on aer.idpais = pai.idpais

go

exec muestraaeropuerto

/* 2. Procedimiento almacenado que permita mostrar los registros de la tabla PASAJERO
donde se visualiza el nombre del distrito por medio de la funcion muestra pais MUESTRAPAIS()
y la descripcion del cargo, define de manera adecuada la cabecera del listado.*/

if OBJECT_ID('MUESTRAPAIS') is not null
begin
	drop function dbo.pasajerosxpais
end
go

--2.

create function MUESTRAPAIS(@ID char(4))
returns varchar(30)
as
begin 
	return (select pa.pais
			from pais pa
			where pa.idpais=@ID)
end
go

--3.
create procedure MUESTREAPASAJERO
as
	select pas.idpasajero as [codigo],
			pas.nombre as [pasajero],
			dbo.MUESTRAPAIS(pas.idpais) as [pais]
			pas.email
	from pasajero pas
go

--probar
exec MUESTREAPASAJERO

--Procedimiento almacenado que muestre el listado
--de los paises y si total de pasajeros.
--1.
if OBJECT_ID('PASAJEROXPAIS') is not null
begin
	drop function dbo.PASAJEROSXPAIS
end
go


--2
create procedure pasajeroxpais
as
	select pai.pais as[pais], count(*) as [total]
		from pasajero pas
		join pais pai on pas.idpais=pai.idpais
		group by pai.pais

go

--probar
exec pasajeroxpais