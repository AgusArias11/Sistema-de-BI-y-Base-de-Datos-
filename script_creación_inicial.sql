
-- SCRIPT DE CREACION INICIAL - MODELO TRANSACCIONAL
-- Grupo: GROUP_BY_GAMBETTA
-- Base de datos: GD1C2026

USE [GD1C2026]
GO


-- SECCION 1: CREACION DEL ESQUEMA

CREATE SCHEMA GROUP_BY_GAMBETTA
GO

-- SECCION 2: CREACION DE TABLAS


-- Tabla: Provincia

CREATE TABLE GROUP_BY_GAMBETTA.Provincia (
    id_provincia BIGINT IDENTITY(1,1) PRIMARY KEY,
    nombre_provincia NVARCHAR(255) NOT NULL
)
GO

-- Tabla: Localidad

CREATE TABLE GROUP_BY_GAMBETTA.Localidad (
    id_localidad BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_provincia BIGINT NOT NULL,
    nombre_localidad NVARCHAR(255) NOT NULL,
    FOREIGN KEY (id_provincia) REFERENCES GROUP_BY_GAMBETTA.Provincia(id_provincia)
)
GO

-- Tabla: Pais

CREATE TABLE GROUP_BY_GAMBETTA.Pais (
    id_pais BIGINT IDENTITY(1,1) PRIMARY KEY,
    nombre_pais NVARCHAR(255) NOT NULL
)
GO

-- Tabla: Ciudad

CREATE TABLE GROUP_BY_GAMBETTA.Ciudad (
    id_ciudad BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_pais BIGINT NOT NULL,
    nombre_ciudad NVARCHAR(255) NOT NULL,
    FOREIGN KEY (id_pais) REFERENCES GROUP_BY_GAMBETTA.Pais(id_pais)
)
GO

-- Tabla: Alianza


CREATE TABLE GROUP_BY_GAMBETTA.Alianza (
    id_alianza BIGINT IDENTITY(1,1) PRIMARY KEY,
    nombre_alianza NVARCHAR(255) NOT NULL
)
GO

-- Tabla: Aerolinea

CREATE TABLE GROUP_BY_GAMBETTA.Aerolinea (
    codigo NVARCHAR(255) PRIMARY KEY,
    nombre NVARCHAR(255) NULL,
    id_pais BIGINT NULL,
    id_alianza BIGINT NULL,
    FOREIGN KEY (id_pais) REFERENCES GROUP_BY_GAMBETTA.Pais(id_pais),
    FOREIGN KEY (id_alianza) REFERENCES GROUP_BY_GAMBETTA.Alianza(id_alianza)
)
GO

-- Tabla: Aeropuerto


CREATE TABLE GROUP_BY_GAMBETTA.Aeropuerto (
    codigo_aeropuerto NVARCHAR(10) PRIMARY KEY,
    descripcion NVARCHAR(255) NULL,
    id_ciudad BIGINT NOT NULL,
    FOREIGN KEY (id_ciudad) REFERENCES GROUP_BY_GAMBETTA.Ciudad(id_ciudad)
)
GO
-- Tabla: Vuelo

CREATE TABLE GROUP_BY_GAMBETTA.Vuelo (
    cod_vuelo BIGINT IDENTITY(1,1) PRIMARY KEY,
    cod_aeropuerto_salida NVARCHAR(10) NOT NULL,
    cod_aeropuerto_llegada NVARCHAR(10) NOT NULL,
    cod_aerolinea NVARCHAR(255) NOT NULL,
    fecha_salida DATE NULL,
    fecha_llegada DATE NULL,
    horario_salida NVARCHAR(50) NULL,
    horario_llegada NVARCHAR(50) NULL,
    duracion INT NULL,
    precio DECIMAL(18,2) NULL,
    incluye_carry BIT NULL,
    incluye_valija BIT NULL,
    FOREIGN KEY (cod_aeropuerto_salida) REFERENCES GROUP_BY_GAMBETTA.Aeropuerto(codigo_aeropuerto),
    FOREIGN KEY (cod_aeropuerto_llegada) REFERENCES GROUP_BY_GAMBETTA.Aeropuerto(codigo_aeropuerto),
    FOREIGN KEY (cod_aerolinea) REFERENCES GROUP_BY_GAMBETTA.Aerolinea(codigo)
)
GO

-- Tabla: Hospedaje

CREATE TABLE GROUP_BY_GAMBETTA.Hospedaje (
    cod_hospedaje BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_ciudad BIGINT NOT NULL,
    nombre NVARCHAR(255) NULL,
    direccion NVARCHAR(255) NULL,
    incluye_desayuno BIT NULL,
    checkin NVARCHAR(50) NULL,
    checkout NVARCHAR(50) NULL,
    FOREIGN KEY (id_ciudad) REFERENCES GROUP_BY_GAMBETTA.Ciudad(id_ciudad)
)
GO

-- Tabla: Tipo_Habitacion

CREATE TABLE GROUP_BY_GAMBETTA.Tipo_Habitacion (
    num_habitacion BIGINT IDENTITY(1,1) PRIMARY KEY,
    cod_hospedaje BIGINT NOT NULL,
    nombre_habitacion NVARCHAR(255) NOT NULL,
    descripcion NVARCHAR(MAX) NULL,
    precioNoche DECIMAL(18,2) NULL,
    FOREIGN KEY (cod_hospedaje) REFERENCES GROUP_BY_GAMBETTA.Hospedaje(cod_hospedaje)
)
GO

-- Tabla: Proveedor

CREATE TABLE GROUP_BY_GAMBETTA.Proveedor (
    id_proveedor BIGINT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(255) NULL,
    mail NVARCHAR(255) NULL,
    telefono NVARCHAR(255) NULL
)
GO


-- Tabla: Excursion

CREATE TABLE GROUP_BY_GAMBETTA.Excursion (
    cod_excursion BIGINT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(255) NULL,
    descripcion NVARCHAR(MAX) NULL,
    horario NVARCHAR(50) NULL,
    duracion INT NULL,
    precio DECIMAL(18,2) NULL,
    id_proveedor BIGINT NULL,
    FOREIGN KEY (id_proveedor) REFERENCES GROUP_BY_GAMBETTA.Proveedor(id_proveedor)
)
GO

-- Tabla: Agencia

CREATE TABLE GROUP_BY_GAMBETTA.Agencia (
    nro_agencia BIGINT PRIMARY KEY,
    direccion NVARCHAR(255) NULL,
    telefono NVARCHAR(255) NULL,
    mail NVARCHAR(255) NULL,
    id_localidad BIGINT NULL,
    FOREIGN KEY (id_localidad) REFERENCES GROUP_BY_GAMBETTA.Localidad(id_localidad)
)
GO

-- Tabla: Agente

CREATE TABLE GROUP_BY_GAMBETTA.Agente (
    agente_legajo BIGINT PRIMARY KEY,
    nro_agencia BIGINT NOT NULL,
    nombre NVARCHAR(255) NULL,
    apellido NVARCHAR(255) NULL,
    dni NVARCHAR(255) NULL,
    fecha_Nacimiento DATE NULL,
    Telefono NVARCHAR(255) NULL,
    mail NVARCHAR(255) NULL,
    direccion NVARCHAR(255) NULL,
    id_localidad BIGINT NULL,
    FOREIGN KEY (nro_agencia) REFERENCES GROUP_BY_GAMBETTA.Agencia(nro_agencia),
    FOREIGN KEY (id_localidad) REFERENCES GROUP_BY_GAMBETTA.Localidad(id_localidad)
)
GO

-- Tabla: Cliente

CREATE TABLE GROUP_BY_GAMBETTA.Cliente (
    nro_cliente BIGINT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(255) NULL,
    apellido NVARCHAR(255) NULL,
    dni NVARCHAR(255) NULL,
    fecha_Nacimiento DATE NULL,
    Telefono NVARCHAR(255) NULL,
    mail NVARCHAR(255) NULL,
    direccion NVARCHAR(255) NULL,
    id_localidad BIGINT NULL,
    FOREIGN KEY (id_localidad) REFERENCES GROUP_BY_GAMBETTA.Localidad(id_localidad)
)
GO

