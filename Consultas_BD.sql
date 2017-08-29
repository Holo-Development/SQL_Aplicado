
--EJERCIIO 1 Y 3
SELECT CONCAT(nombreEmpleado,' ',apellidoPaterno,' ' ,apellidoMaterno) as "Nombre Empleado",
CE.nombre as "Cargo",
nombreSucursal as "Nombre Sucursal",
CONVERT(VARCHAR(10),fechaDeRecepcion,120) AS "Fecha Recepcion"
FROM EMPLEADO E JOIN SUCURSAL S
ON(E.idSucursal = S.idSucursal)
JOIN CATEGORIA_EMPLEADO CE
ON(E.idCategoriaEmpleado = CE.idCategoriaEmpleado)
JOIN GUIA_DE_DESPACHO GDE
ON(GDE.runEmpleado = E.runEmpleado)
JOIN DESPACHO D
ON(D.idGuiaDespacho = GDE.idGuiaDespacho)
JOIN DETALLE_GUIA_DESPACHO DGP
ON(DGP.id_GuiaDespacho = D.idGuiaDespacho);

--EJERCICIO 2
SELECT UPPER(direccion) AS "Direccion Mayuscula",
LOWER(comuna) AS "Comuna Minuscula",
COUNT(F.idFactura) AS "Cantidad Factura" ,
SUM(total) AS "Total de Factura" ,
MIN(total) AS "Minimo Total Factura" ,
MAX(total) AS "Maximo Total Factura" ,
AVG(total) AS "Promedio Total Factura",
SUBSTRING(comuna,1,1) AS "Metodo substring"
FROM FACTURA  F JOIN DETALLE_FACTURA DF
ON(F.idFactura = DF.idFactura)
GROUP BY direccion, comuna;


--EJERCICIO 4

SELECT 
FROM FACTURA F JOIN DETALLE_FACTURA DF
ON (F.idFactura = DF.idFactura)
JOIN EMPLEADO E
ON(F.runEmpleado = E.runEmpleado)
JOIN CATEGORIA_EMPLEADO CE
ON(CE.runEmpleado =E.runEmpleado)
WHERE F.idFactura in (SELECT idFactura FROM FACTURA WHERE TOTAL >= 10000);

SELECT * FROM DETALLE_FACTURA;