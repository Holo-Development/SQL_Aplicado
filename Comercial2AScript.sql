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

CREATE TABLE CATEGORIA_PRODUCTO
(
	id_CategoriaProducto int not null primary key identity(1,1),
	nombreCategoriaProducto varchar(50) not null,
	disponible char(1) not null
)