-- Tabla: Medio_Pago


CREATE TABLE GROUP_BY_GAMBETTA.Medio_Pago (
    id_medio_pago BIGINT IDENTITY(1,1) PRIMARY KEY,
    nombre_medio_pago NVARCHAR(255) NOT NULL
)
GO

-- Tabla: Canal_Venta

CREATE TABLE GROUP_BY_GAMBETTA.Canal_Venta (
    id_canal_venta BIGINT IDENTITY(1,1) PRIMARY KEY,
    nombre_canal NVARCHAR(255) NOT NULL
)
GO

-- Tabla: Venta
CREATE TABLE GROUP_BY_GAMBETTA.Venta (
    nro_venta BIGINT NOT NULL,
    agente_legajo BIGINT NOT NULL,
    nro_cliente BIGINT NOT NULL,
    fecha DATE NULL,
    id_canal_venta BIGINT NOT NULL,
    subtotal DECIMAL(18,2) NULL,
    descuento DECIMAL(18,2) NULL,
    importe_total DECIMAL(18,2) NULL,
    id_medio_pago BIGINT NOT NULL,
    FOREIGN KEY (agente_legajo) REFERENCES GROUP_BY_GAMBETTA.Agente(agente_legajo),
    FOREIGN KEY (nro_cliente) REFERENCES GROUP_BY_GAMBETTA.Cliente(nro_cliente),
    FOREIGN KEY (id_canal_venta) REFERENCES GROUP_BY_GAMBETTA.Canal_Venta(id_canal_venta),
    FOREIGN KEY (id_medio_pago) REFERENCES GROUP_BY_GAMBETTA.Medio_Pago(id_medio_pago),
    PRIMARY KEY (nro_venta,nro_cliente)
)
GO

-- Tabla: Producto

CREATE TABLE GROUP_BY_GAMBETTA.Producto (
    cod_reserva NVARCHAR(255) PRIMARY KEY,
    nro_venta BIGINT NOT NULL,
    nro_cliente BIGINT NOT NULL,
    FOREIGN KEY (nro_venta,nro_cliente) REFERENCES GROUP_BY_GAMBETTA.Venta(nro_venta,nro_cliente)
)
GO

-- Tabla: Venta_Vuelo

CREATE TABLE GROUP_BY_GAMBETTA.Venta_Vuelo (
    cod_reserva NVARCHAR(255) PRIMARY KEY,
    cod_vuelo BIGINT NOT NULL,
    subtotal DECIMAL(18,2) NULL,
    cantidad_pasajes INTEGER NULL,
    precio_unitario DECIMAL(18,2) NULL,
    FOREIGN KEY (cod_reserva) REFERENCES GROUP_BY_GAMBETTA.Producto(cod_reserva),
    FOREIGN KEY (cod_vuelo) REFERENCES GROUP_BY_GAMBETTA.Vuelo(cod_vuelo)
)
GO

-- Tabla: Venta_Hospedaje

CREATE TABLE GROUP_BY_GAMBETTA.Venta_Hospedaje (
    cod_reserva NVARCHAR(255) PRIMARY KEY,
    num_habitacion BIGINT NOT NULL,
    fecha_desde DATE NULL,
    fecha_hasta DATE NULL,
    cantidad INT NULL,
    precio_unitario DECIMAL(18,2) NULL,
    subtotal DECIMAL(18,2) NULL,
    FOREIGN KEY (cod_reserva) REFERENCES GROUP_BY_GAMBETTA.Producto(cod_reserva),
    FOREIGN KEY (num_habitacion) REFERENCES GROUP_BY_GAMBETTA.Tipo_Habitacion(num_habitacion)
)
GO

-- Tabla: Venta_Excursion

CREATE TABLE GROUP_BY_GAMBETTA.Venta_Excursion (
    cod_reserva NVARCHAR(255) PRIMARY KEY,
    cod_excursion BIGINT NOT NULL,
    fecha_reserva DATE NULL,
    cantidad INT NULL,
    precio_unitario DECIMAL(18,2) NULL,
    subtotal DECIMAL(18,2) NULL,
    FOREIGN KEY (cod_reserva) REFERENCES GROUP_BY_GAMBETTA.Producto(cod_reserva),
    FOREIGN KEY (cod_excursion) REFERENCES GROUP_BY_GAMBETTA.Excursion(cod_excursion)
)
GO

-- Tabla: Solicitud

CREATE TABLE GROUP_BY_GAMBETTA.Solicitud (
    nro_solicitud BIGINT PRIMARY KEY,
    nro_cliente BIGINT NOT NULL,
    agente_legajo BIGINT NOT NULL,
    fecha_solicitud DATE NULL,
    fecha_inicio_tentativa DATE NULL,
    fecha_fin_tentativa DATE NULL,
    cant_pax INT NULL,
    observaciones NVARCHAR(MAX) NULL,
    presupuesto_estimado DECIMAL(18,2) NULL,
    FOREIGN KEY (nro_cliente) REFERENCES GROUP_BY_GAMBETTA.Cliente(nro_cliente),
    FOREIGN KEY (agente_legajo) REFERENCES GROUP_BY_GAMBETTA.Agente(agente_legajo)
)
GO

-- Tabla: Detalle_Solicitud


CREATE TABLE GROUP_BY_GAMBETTA.Detalle_Solicitud (
    ciudad NVARCHAR(255) NOT NULL,
    nro_solicitud BIGINT NOT NULL,
    cantidad_dias_aprox INT NOT NULL,
    observaciones NVARCHAR(MAX) NULL,
    PRIMARY KEY (ciudad, nro_solicitud, cantidad_dias_aprox),
    FOREIGN KEY (nro_solicitud) REFERENCES GROUP_BY_GAMBETTA.Solicitud(nro_solicitud)
)
GO

--Tabla: Estado

CREATE TABLE GROUP_BY_GAMBETTA.Estado (
    nro_estado BIGINT IDENTITY(1,1) PRIMARY KEY,
    estado NVARCHAR(255) NULL
)
GO

-- Tabla: Propuesta

CREATE TABLE GROUP_BY_GAMBETTA.Propuesta (
    nro_propuesta BIGINT PRIMARY KEY,
    nro_solicitud BIGINT NOT NULL,
    agente_legajo BIGINT NOT NULL,
    fecha_emision DATE NULL,
    vigencia_hasta DATE NULL,
    fecha_desde DATE NULL,
    fecha_hasta DATE NULL,
    subtotal DECIMAL(18,2) NULL,
    descuento DECIMAL(18,2) NULL,
    importe_total DECIMAL(18,2) NULL,
    nro_estado BIGINT NOT NULL,
    FOREIGN KEY (nro_solicitud) REFERENCES GROUP_BY_GAMBETTA.Solicitud(nro_solicitud),
    FOREIGN KEY (agente_legajo) REFERENCES GROUP_BY_GAMBETTA.Agente(agente_legajo),
    FOREIGN KEY (nro_estado) REFERENCES GROUP_BY_GAMBETTA.Estado(nro_estado)
)
GO


-- Tabla: Propuesta_Vuelo

CREATE TABLE GROUP_BY_GAMBETTA.Propuesta_Vuelo (
    id_detalle_propuesta_vuelo BIGINT IDENTITY(1,1) PRIMARY KEY,
    cod_vuelo BIGINT NOT NULL,
    nro_propuesta BIGINT NOT NULL,
    subtotal DECIMAL(18,2) NULL,
    cantidad_pasajes INTEGER NULL,
    precio_unitario INTEGER NULL,
    FOREIGN KEY (cod_vuelo) REFERENCES GROUP_BY_GAMBETTA.Vuelo(cod_vuelo),
    FOREIGN KEY (nro_propuesta) REFERENCES GROUP_BY_GAMBETTA.Propuesta(nro_propuesta)
)
GO

