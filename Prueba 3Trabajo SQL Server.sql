--1
-- CREAR DIRECTORIO BD_COMERCIAL2A
CREATE DATABASE COMERCIAL2ABD
ON PRIMARY
(
	NAME='COMERICAL2A_PRI',
	FILENAME='C:\BD_COMERCIAL2A\COMERCIAL2ABD.MDF',
	SIZE=10MB,
	MAXSIZE=60MB,
	FILEGROWTH =5%
)

LOG ON
(
	NAME='COMERCIAL2A_LOG',
	FILENAME='C:\BD_COMERCIAL2A\COMERCIAL2ABD.LDF',
	SIZE=9MB,
	MAXSIZE=20MB,
	FILEGROWTH=20%
)

SELECT NAME, DBID, CRDATE, FILENAME 
FROM SYS.sysdatabases 
WHERE NAME LIKE 'COMERCIAL2ABD'
GO
--2
CREATE PROCEDURE EMPLEADOS_SIN_FACTURA_EMITIDA
AS
SELECT E.runEmpleado, nombreEmpleado, COUNT(F.runEmpleado) AS 'FACTURAS EMITIDAS'
FROM FACTURA F 
RIGHT JOIN EMPLEADO E
ON(F.RUNEMPLEADO = E.RUNEMPLEADO)
GROUP BY E.runEmpleado, nombreEmpleado
HAVING COUNT(F.runEmpleado) LIKE 0
ORDER BY nombreEmpleado
GO

EXEC EMPLEADOS_SIN_FACTURA_EMITIDA
GO
--3
CREATE PROCEDURE PROVEEDOR_CON_PRODUCTOS
AS
SELECT PR.idProveedor, nombreProveedor , nombreEncargado , runEncargado, esCliente , COUNT(P.idProveedor) AS 'CANTIDAD DE PRODUCTOS'
FROM PRODUCTO P
RIGHT JOIN PROVEEDOR PR
ON(P.idProveedor = PR.idProveedor)
LEFT JOIN ENCARGADO_VENTA EV
ON(P.idEncargado = EV.idEncargado)
GROUP BY PR.idProveedor, nombreProveedor, nombreEncargado , runEncargado, esCliente
HAVING COUNT(P.idProveedor) > 0
ORDER BY COUNT(P.idProveedor) ASC
GO

EXEC PROVEEDOR_CON_PRODUCTOS
GO

--4
CREATE PROCEDURE PEDIDOS_ENCARGADO_COMPRA
@nombre VARCHAR(30) = NULL
AS
IF EXISTS(SELECT * FROM ENCARGADO_COMPRA WHERE nombreEncargado LIKE @nombre)
SELECT runEncargado, nombreEncargado , correo, P.idpedido, nombrePedido, fecha,total
FROM ENCARGADO_COMPRA EC
JOIN PEDIDO P
ON (P.encargadoCompraId = EC.idEncargado)
JOIN DETALLE_PEDIDO DP
ON (DP.idPedido = P.idPedido)
WHERE nombreEncargado LIKE @nombre
ELSE
PRINT 'NO EXISTE ENCARGADO COMPRA O NO REGISTRA PEDIDO'
GO

EXEC PEDIDOS_ENCARGADO_COMPRA 'Rafaella Candia'
GO

--5
CREATE PROCEDURE GUIA_DESPACHO_EMITIDA_X_EMPLEADO
AS
SELECT  nombreEmpleado + ' ' + apellidoPaterno AS 'NOMBRE_EMPLEADO', 
fechaContrato, esEmpleado,nombre,MAX(fechaDeRecepcion) AS FECHA ,
COUNT(G.runEmpleado) AS 'TOTAL GUIAS EMITIDAS'
FROM EMPLEADO E
JOIN GUIA_DE_DESPACHO G
ON(E.runEmpleado = G.runEmpleado)
JOIN DETALLE_GUIA_DESPACHO DGD
ON(DGD.id_GuiaDespacho = G.idGuiaDespacho)
GROUP BY  nombreEmpleado ,apellidoPaterno, fechaContrato, esEmpleado, id_GuiaDespacho,nombre
GO

EXEC GUIA_DESPACHO_EMITIDA_X_EMPLEADO
GO

--6
CREATE PROCEDURE REGISTRAR_EMPLEADO
@runEmpleado VARCHAR(20) = NULL,
@nombre VARCHAR(20) = NULL,
@apellidoPaterno VARCHAR(20) = NULL,
@apellidoMaterno VARCHAR(20) = NULL,
@genero CHAR(1) = NULL,
@nacionalidad VARCHAR(15) = NULL,
@fechaContrato VARCHAR(20) = NULL,
@suelo INT = 0,
@fechaNacimiento VARCHAR(15) = NULL,
@idSucursal INT = 1,
@cargoEmpleado VARCHAR(20) = NULL,
@idCategoriaEmpleado INT = 0
AS
SET @idCategoriaEmpleado = (SELECT idCategoriaEmpleado FROM CATEGORIA_EMPLEADO WHERE nombre LIKE @cargoEmpleado)
IF EXISTS(SELECT * FROM CATEGORIA_EMPLEADO WHERE nombre LIKE @cargoEmpleado)
INSERT INTO EMPLEADO(runEmpleado,nombreEmpleado,apellidoPaterno,apellidoMaterno,genero,nacionalidad,fechaContrato,sueldo,fechaNacimiento,esEmpleado,idCategoriaEmpleado,idSucursal)
VALUES(@runEmpleado,@nombre,@apellidoPaterno,@apellidoMaterno,@genero,@nacionalidad,@fechaContrato,@suelo,@fechaNacimiento,1, @idCategoriaEmpleado,@idSucursal)
ELSE
PRINT 'LA CATEGORIA DE EMPLEADO NO EXISTE'
IF(@idCategoriaEmpleado>0)
PRINT 'EMPLEADO REGISTRADO'
GO

EXEC REGISTRAR_EMPLEADO '10-10','Jorge','Candia','Matamoros','M','Chileno','2017-11-23',300000,'1995-11-22',1,'Gerente General'
GO

--7

CREATE PROCEDURE REGISTRAR_CATEGORIA_EMPLEADO
@nombre VARCHAR(20) = NULL,
@descripcion VARCHAR(100) = NULL
AS
IF EXISTS(SELECT * FROM CATEGORIA_EMPLEADO WHERE nombre LIKE @nombre)
PRINT 'CATEGORIA EMPLEADO YA REGISTRADO'
ELSE
INSERT INTO CATEGORIA_EMPLEADO(nombre,descripcion)
VALUES(@nombre,@descripcion)
GO 

EXEC REGISTRAR_CATEGORIA_EMPLEADO 'HOLOMAN', 'JEFE SUPREMO'
GO

SELECT * FROM CATEGORIA_EMPLEADO