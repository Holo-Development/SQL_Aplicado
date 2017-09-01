CREATE TABLE CATEGORIA_CLIENTE(
idCategoriaCliente int not null identity(1,1) primary key,
nombreCategoria varchar(50) not null
);

CREATE TABLE ENCARGADO_COMPRA(
idEncargado int not null identity(1,1) primary key,
runEncargado varchar(15) not null,
nombreEncargado varchar(50) not null,
correo varchar(50) not null,
celular varchar(50) not null
);

CREATE TABLE CLIENTE(
idCliente int not null identity(1,1) primary key,
rutCliente varchar(15) not null,
nombreCliente varchar(50) not null,
direccion varchar(50) not null,
telefono varchar(50),
correo varchar(50) not null,
celular varchar(50) not null,
esCliente char not null,
idEncargado int not null,
idCategoriaCliente int not null,
constraint FK_idEncargado foreign key(idEncargado) references ENCARGADO_COMPRA(idEncargado),
constraint FK_idCategoriaCliente foreign key(idCategoriaCliente) references CATEGORIA_CLIENTE(idCategoriaCliente)
);

CREATE TABLE ENCARGADO_VENTA(
idEncargado int not null identity(1,1) primary key,
runEncargado varchar(15) not null,
nombreEncargado varchar(50) not null,
correo varchar(50) not null,
celular varchar(20) not null
);

CREATE TABLE SUCURSAL
(
	idSucursal int not null primary key identity(1,1),
	nombreSucursal varchar(10) not null,
	direccion varchar(20) not null,
	telefono varchar(20) not null,
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
	constraint fk_sucursal foreign key(idSucursal) references ENCARGADO_COMPRA(idEncargado),
	constraint fk_encargadoCompra foreign key(encargadoCompraId) references ENCARGADO_COMPRA(idEncargado)
)

CREATE TABLE DETALLE_PEDIDO(
cantidad int not null,
detalle int not null,
precioUnitario int not null,
iva int not null,
total int not null,
idPedido int not null,
constraint fk_idPedido foreign key(idPedido) references Pedido(idPedido),
);

CREATE TABLE PROVEEDOR(
idProveedor int not null primary key identity(1,1),
runProveedor varchar(15) not null,
nombreProveedor varchar(50) not null,
direccion varchar(50) not null,
telefono varchar(15),
correo varchar(50) not null,
celular varchar(15) not null,
esCliente char(1) not null
);


CREATE TABLE CATEGORIA_PRODUCTO
(
	id_CategoriaProducto int not null primary key identity(1,1),
	nombreCategoriaProducto varchar(50) not null,
	disponible char(1) not null
)

CREATE TABLE PRODUCTO(
idProducto int not null primary key identity(1,1),
nombreProducto varchar(50) not null,
precioNetoProducto int not null,
ivaProducto int not null,
precioProducto int not null,
disponibilidad char(1) not null,
id_CategoriaProducto int not null,
idProveedor int not null,
idEncargado int not null,
constraint fk_id_CategoriaProducto foreign key(id_CategoriaProducto) references CATEGORIA_PRODUCTO(id_CategoriaProducto),
constraint fk_idProveedor foreign key(idProveedor) references PROVEEDOR(idProveedor),
constraint fk_idEncargadoVenta foreign key(idEncargado) references ENCARGADO_VENTA(idEncargado)
);

CREATE TABLE CATEGORIA_EMPLEADO(
idCategoriaEmpleado int not null primary key identity(1,1),
nombre varchar(50),
descripcion varchar(200)
);

CREATE TABLE EMPLEADO
(
	runEmpleado varchar(15) not null primary key,
	nombreEmpleado varchar(50) not null,
	apellidoPaterno varchar(25) not null,
	apellidoMaterno varchar(25) not null,
	genero varchar(1) not null,
	nacionalidad varchar(30) not null,
	fechaContrato date not null,
	sueldo int not null,
	fechaNacimiento date not null,
	esEmpleado char(1) not null,
	idCategoriaEmpleado int not null,
	idSucursal int not null,
	constraint fk_categoria foreign key(idCategoriaEmpleado) references CATEGORIA_EMPLEADO(idCategoriaEmpleado),
	constraint fk_sucursal_empleado foreign key(idSucursal) references SUCURSAL(idSucursal)
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
	constraint fk_empleado foreign key(runEmpleado) references EMPLEADO(runEmpleado)
)

CREATE TABLE DETALLE_GUIA_DESPACHO
(
		Detalle_Guia_Despacho_ID int not null primary key identity(1,1),
		cantidad int not null,
		detalle varchar(20) not null,
		total int not null,
		nombreRecepcion varchar(50) not null,
		rutRecepcion varchar(15) not null,
		fechaDeRecepcion date not null,
		id_GuiaDespacho int not null,
		constraint fk_guiaDespacho foreign key(id_GuiaDespacho) references GUIA_DE_DESPACHO(idGuiaDespacho)
)

CREATE TABLE DESPACHO
(
	idDespacho int not null primary key identity(1,1),
	direccionOrigen varchar(50) not null,
	direccionDestino varchar(50) not null,
	fechaSalida date not null,
	fechaLlegada date not null,
	idGuiaDespacho int not null,
	constraint fk_guiaDespachoDespacho foreign key(idGuiaDespacho) references GUIA_DE_DESPACHO(idGuiaDespacho)
)

CREATE TABLE FACTURA(
idFactura int not null identity(1,1) primary key,
rutFactura varchar(15) not null,
fechaEmision date not null,
fechaVencimiento date not null,
direccion varchar(50) not null,
ciudad varchar(50) not null,
comuna varchar(50) not null,
runEmpleado varchar(15) not null,
constraint FK_rumEmpleado foreign key(runEmpleado) references EMPLEADO(runEmpleado)
);


CREATE TABLE NOTACREDITO
(
	notaCredito_ID int primary key identity(1,1) not null,
	rut varchar(15) not null,
	nombre varchar(50) not null,
	direccion varchar(50) not null,
	comuna varchar(50) not null,
	telefono varchar(15) not null,
	numeroFactura int not null,
	constraint FK_numeroFactura foreign key(numeroFactura) references FACTURA(idFactura)
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


CREATE TABLE DETALLE_FACTURA(
cantidad int not null,
detalle int not null,
precioUnitario int not null,
total int not null,
idFactura int not null,
constraint FK_FACTURAS foreign key(idFactura) references FACTURA(idFactura)
);