-- Tabla: Propuesta_Hospedaje

CREATE TABLE GROUP_BY_GAMBETTA.Propuesta_Hospedaje (
    id_detalle_propuesta_hospedaje BIGINT IDENTITY(1,1) PRIMARY KEY,
    nro_propuesta BIGINT NOT NULL,
    num_habitacion BIGINT NOT NULL,
    fecha_desde DATE NULL,
    fecha_hasta DATE NULL,
    cantidad INT NULL,
    precio_unitario DECIMAL(18,2) NULL,
    subtotal DECIMAL(18,2) NULL,
    FOREIGN KEY (nro_propuesta) REFERENCES GROUP_BY_GAMBETTA.Propuesta(nro_propuesta),
    FOREIGN KEY (num_habitacion) REFERENCES GROUP_BY_GAMBETTA.Tipo_Habitacion(num_habitacion)
)
GO

-- Tabla: Venta_Propuesta

CREATE TABLE GROUP_BY_GAMBETTA.Venta_Propuesta (
    nro_venta BIGINT NOT NULL,
    nro_cliente BIGINT NOT NULL,
    nro_propuesta BIGINT NOT NULL,
    PRIMARY KEY (nro_venta, nro_propuesta),
    FOREIGN KEY (nro_venta,nro_cliente) REFERENCES GROUP_BY_GAMBETTA.Venta(nro_venta,nro_cliente),
    FOREIGN KEY (nro_propuesta) REFERENCES GROUP_BY_GAMBETTA.Propuesta(nro_propuesta)
)
GO

-- Tabla: Aspecto

CREATE TABLE GROUP_BY_GAMBETTA.Aspecto (
    cod_aspecto BIGINT IDENTITY(1,1) PRIMARY KEY,
    aspecto NVARCHAR(255) NOT NULL
)
GO

-- Tabla: Encuesta

CREATE TABLE GROUP_BY_GAMBETTA.Encuesta (
    codigo_encuesta BIGINT PRIMARY KEY,
    nro_cliente BIGINT NOT NULL,
    agente_legajo BIGINT NOT NULL,
    fecha_encuesta DATE NULL,
    comentarios NVARCHAR(MAX) NULL,
    FOREIGN KEY (nro_cliente) REFERENCES GROUP_BY_GAMBETTA.Cliente(nro_cliente),
    FOREIGN KEY (agente_legajo) REFERENCES GROUP_BY_GAMBETTA.Agente(agente_legajo)
)
GO

-- Tabla: Detalle_Encuesta

CREATE TABLE GROUP_BY_GAMBETTA.Detalle_Encuesta (
    cod_aspecto BIGINT NOT NULL,
    codigo_encuesta BIGINT NOT NULL,
    puntaje INT NULL CHECK (puntaje BETWEEN 1 AND 5),
    PRIMARY KEY (cod_aspecto, codigo_encuesta),
    FOREIGN KEY (cod_aspecto) REFERENCES GROUP_BY_GAMBETTA.Aspecto(cod_aspecto),
    FOREIGN KEY (codigo_encuesta) REFERENCES GROUP_BY_GAMBETTA.Encuesta(codigo_encuesta)
)
GO

-- SECCION 3: INDICES

CREATE INDEX IX_Localidad_Nombre ON GROUP_BY_GAMBETTA.Localidad(nombre_localidad)
GO
CREATE INDEX IX_Provincia_Nombre ON GROUP_BY_GAMBETTA.Provincia(nombre_provincia)
GO
CREATE INDEX IX_Ciudad_Nombre ON GROUP_BY_GAMBETTA.Ciudad(nombre_ciudad, id_pais)
GO
CREATE INDEX IX_Pais_Nombre ON GROUP_BY_GAMBETTA.Pais(nombre_pais)
GO
CREATE INDEX IX_Cliente_DNI ON GROUP_BY_GAMBETTA.Cliente(dni)
GO
CREATE INDEX IX_Agente_Agencia ON GROUP_BY_GAMBETTA.Agente(nro_agencia)
GO
CREATE INDEX IX_Venta_Cliente ON GROUP_BY_GAMBETTA.Venta(nro_cliente)
GO
CREATE INDEX IX_Venta_Agente ON GROUP_BY_GAMBETTA.Venta(agente_legajo)
GO
CREATE INDEX IX_Venta_Fecha ON GROUP_BY_GAMBETTA.Venta(fecha)
GO
CREATE INDEX IX_Solicitud_Cliente ON GROUP_BY_GAMBETTA.Solicitud(nro_cliente)
GO
CREATE INDEX IX_Solicitud_Agente ON GROUP_BY_GAMBETTA.Solicitud(agente_legajo)
GO
CREATE INDEX IX_Propuesta_Solicitud ON GROUP_BY_GAMBETTA.Propuesta(nro_solicitud)
GO
CREATE INDEX IX_Propuesta_Agente ON GROUP_BY_GAMBETTA.Propuesta(agente_legajo)
GO
CREATE INDEX IX_Vuelo_FechaSalida ON GROUP_BY_GAMBETTA.Vuelo(fecha_salida)
GO
CREATE INDEX IX_Encuesta_Cliente ON GROUP_BY_GAMBETTA.Encuesta(nro_cliente)
GO
CREATE INDEX IX_Encuesta_Agente ON GROUP_BY_GAMBETTA.Encuesta(agente_legajo)
GO
CREATE INDEX IX_TipoHabitacion_Hosp ON GROUP_BY_GAMBETTA.Tipo_Habitacion(cod_hospedaje)
GO

-- SECCION 4: STORED PROCEDURES DE MIGRACION

-- SP: MigrarProvincia

CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarProvincia
AS
BEGIN

    INSERT INTO GROUP_BY_GAMBETTA.Provincia (nombre_provincia)
    SELECT DISTINCT nombre_provincia
    FROM (
        SELECT Agente_Provincia AS nombre_provincia FROM gd_esquema.Maestra WHERE Agente_Provincia IS NOT NULL
        UNION
        SELECT Cliente_Provincia AS nombre_provincia FROM gd_esquema.Maestra WHERE Cliente_Provincia IS NOT NULL
        UNION
        SELECT Agencia_Provincia AS nombre_provincia FROM gd_esquema.Maestra WHERE Agencia_Provincia IS NOT NULL
    ) AS provincias

END
GO

-- SP: MigrarLocalidad

CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarLocalidad
AS
BEGIN

INSERT INTO GROUP_BY_GAMBETTA.Localidad (id_provincia, nombre_localidad)
SELECT p.id_provincia, lp.nombre_localidad
FROM (
            SELECT DISTINCT nombre_localidad, nombre_provincia
            FROM (
                    SELECT Agente_Localidad AS nombre_localidad, Agente_Provincia AS nombre_provincia FROM gd_esquema.Maestra
                        WHERE Agente_Localidad IS NOT NULL AND Agente_Provincia IS NOT NULL
                 UNION
                    SELECT Cliente_Localidad AS nombre_localidad, Cliente_Provincia AS nombre_provincia FROM gd_esquema.Maestra
                        WHERE Cliente_Localidad IS NOT NULL AND Cliente_Provincia IS NOT NULL
                 UNION
                    SELECT Agencia_Localidad AS nombre_localidad, Agencia_Provincia AS nombre_provincia FROM gd_esquema.Maestra
                        WHERE Agencia_Localidad IS NOT NULL AND Agencia_Provincia IS NOT NULL
            ) localidades_unidas
        ) lp
JOIN GROUP_BY_GAMBETTA.Provincia p ON p.nombre_provincia = lp.nombre_provincia

END
GO

-- SP: MigrarPais

CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarPais
AS
BEGIN

    INSERT INTO GROUP_BY_GAMBETTA.Pais (nombre_pais)
    SELECT DISTINCT nombre_pais
    FROM (
        SELECT Aerolinea_Pais AS nombre_pais FROM gd_esquema.Maestra WHERE Aerolinea_Pais IS NOT NULL
        UNION
        SELECT Aeropuerto_Salida_Pais AS nombre_pais FROM gd_esquema.Maestra WHERE Aeropuerto_Salida_Pais IS NOT NULL
        UNION
        SELECT Aeropuerto_Llegada_Pais AS nombre_pais FROM gd_esquema.Maestra WHERE Aeropuerto_Llegada_Pais IS NOT NULL
        UNION
        SELECT Hospedaje_Pais AS nombre_pais FROM gd_esquema.Maestra WHERE Hospedaje_Pais IS NOT NULL
    ) paises

END
GO

-- SP: MigrarCiudad

CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarCiudad
AS
BEGIN
    INSERT INTO GROUP_BY_GAMBETTA.Ciudad (id_pais, nombre_ciudad)
    SELECT p.id_pais, cu.nombre_ciudad
    FROM (
        SELECT DISTINCT nombre_ciudad, nombre_pais
        FROM (
            SELECT Aeropuerto_Salida_Ciudad AS nombre_ciudad, Aeropuerto_Salida_Pais AS nombre_pais FROM gd_esquema.Maestra
                WHERE Aeropuerto_Salida_Ciudad IS NOT NULL
                  AND Aeropuerto_Salida_Pais IS NOT NULL
            UNION
            SELECT Aeropuerto_Llegada_Ciudad AS nombre_ciudad, Aeropuerto_Llegada_Pais AS nombre_pais FROM gd_esquema.Maestra
                WHERE Aeropuerto_Llegada_Ciudad IS NOT NULL
                  AND Aeropuerto_Llegada_Pais IS NOT NULL
            UNION
            SELECT Hospedaje_Ciudad AS nombre_ciudad, Hospedaje_Pais AS nombre_pais FROM gd_esquema.Maestra
                WHERE Hospedaje_Ciudad IS NOT NULL
                  AND Hospedaje_Pais IS NOT NULL
        ) ciudades_unidas
    ) cu
    JOIN GROUP_BY_GAMBETTA.Pais p ON p.nombre_pais = cu.nombre_pais
END
GO

-- SP: MigrarAlianza

CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarAlianza
AS
BEGIN
    INSERT INTO GROUP_BY_GAMBETTA.Alianza (nombre_alianza)
    SELECT DISTINCT Aerolinea_Alianza
    FROM gd_esquema.Maestra
    WHERE Aerolinea_Alianza IS NOT NULL AND Aerolinea_Alianza != 'Sin Alianza'
END
GO

-- SP: MigrarAerolinea

CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarAerolinea
AS
BEGIN
    INSERT INTO GROUP_BY_GAMBETTA.Aerolinea (codigo, nombre, id_pais, id_alianza)
    SELECT a.Aerolinea_Codigo, a.Aerolinea_Nombre, p.id_pais, al.id_alianza
    FROM (SELECT DISTINCT Aerolinea_Codigo, Aerolinea_Nombre, Aerolinea_Pais, Aerolinea_Alianza
          FROM gd_esquema.Maestra
          WHERE Aerolinea_Codigo IS NOT NULL) a
    LEFT JOIN GROUP_BY_GAMBETTA.Pais p ON p.nombre_pais = a.Aerolinea_Pais
    LEFT JOIN GROUP_BY_GAMBETTA.Alianza al ON al.nombre_alianza = a.Aerolinea_Alianza
END
GO

-- SP: MigrarAeropuerto


CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarAeropuerto
AS
BEGIN

    INSERT INTO GROUP_BY_GAMBETTA.Aeropuerto (codigo_aeropuerto, descripcion, id_ciudad)
    SELECT
        a.codigo,
        a.descripcion,
        c.id_ciudad
    FROM (
        SELECT DISTINCT codigo, descripcion, nombre_ciudad, nombre_pais
        FROM (
            SELECT
                Aeropuerto_Salida_Codigo AS codigo,
                Aeropuerto_Salida_Descripcion AS descripcion,
                Aeropuerto_Salida_Ciudad AS nombre_ciudad,
                Aeropuerto_Salida_Pais AS nombre_pais
            FROM gd_esquema.Maestra
            WHERE Aeropuerto_Salida_Codigo IS NOT NULL
            UNION
            SELECT
                Aeropuerto_Llegada_Codigo AS codigo,
                Aeropuerto_Llegada_Descripcion AS descripcion,
                Aeropuerto_Llegada_Ciudad AS nombre_ciudad,
                Aeropuerto_Llegada_Pais AS nombre_pais
            FROM gd_esquema.Maestra
            WHERE Aeropuerto_Llegada_Codigo IS NOT NULL
        ) aeropuertos_unicos
    ) a
    JOIN GROUP_BY_GAMBETTA.Pais p ON p.nombre_pais = a.nombre_pais
    JOIN GROUP_BY_GAMBETTA.Ciudad c ON c.nombre_ciudad = a.nombre_ciudad AND c.id_pais = p.id_pais
END
GO

-- SP: MigrarVuelo

CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarVuelo
AS
BEGIN

    INSERT INTO GROUP_BY_GAMBETTA.Vuelo (
        cod_aeropuerto_salida, cod_aeropuerto_llegada, cod_aerolinea,
        fecha_salida, fecha_llegada, horario_salida, horario_llegada,
        duracion, precio, incluye_carry, incluye_valija
    )
    SELECT
        v.cod_aer_salida, v.cod_aer_llegada, v.cod_aerolinea,
        v.fecha_salida, v.fecha_llegada, v.horario_salida, v.horario_llegada,
        v.duracion, v.precio, v.incluye_carry, v.incluye_valija
    FROM (SELECT DISTINCT
        Aeropuerto_Salida_Codigo AS cod_aer_salida,
        Aeropuerto_Llegada_Codigo AS cod_aer_llegada,
        Aerolinea_Codigo AS cod_aerolinea,
        Vuelo_Fecha_Salida AS fecha_salida,
        Vuelo_Fecha_Llegada AS fecha_llegada,
        Vuelo_Horario_Salida AS horario_salida,
        Vuelo_Horario_Llegada AS horario_llegada,
        Vuelo_Duracion AS duracion,
        Vuelo_Precio AS precio,
        Vuelo_Incluye_Carry AS incluye_carry,
        Vuelo_Incluye_Valija AS incluye_valija
        FROM gd_esquema.Maestra
        WHERE Aeropuerto_Salida_Codigo IS NOT NULL
         AND Aeropuerto_Llegada_Codigo IS NOT NULL
         AND Aerolinea_Codigo IS NOT NULL
         AND Vuelo_Fecha_Salida IS NOT NULL
        ) v
END
GO

-- SP: MigrarHospedaje

CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarHospedaje
AS
BEGIN
    INSERT INTO GROUP_BY_GAMBETTA.Hospedaje (id_ciudad, nombre, direccion, incluye_desayuno, checkin, checkout)
    SELECT
        c.id_ciudad,
        h.nombre,
        h.direccion,
        h.incluye_desayuno,
        h.checkin,
        h.checkout
    FROM (
        SELECT DISTINCT
            Hospedaje_Nombre AS nombre,
            Hospedaje_Ciudad AS nombre_ciudad,
            Hospedaje_Pais AS nombre_pais,
            Hospedaje_Direccion AS direccion,
            Hospedaje_Incluye_Desayuno AS incluye_desayuno,
            Hospedaje_Check_In AS checkin,
            Hospedaje_Check_Out AS checkout
        FROM gd_esquema.Maestra
        WHERE Hospedaje_Nombre IS NOT NULL
          AND Hospedaje_Ciudad IS NOT NULL
    ) h
    JOIN GROUP_BY_GAMBETTA.Pais p ON p.nombre_pais = h.nombre_pais
    JOIN GROUP_BY_GAMBETTA.Ciudad c ON c.nombre_ciudad = h.nombre_ciudad AND c.id_pais = p.id_pais
