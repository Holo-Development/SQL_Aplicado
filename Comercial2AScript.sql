CREATE TABLE NOTACREDITO
(
	notaCredito_ID int primary key identity(1,1) not null,
	rut varchar(15) not null,
	nombre varchar(50) not null,
	direccion varchar(50) not null,
	comuna varchar(50) not null,
	telefono varchar(15) not null,
	numeroFactura int not null,
	constraint FK_numeroFactura foreign key(numeroFactura)
	references FACTURA(factura_id)
)

CREATE TABLE DETALLE_NOTA_CREDITO
(
	cantidad int not null,
	detalle int not null,
	precioUnitario int not null,
	total int not null,
	subTotal int not null,
	iva int not null,
	total_2 int,
	nombreRecepcion varchar(50),
	rutRecepcion varchar(15),
	recintoDondeRecibe varchar(50),
	fechaDeRecepcion date,
	id_notaCredito int not null,
	constraint fk_notaCredito foreign key(id_notaCredito)
	references NOTACREDITO(notaCredito_ID)
)

CREATE TABLE SUCURSAL
(
	sucursal_id int not null,
	idSucursal int not null,
	nombreSucursal varchar(10) not null,
	direccion varchar(20) not null,
	telefono int not null,
	correo varchar(50) not null,
	idEncargado int not null,
	constraint fk_encargado foreign key(idEncargado)
	references ENCARGADO_VENTA(idEncargado)
)

CREATE TABLE PEDIDO
(
	idPedido int primary key identity(1,1) not null,
	runPedido varchar(15) not null,
	nombrePedido varchar(50) not null,
	direccion varchar(50) not null,
	fecha date not null,
	idSucursal int not null,
	encargadoCompraId int not null,
	constraint fk_sucursal foreign key(idSucursal)
	references ENCARGADO_COMPRA(idEncargado),
	constraint fk_encargadoCompra foreign key(encargadoCompraId) references ENCARGADO_COMPRA(idEncargado)
)

CREATE TABLE CATEGORIA_PRODUCTO
(
	id_CategoriaProducto int not null primary key identity(1,1),
	nombreCategoriaProducto varchar(50) not null,
	disponible char(1) not null
)

CREATE TABLE EMPLEADO
(
	runEmpleado varchar(15) not null,
	nombreEmpleado varchar(50) not null,
	apellidoPaterno varchar(25) not null,
	apellidoMaterno varchar(25) not null,
	genero varchar(1) not null,
	nacionalidad varchar(30) not null,
	fechaContrato date not null,
	sueldo number(10,2) not null,
	fechaNacimiento date not null,
	esEmpleado char(1) not null,
	idCategoriaEmpleado int not null,
	idSucursal int not null,
	constraint fk_categoria foreign key(idCategoriaEmpleado) references CATEGORIA_EMPLEADO(idCategoriaEmpleado),
	constraint fk_sucursal foreign key(idSucursal) references SUCURSAL(idSucursal)
)


CREATE TABLE GUIA_DE_DESPACHO
(
	idGuiaDespacho int not null primary key identity(1,1),
	rut varchar(15) not null,
	fecha date not null,
	nombre varchar(50) not null,
	telefono varchar(15) not null,
	direccion varchar(50) not null,
	comuna varchar(50) not null,
	ciudad varchar(50) not null,
	runEmpleado varchar(15) not null,
	constraint fk_empleado foreign key(runEmpleado)
	references EMPLEADO(runEmpleado)
)

CREATE TABLE DETALLE_GUIA_DESPACHO
(
		Detalle_Guia_Despacho_ID int not null primary key identity(1,1),
		cantidad int not null,
		detalle int not null,
		total int not null,
		nombreRecepcion varchar(50) not null,
		rutRecepcion varchar(15) not null,

		fechaDeRecepcion date not null,
		id_GuiaDespacho int not null,
		constraint fk_guiaDespacho foreign key(id_GuiaDespacho)
		references GUIA_DE_DESPACHO(notaCredito_ID)
)

CREATE TABLE DESPACHO
(
	idDespacho int not null primary key identity(1,1),
	direccionOrigen varchar(50) not null,
	direccionDestino varchar(50) not null,
	fechaSalida date not null,
	fechaLlegada date not null,
	idGuiaDespacho int not null,
	constraint fk_guiaDespacho foreign key(idGuiaDespacho) references GUIA_DE_DESPACHO(idGuiaDespacho)
)