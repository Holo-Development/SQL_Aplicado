SELECT CONCAT(nombreEmpleado, apellidoPaterno, apellidoMaterno) AS "Nombre del Empleado", CE.nombre AS "Cargo", nombreSucursal as "Sucursal", 
FROM Empleado E JOIN Sucursal 
ON (E.idSucursal = S.idSucursal)
JOIN Categoria_Empleado CE
ON (E.idCategoriaEmpleado = CE.idCategoriaEmpleado)
JOIN Guia_De_Despacho GDE 
ON (GDE.runEmpleado = E.runEmpleado)
JOIN Despacho D
ON (D.idGuiaDespacho = GDE.idGuiaDespacho)
JOIN Detalle_Guia_Despacho DGP 
ON (DGP.id_GuiaDespacho = D.idGuiaDespacho)