END
GO

-- SP: MigrarTipoHabitacion

CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarTipoHabitacion
AS
BEGIN

    INSERT INTO GROUP_BY_GAMBETTA.Tipo_Habitacion (cod_hospedaje,nombre_habitacion, descripcion, precioNoche)
    SELECT
        hosp.cod_hospedaje,
        hab.nombre_habitacion,
        hab.descripcion,
        hab.precioNoche
    FROM (
        SELECT DISTINCT
            Habitacion_Nombre AS nombre_habitacion,
            Habitacion_Descripcion AS descripcion,
            Habitacion_Precio_Noche AS precioNoche,
            Hospedaje_Nombre AS nombre_hospedaje,
            Hospedaje_Ciudad AS nombre_ciudad,
            Hospedaje_Pais AS nombre_pais
        FROM gd_esquema.Maestra
        WHERE Habitacion_Nombre IS NOT NULL
          AND Hospedaje_Nombre IS NOT NULL
    ) hab
    JOIN GROUP_BY_GAMBETTA.Pais p ON p.nombre_pais = hab.nombre_pais
    JOIN GROUP_BY_GAMBETTA.Ciudad c ON c.nombre_ciudad = hab.nombre_ciudad AND c.id_pais = p.id_pais
    JOIN GROUP_BY_GAMBETTA.Hospedaje hosp ON hosp.nombre = hab.nombre_hospedaje AND hosp.id_ciudad = c.id_ciudad

END
GO

-- SP: MigrarProveedor

CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarProveedor
AS
BEGIN

    INSERT INTO GROUP_BY_GAMBETTA.Proveedor(nombre, mail, telefono)
    SELECT nombre,mail,telefono
    FROM (
        SELECT DISTINCT
            Proveedor_Nombre AS nombre,
            Proveedor_Mail AS mail,
            Proveedor_Telefono AS telefono
        FROM gd_esquema.Maestra
        WHERE Proveedor_Nombre IS NOT NULL
    ) e

END
GO


-- SP: MigrarExcursion

CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarExcursion
AS
BEGIN

    INSERT INTO GROUP_BY_GAMBETTA.Excursion (nombre, descripcion, horario, duracion, precio, id_proveedor)
    SELECT e.nombre, descripcion, horario, duracion, precio, p.id_proveedor
    FROM (
        SELECT DISTINCT
            Excursion_Nombre AS nombre,
            Excursion_Descripcion AS descripcion,
            Excursion_Horario AS horario,
            Excursion_Duracion AS duracion,
            Excursion_Precio AS precio,
            Proveedor_Nombre AS p_nombre
        FROM gd_esquema.Maestra
        WHERE Excursion_Nombre IS NOT NULL
    ) e
    JOIN GROUP_BY_GAMBETTA.Proveedor p On p.nombre = e.p_nombre

END
GO


-- SP: MigrarAgencia


CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarAgencia
AS
BEGIN

    INSERT INTO GROUP_BY_GAMBETTA.Agencia (nro_agencia, direccion, telefono, mail, id_localidad)
    SELECT
        a.nro_agencia,
        a.direccion,
        a.telefono,
        a.mail,
        l.id_localidad
    FROM (SELECT DISTINCT
            Agencia_Nro_Agencia AS nro_agencia ,
            Agencia_Direccion AS direccion,
            Agencia_Telefono AS telefono,
            Agencia_Mail AS mail,
            Agencia_Localidad AS nombre_localidad,
            Agencia_Provincia AS nombre_provincia
        FROM gd_esquema.Maestra
        WHERE Agencia_Nro_Agencia IS NOT NULL) a
     JOIN GROUP_BY_GAMBETTA.Provincia prov ON prov.nombre_provincia = a.nombre_provincia
     JOIN GROUP_BY_GAMBETTA.Localidad l ON l.nombre_localidad = a.nombre_localidad
                                              AND l.id_provincia = prov.id_provincia
END
GO

-- SP: MigrarAgente

CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarAgente
AS
BEGIN


    INSERT INTO GROUP_BY_GAMBETTA.Agente (
        agente_legajo, nro_agencia, nombre, apellido, dni,
        fecha_Nacimiento, Telefono, mail, direccion, id_localidad
    )
    SELECT
        ag.agente_legajo,
        ag.nro_agencia,
        ag.nombre,
        ag.apellido,
        ag.dni,
        ag.fecha_Nacimiento,
        ag.Telefono,
        ag.mail,
        ag.direccion,
        l.id_localidad
    FROM (
        SELECT DISTINCT
            Agente_Legajo AS agente_legajo,
            Agencia_Nro_Agencia AS nro_agencia,
            Agente_Nombre AS nombre,
            Agente_Apellido AS apellido,
            Agente_Dni AS dni,
            Agente_Fecha_Nac AS fecha_Nacimiento,
            Agente_Telefono AS Telefono,
            Agente_Mail AS mail,
            Agente_Direccion AS direccion,
            Agente_Localidad AS nombre_localidad,
            Agente_Provincia AS nombre_provincia
        FROM gd_esquema.Maestra
        WHERE Agente_Legajo IS NOT NULL
    ) ag
    LEFT JOIN GROUP_BY_GAMBETTA.Provincia prov ON prov.nombre_provincia = ag.nombre_provincia
    LEFT JOIN GROUP_BY_GAMBETTA.Localidad l ON l.nombre_localidad = ag.nombre_localidad
                                               AND l.id_provincia = prov.id_provincia
END
GO

-- SP: MigrarCliente

CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarCliente
AS
BEGIN


    INSERT INTO GROUP_BY_GAMBETTA.Cliente (
        nombre, apellido, dni, fecha_Nacimiento,
        Telefono, mail, direccion, id_localidad
    )
    SELECT
        cl.nombre,
        cl.apellido,
        cl.dni,
        cl.fecha_Nacimiento,
        cl.Telefono,
        cl.mail,
        cl.direccion,
        l.id_localidad
    FROM (
        SELECT DISTINCT
            Cliente_Dni AS dni,
            Cliente_Nombre AS nombre,
            Cliente_Apellido AS apellido,
            Cliente_Fecha_Nac AS fecha_Nacimiento,
            Cliente_Tel AS Telefono,
            Cliente_Mail AS mail,
            Cliente_Direccion AS direccion,
            Cliente_Localidad AS nombre_localidad,
            Cliente_Provincia AS nombre_provincia
        FROM gd_esquema.Maestra
        WHERE Cliente_Dni IS NOT NULL
    ) cl
    LEFT JOIN GROUP_BY_GAMBETTA.Provincia prov ON prov.nombre_provincia = cl.nombre_provincia
    LEFT JOIN GROUP_BY_GAMBETTA.Localidad l ON l.nombre_localidad = cl.nombre_localidad
                                              AND l.id_provincia = prov.id_provincia

END
GO

-- SP: MigrarCanalVenta

CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarCanalVenta
AS
BEGIN

    INSERT INTO GROUP_BY_GAMBETTA.Canal_Venta (nombre_canal)
    SELECT DISTINCT Venta_Canal_Venta
    FROM gd_esquema.Maestra
    WHERE Venta_Canal_Venta IS NOT NULL

END
GO


-- SP: MigrarMedioPago

CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarMedioPago
AS
BEGIN

    INSERT INTO GROUP_BY_GAMBETTA.Medio_Pago (nombre_medio_pago)
    SELECT DISTINCT Venta_Medio_Pago
    FROM gd_esquema.Maestra
    WHERE Venta_Medio_Pago IS NOT NULL

END
GO

-- SP: MigrarVenta

CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarVenta
AS
BEGIN


    INSERT INTO GROUP_BY_GAMBETTA.Venta (
        nro_venta, agente_legajo, nro_cliente, fecha,
        id_canal_venta, subtotal, descuento, importe_total, id_medio_pago
    )
    SELECT
        v.nro_venta,
        v.agente_legajo,
        cl.nro_cliente,
        v.fecha,
        cv.id_canal_venta,
        v.subtotal,
        v.descuento,
        v.importe_total,
        mp.id_medio_pago
    FROM ( SELECT DISTINCT
            Venta_Nro_Venta AS nro_venta,
            Agente_Legajo AS agente_legajo,
            Cliente_Dni AS cliente_dni,
            Cliente_Nombre AS nombre_cliente,
            Venta_Fecha_Venta AS fecha,
            Venta_Canal_Venta AS canal_venta,
            Venta_Subtotal AS subtotal,
            Venta_Descuento AS descuento,
            Venta_Importe_Total AS importe_total,
            Venta_Medio_Pago AS medio_pago
        FROM gd_esquema.Maestra
        WHERE Venta_Nro_Venta IS NOT NULL AND Cliente_Dni IS NOT NULL AND Cliente_Nombre IS NOT NULL
    ) v
    JOIN GROUP_BY_GAMBETTA.Cliente cl ON cl.dni = v.cliente_dni AND cl.nombre = v.nombre_cliente
    JOIN GROUP_BY_GAMBETTA.Canal_Venta cv ON cv.nombre_canal = v.canal_venta
    JOIN GROUP_BY_GAMBETTA.Medio_Pago mp ON mp.nombre_medio_pago = v.medio_pago
END
GO

-- SP: MigrarProducto

CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarProducto
AS
BEGIN
  -- Supertipo
    INSERT INTO GROUP_BY_GAMBETTA.Producto (cod_reserva, nro_venta,nro_cliente)
    SELECT vv.cod_reserva, vv.nro_venta, c.nro_cliente
    FROM (
            SELECT DISTINCT
                    Detalle_Venta_Vuelo_Cod_Reserva AS cod_reserva,
                    Venta_Nro_Venta AS nro_venta,
                    Cliente_Dni AS dni,
                    Cliente_Nombre AS nombre
            FROM gd_esquema.Maestra
            WHERE Detalle_Venta_Vuelo_Cod_Reserva IS NOT NULL
                  AND Venta_Nro_Venta IS NOT NULL AND Cliente_Dni IS NOT NULL AND Cliente_Nombre IS NOT NULL
            UNION
            SELECT DISTINCT
                    Detalle_Venta_Hospedaje_Cod_Reserva AS cod_reserva,
                    Venta_Nro_Venta AS nro_venta,
                    Cliente_Dni AS dni,
                    Cliente_Nombre AS nombre
            FROM gd_esquema.Maestra
            WHERE Detalle_Venta_Hospedaje_Cod_Reserva IS NOT NULL
                  AND Venta_Nro_Venta IS NOT NULL AND Cliente_Dni IS NOT NULL AND Cliente_Nombre IS NOT NULL
            UNION
            SELECT DISTINCT
                    Detalle_Venta_Excursion_Cod_Reserva AS cod_reserva,
                    Venta_Nro_Venta AS nro_venta,
                    Cliente_Dni AS dni,
                    Cliente_Nombre AS nombre
            FROM gd_esquema.Maestra
            WHERE Detalle_Venta_Excursion_Cod_Reserva IS NOT NULL
                  AND Venta_Nro_Venta IS NOT NULL AND Cliente_Dni IS NOT NULL AND Cliente_Nombre IS NOT NULL
    ) vv
    JOIN Cliente c ON c.dni = vv.dni AND c.nombre = vv.nombre
END
GO

-- SP: MigrarProductoVentaVuelo

CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarProductoVentaVuelo
AS
BEGIN
    INSERT INTO GROUP_BY_GAMBETTA.Venta_Vuelo (cod_reserva, cod_vuelo, subtotal, cantidad_pasajes, precio_unitario)
    SELECT
        vv.cod_reserva,
        vu.cod_vuelo,
        vv.subtotal,
        vv.cantidad_pasajes,
        vv.precio_unitario
    FROM (
        SELECT DISTINCT
            Detalle_Venta_Vuelo_Cod_Reserva AS cod_reserva,
            Venta_Nro_Venta AS nro_venta,
            Aeropuerto_Salida_Codigo AS cod_aer_salida,
            Aeropuerto_Llegada_Codigo AS cod_aer_llegada,
            Aerolinea_Codigo AS cod_aerolinea,
            Vuelo_Fecha_Salida AS fecha_salida,
            Vuelo_Horario_Salida AS horario_salida,
            Detalle_Venta_Vuelo_Cantidad_Pasajes AS cantidad_pasajes,
            Detalle_Venta_Vuelo_Precio_Unitario AS precio_unitario,
            Detalle_Venta_Vuelo_Subtotal AS subtotal
        FROM gd_esquema.Maestra
        WHERE Detalle_Venta_Vuelo_Cod_Reserva IS NOT NULL
          AND Venta_Nro_Venta IS NOT NULL
    ) vv
    JOIN GROUP_BY_GAMBETTA.Vuelo vu ON vu.cod_aeropuerto_salida = vv.cod_aer_salida
                                         AND vu.cod_aeropuerto_llegada = vv.cod_aer_llegada
                                         AND vu.cod_aerolinea = vv.cod_aerolinea
                                         AND vu.fecha_salida = vv.fecha_salida
                                         AND vu.horario_salida = vv.horario_salida
END
GO

-- SP: MigrarProductoVentaHospedaje

CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarProductoVentaHospedaje
AS
BEGIN

    INSERT INTO GROUP_BY_GAMBETTA.Venta_Hospedaje (
        cod_reserva, num_habitacion, fecha_desde, fecha_hasta,
        cantidad, precio_unitario, subtotal
    )
    SELECT
        vh.cod_reserva,
        th.num_habitacion,
        vh.fecha_desde,
        vh.fecha_hasta,
        vh.cantidad,
        vh.precio_unitario,
        vh.subtotal
    FROM (
        SELECT DISTINCT
            Detalle_Venta_Hospedaje_Cod_Reserva AS cod_reserva,
            Venta_Nro_Venta AS nro_venta,
            Hospedaje_Nombre AS nombre_hospedaje,
            Hospedaje_Ciudad AS ciudad_hospedaje,
            Hospedaje_Pais AS pais_hospedaje,
            Habitacion_Nombre AS nombre_habitacion,
            Detalle_Venta_Hospedaje_Fecha_Desde AS fecha_desde,
            Detalle_Venta_Hospedaje_Fecha_Hasta AS fecha_hasta,
            Detalle_Venta_Hospedaje_Cantidad AS cantidad,
            Detalle_Venta_Hospedaje_Precio_Unitario AS precio_unitario,
            Detalle_Venta_Hospedaje_Subtotal AS subtotal
        FROM gd_esquema.Maestra
        WHERE Detalle_Venta_Hospedaje_Cod_Reserva IS NOT NULL
          AND Venta_Nro_Venta IS NOT NULL
    ) vh
    JOIN GROUP_BY_GAMBETTA.Pais p ON p.nombre_pais = vh.pais_hospedaje
    JOIN GROUP_BY_GAMBETTA.Ciudad c ON c.nombre_ciudad = vh.ciudad_hospedaje AND c.id_pais = p.id_pais
    JOIN GROUP_BY_GAMBETTA.Hospedaje hosp ON hosp.nombre = vh.nombre_hospedaje AND hosp.id_ciudad = c.id_ciudad
    JOIN GROUP_BY_GAMBETTA.Tipo_Habitacion th ON th.cod_hospedaje = hosp.cod_hospedaje AND th.nombre_habitacion = vh.nombre_habitacion

END
GO

-- SP: MigrarProductoVentaExcursion

CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarProductoVentaExcursion
AS
BEGIN



    INSERT INTO GROUP_BY_GAMBETTA.Venta_Excursion (
        cod_reserva, cod_excursion, fecha_reserva, cantidad, precio_unitario, subtotal
    )
    SELECT
        ve.cod_reserva,
        ex.cod_excursion,
        ve.fecha_reserva,
        ve.cantidad,
        ve.precio_unitario,
        ve.subtotal
    FROM (
        SELECT DISTINCT
            Detalle_Venta_Excursion_Cod_Reserva AS cod_reserva,
            Venta_Nro_Venta AS nro_venta,
            Excursion_Nombre AS nombre_excursion,
            Detalle_Venta_Excursion_Fecha_Reserva AS fecha_reserva,
            Detalle_Venta_Excursion_Cant AS cantidad,
            Detalle_Venta_Excursion_Precio_Unitario AS precio_unitario,
            Detalle_Venta_Excursion_Subtotal AS subtotal
        FROM gd_esquema.Maestra
        WHERE Detalle_Venta_Excursion_Cod_Reserva IS NOT NULL
          AND Venta_Nro_Venta IS NOT NULL
    ) ve
    JOIN GROUP_BY_GAMBETTA.Excursion ex ON ex.nombre = ve.nombre_excursion

END
GO

-- SP: MigrarSolicitud

CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarSolicitud
AS
BEGIN

    INSERT INTO GROUP_BY_GAMBETTA.Solicitud (
        nro_solicitud, nro_cliente, agente_legajo,
        fecha_solicitud, fecha_inicio_tentativa, fecha_fin_tentativa,
        cant_pax, observaciones, presupuesto_estimado
    )
    SELECT
        s.nro_solicitud,
        cl.nro_cliente,
        s.agente_legajo,
        s.fecha_solicitud,
        s.fecha_inicio_tentativa,
        s.fecha_fin_tentativa,
        s.cant_pax,
        s.observaciones,
        s.presupuesto_estimado
    FROM (
        SELECT DISTINCT
            Solicitud_Nro_Solicitud AS nro_solicitud,
            Cliente_Dni AS cliente_dni,
            Cliente_Nombre AS cliente_nombre,
            Agente_Legajo AS agente_legajo,
            Solicitud_Fecha_Solicitud AS fecha_solicitud,
            Solicitud_Fecha_Inicio_Tentativa AS fecha_inicio_tentativa,
            Solicitud_Fecha_Fin_Tentativa AS fecha_fin_tentativa,
            Solicitud_Cant_Pax AS cant_pax,
            Solicitud_Observaciones AS observaciones,
            Solicitud_Presupuesto_Estimado AS presupuesto_estimado
        FROM gd_esquema.Maestra
        WHERE Solicitud_Nro_Solicitud IS NOT NULL
    ) s
    JOIN GROUP_BY_GAMBETTA.Cliente cl ON cl.dni = s.cliente_dni AND cl.nombre = s.cliente_nombre

END
GO


-- SP: MigrarDetalleSolicitud

CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarDetalleSolicitud
AS
BEGIN

    INSERT INTO GROUP_BY_GAMBETTA.Detalle_Solicitud (ciudad, nro_solicitud, cantidad_dias_aprox, observaciones)
    SELECT DISTINCT
        m.Detalle_Solicitud_Ciudad,
        m.Solicitud_Nro_Solicitud,
        m.Detalle_Solicitud_Cant_Dias_Aprox,
        m.Detalle_Solicitud_Observaciones
    FROM gd_esquema.Maestra m
    INNER JOIN GROUP_BY_GAMBETTA.Solicitud s ON s.nro_solicitud = m.Solicitud_Nro_Solicitud
    WHERE m.Solicitud_Nro_Solicitud IS NOT NULL AND Detalle_Solicitud_Ciudad IS NOT NULL
    AND Detalle_Solicitud_Cant_Dias_Aprox IS NOT NULL AND Detalle_Solicitud_Observaciones IS NOT NULL

END
GO

-- SP: MigrarEstado
CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarEstado
AS
BEGIN

    INSERT INTO GROUP_BY_GAMBETTA.Estado(estado)
    SELECT p.estado
    FROM (SELECT DISTINCT Propuesta_Estado AS estado
    FROM gd_esquema.Maestra WHERE Propuesta_Estado IS NOT NULL) p
    
END
GO
-- SP: MigrarPropuesta

CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarPropuesta
AS
BEGIN

    INSERT INTO GROUP_BY_GAMBETTA.Propuesta (
        nro_propuesta, nro_solicitud, agente_legajo,
        fecha_emision, vigencia_hasta, fecha_desde, fecha_hasta,
        subtotal, descuento, importe_total, nro_estado
    )
    SELECT
        p.nro_propuesta,
        p.nro_solicitud,
        p.agente_legajo,
        p.fecha_emision,
        p.vigencia_hasta,
        p.fecha_desde,
        p.fecha_hasta,
        p.subtotal,
        p.descuento,
        p.importe_total,
        e.nro_estado
    FROM (
        SELECT DISTINCT
            Propuesta_Nro_Propuesta AS nro_propuesta,
            Solicitud_Nro_Solicitud AS nro_solicitud,
            Agente_Legajo AS agente_legajo,
            Propuesta_Fecha_Emision AS fecha_emision,
            Propuesta_Vigencia_Hasta AS vigencia_hasta,
            Propuesta_Fecha_Desde AS fecha_desde,
            Propuesta_Fecha_Hasta AS fecha_hasta,
            Propuesta_Subtotal AS subtotal,
            Propuesta_Descuento AS descuento,
            Propuesta_Importe_Total AS importe_total,
            Propuesta_Estado AS estado
        FROM gd_esquema.Maestra
        WHERE Propuesta_Nro_Propuesta IS NOT NULL
          AND Solicitud_Nro_Solicitud IS NOT NULL
    ) p
    JOIN GROUP_BY_GAMBETTA.Solicitud s ON s.nro_solicitud = p.nro_solicitud
    JOIN GROUP_BY_GAMBETTA.Agente ag ON ag.agente_legajo = p.agente_legajo
    JOIN GROUP_BY_GAMBETTA.Estado e ON e.estado = p.estado
END
GO

-- SP: MigrarPropuestaVuelo

CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarPropuestaVuelo
AS
BEGIN

    INSERT INTO GROUP_BY_GAMBETTA.Propuesta_Vuelo (
        cod_vuelo, nro_propuesta, subtotal, cantidad_pasajes, precio_unitario
    )
    SELECT DISTINCT
        vu.cod_vuelo,
        m.Propuesta_Nro_Propuesta,
        m.Detalle_Propuesta_Vuelo_Subtotal,
        m.Detalle_Propuesta_Vuelo_Cant_Pasajes,
        m.Detalle_Propuesta_Vuelo_Precio
    FROM gd_esquema.Maestra m
    JOIN GROUP_BY_GAMBETTA.Propuesta p ON p.nro_propuesta = m.Propuesta_Nro_Propuesta
    JOIN GROUP_BY_GAMBETTA.Vuelo vu ON vu.cod_aeropuerto_salida = m.Aeropuerto_Salida_Codigo
                                             AND vu.cod_aeropuerto_llegada = m.Aeropuerto_Llegada_Codigo
                                             AND vu.cod_aerolinea = m.Aerolinea_Codigo
                                             AND vu.fecha_salida = m.Vuelo_Fecha_Salida
                                             AND vu.horario_salida = m.Vuelo_Horario_Salida
    WHERE m.Propuesta_Nro_Propuesta IS NOT NULL
      AND m.Detalle_Propuesta_Vuelo_Cant_Pasajes IS NOT NULL
END
GO

-- SP: MigrarPropuestaHospedaje

CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarPropuestaHospedaje
AS
BEGIN

    INSERT INTO GROUP_BY_GAMBETTA.Propuesta_Hospedaje (
        nro_propuesta, num_habitacion,
        fecha_desde, fecha_hasta, cantidad, precio_unitario, subtotal
    )
    SELECT DISTINCT
        m.Propuesta_Nro_Propuesta,
        th.num_habitacion,
        m.Detalle_Propuesta_Hospedaje_Fecha_Desde,
        m.Detalle_Propuesta_Hospedaje_Fecha_Hasta,
        m.Detalle_Propuesta_Hospedaje_Cant,
        m.Detalle_Propuesta_Hospedaje_Precio,
        m.Detalle_Propuesta_Hospedaje_Subtotal
    FROM gd_esquema.Maestra m
    JOIN GROUP_BY_GAMBETTA.Pais pa ON pa.nombre_pais = m.Hospedaje_Pais
    JOIN GROUP_BY_GAMBETTA.Ciudad c ON c.nombre_ciudad = m.Hospedaje_Ciudad AND c.id_pais = pa.id_pais
    JOIN GROUP_BY_GAMBETTA.Hospedaje hosp ON hosp.nombre = m.Hospedaje_Nombre AND hosp.id_ciudad = c.id_ciudad
    JOIN GROUP_BY_GAMBETTA.Tipo_Habitacion th ON th.cod_hospedaje = hosp.cod_hospedaje AND th.nombre_habitacion = m.Habitacion_Nombre
    WHERE m.Propuesta_Nro_Propuesta IS NOT NULL
      AND m.Detalle_Propuesta_Hospedaje_Cant IS NOT NULL

END
GO

-- SP: MigrarAspecto

CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarAspecto
AS
BEGIN
    INSERT INTO GROUP_BY_GAMBETTA.Aspecto (aspecto)
    SELECT DISTINCT Aspecto_Aspecto
    FROM gd_esquema.Maestra
    WHERE Aspecto_Aspecto IS NOT NULL

END
GO

-- SP: MigrarEncuesta
CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarEncuesta
AS
BEGIN

    INSERT INTO GROUP_BY_GAMBETTA.Encuesta (codigo_encuesta,nro_cliente, agente_legajo, fecha_encuesta, comentarios)
    SELECT DISTINCT
        m.Encuesta_Codigo_Encuesta,
        cl.nro_cliente,
        m.agente_legajo,
        m.Encuesta_Fecha_Encuesta,
        m.Encuesta_Comentarios
    FROM gd_esquema.Maestra m
    JOIN GROUP_BY_GAMBETTA.Cliente cl ON cl.dni = m.Cliente_Dni AND m.Cliente_Nombre = cl.nombre
    WHERE m.Encuesta_Codigo_Encuesta IS NOT NULL

END
GO

-- SP: MigrarDetalleEncuesta

CREATE PROCEDURE GROUP_BY_GAMBETTA.MigrarDetalleEncuesta
AS
BEGIN
    INSERT INTO GROUP_BY_GAMBETTA.Detalle_Encuesta (cod_aspecto, codigo_encuesta, puntaje)
    SELECT DISTINCT
        asp.cod_aspecto,
        m.Encuesta_Codigo_Encuesta,
        m.Detalle_Encuesta_Puntaje
    FROM gd_esquema.Maestra m
    JOIN GROUP_BY_GAMBETTA.Aspecto asp ON asp.aspecto = m.Aspecto_Aspecto
    WHERE m.Detalle_Encuesta_Puntaje IS NOT NULL
      AND m.Aspecto_Aspecto IS NOT NULL
      AND m.Encuesta_Codigo_Encuesta IS NOT NULL
END
GO

-- SECCION 5: TRIGGERS

-- Trigger: TR_Venta_Propuesta_Estado

CREATE TRIGGER GROUP_BY_GAMBETTA.TR_Venta_Propuesta_Estado
ON GROUP_BY_GAMBETTA.Venta_Propuesta
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN GROUP_BY_GAMBETTA.Propuesta p ON p.nro_propuesta = i.nro_propuesta
        JOIN GROUP_BY_GAMBETTA.Estado e ON e.nro_estado = p.nro_estado
        WHERE e.estado <> 'Aceptada'
    )
    BEGIN
        RAISERROR('Solo se pueden vincular propuestas con estado Aceptada a una venta.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- Trigger: TR_DetalleEncuesta_Puntaje

CREATE TRIGGER GROUP_BY_GAMBETTA.TR_DetalleEncuesta_Puntaje
ON GROUP_BY_GAMBETTA.Detalle_Encuesta
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted
        WHERE puntaje IS NOT NULL AND (puntaje < 1 OR puntaje > 5)
    )
    BEGIN
        RAISERROR('El puntaje de encuesta debe estar entre 1 y 5.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- Trigger: TR_VentaPropuesta

CREATE TRIGGER GROUP_BY_GAMBETTA.TR_VentaPropuesta
ON GROUP_BY_GAMBETTA.Propuesta
AFTER INSERT
AS
BEGIN
        INSERT INTO Venta_Propuesta (nro_venta, nro_propuesta, nro_cliente)
        (SELECT DISTINCT m.Venta_Nro_Venta, m.Propuesta_Nro_Propuesta,c.nro_cliente FROM gd_esquema.Maestra m
        JOIN inserted i ON i.nro_propuesta = m.Propuesta_Nro_Propuesta
        JOIN Cliente c ON c.nombre = m.Cliente_Nombre AND c.dni = m.Cliente_Dni
        WHERE m.Venta_Nro_Venta IS NOT NULL AND Cliente_Dni IS NOT NULL AND Cliente_Nombre IS NOT NULL)

END
GO

-- SECCION 6: EJECUCION DE STORED PROCEDURES DE MIGRACION

PRINT '=== INICIO DE MIGRACION ==='

-- Tablas geograficas
EXEC GROUP_BY_GAMBETTA.MigrarProvincia
EXEC GROUP_BY_GAMBETTA.MigrarLocalidad
EXEC GROUP_BY_GAMBETTA.MigrarPais
EXEC GROUP_BY_GAMBETTA.MigrarCiudad

-- Aerolineas y aeropuertos
EXEC GROUP_BY_GAMBETTA.MigrarAlianza
EXEC GROUP_BY_GAMBETTA.MigrarAerolinea
EXEC GROUP_BY_GAMBETTA.MigrarAeropuerto

-- Productos turisticos
EXEC GROUP_BY_GAMBETTA.MigrarVuelo
EXEC GROUP_BY_GAMBETTA.MigrarHospedaje
EXEC GROUP_BY_GAMBETTA.MigrarTipoHabitacion
EXEC GROUP_BY_GAMBETTA.MigrarProveedor
EXEC GROUP_BY_GAMBETTA.MigrarExcursion

-- Agencias y personas
EXEC GROUP_BY_GAMBETTA.MigrarAgencia
EXEC GROUP_BY_GAMBETTA.MigrarAgente
EXEC GROUP_BY_GAMBETTA.MigrarCliente

-- Ventas
EXEC GROUP_BY_GAMBETTA.MigrarCanalVenta
EXEC GROUP_BY_GAMBETTA.MigrarMedioPago
EXEC GROUP_BY_GAMBETTA.MigrarVenta
EXEC GROUP_BY_GAMBETTA.MigrarProducto
EXEC GROUP_BY_GAMBETTA.MigrarProductoVentaVuelo
EXEC GROUP_BY_GAMBETTA.MigrarProductoVentaHospedaje
EXEC GROUP_BY_GAMBETTA.MigrarProductoVentaExcursion

-- Propuestas y solicitudes
EXEC GROUP_BY_GAMBETTA.MigrarSolicitud
EXEC GROUP_BY_GAMBETTA.MigrarDetalleSolicitud
EXEC GROUP_BY_GAMBETTA.MigrarEstado
EXEC GROUP_BY_GAMBETTA.MigrarPropuesta
EXEC GROUP_BY_GAMBETTA.MigrarPropuestaVuelo
EXEC GROUP_BY_GAMBETTA.MigrarPropuestaHospedaje

-- Encuestas
EXEC GROUP_BY_GAMBETTA.MigrarAspecto
EXEC GROUP_BY_GAMBETTA.MigrarEncuesta
EXEC GROUP_BY_GAMBETTA.MigrarDetalleEncuesta

GO
