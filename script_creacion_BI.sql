-- SCRIPT DE CREACION DE MODELO BI

USE [GD1C2026]
GO

-- SECCION 1: CREACION DE TABLAS DIMENSION

-- Dimension Tiempo

CREATE TABLE GROUP_BY_GAMBETTA.BI_Dim_Tiempo (
    id_tiempo INT IDENTITY(1,1) PRIMARY KEY,
    anio INT NOT NULL,
    cuatrimestre INT NOT NULL,
    mes INT NOT NULL,
    temporada NVARCHAR(50) NOT NULL
)
GO


--Dimension Rango Etario Cliente

CREATE TABLE GROUP_BY_GAMBETTA.BI_Dim_Rango_Etario_Cliente
(
    id_rango_etario_cliente INT IDENTITY(1,1) PRIMARY KEY,
    descripcion NVARCHAR(100) NOT NULL,
    edad_min INT,
    edad_max INT
)
GO

--Dimension Rango Etario Agente

CREATE TABLE GROUP_BY_GAMBETTA.BI_Dim_Rango_Etario_Agente
(
    id_rango_etario_agente INT IDENTITY(1,1) PRIMARY KEY,
    descripcion NVARCHAR(100) NOT NULL,
    edad_min INT,
    edad_max INT
)
GO

--Dimension Tipo Servicio
CREATE TABLE GROUP_BY_GAMBETTA.BI_Dim_Tipo_Servicio
(
    id_tipo_servicio INT IDENTITY(1,1) PRIMARY KEY,
    descripcion NVARCHAR(100) NOT NULL
)
GO

-- Dimension Canal de Venta

CREATE TABLE GROUP_BY_GAMBETTA.BI_Dim_Canal_Venta (
    id_canal_venta INT PRIMARY KEY,
    nombre_canal NVARCHAR(255) NOT NULL
)
GO

--Dimension Estado Propuesta
CREATE TABLE GROUP_BY_GAMBETTA.BI_Dim_Estado_Propuesta
(
    id_estado INT PRIMARY KEY,
    descripcion NVARCHAR(255)
)
GO

-- Dimension Aspecto

CREATE TABLE GROUP_BY_GAMBETTA.BI_Dim_Aspecto (
    id_aspecto  INT PRIMARY KEY,
    aspecto NVARCHAR(255) NOT NULL
)
GO

-- SECCION 2: CREACION DE TABLAS FACT

-- Fact Venta

CREATE TABLE GROUP_BY_GAMBETTA.BI_Fact_Venta
(
    id_tiempo INT NOT NULL,
    id_rango_etario_cliente INT NOT NULL,
    id_canal_venta INT NOT NULL,
    id_tipo_servicio INT NOT NULL,

    cant_ventas INT NOT NULL,
    total_facturacion DECIMAL(18,2) NOT NULL,

    PRIMARY KEY (id_tiempo, id_rango_etario_cliente, id_canal_venta, id_tipo_servicio),
    FOREIGN KEY (id_tiempo) REFERENCES GROUP_BY_GAMBETTA.BI_Dim_Tiempo(id_tiempo),
    FOREIGN KEY (id_rango_etario_cliente) REFERENCES GROUP_BY_GAMBETTA.BI_Dim_Rango_Etario_Cliente(id_rango_etario_cliente),
    FOREIGN KEY (id_canal_venta) REFERENCES GROUP_BY_GAMBETTA.BI_Dim_Canal_Venta(id_canal_venta),
    FOREIGN KEY (id_tipo_servicio) REFERENCES GROUP_BY_GAMBETTA.BI_Dim_Tipo_Servicio(id_tipo_servicio)
)
GO

-- Fact Solicitud

CREATE TABLE GROUP_BY_GAMBETTA.BI_Fact_Solicitud
(
    id_tiempo INT NOT NULL,
    id_rango_etario_cliente INT NOT NULL,

    cant_solicitudes INT NOT NULL,
    total_dias_anticipacion INT NOT NULL,

    PRIMARY KEY (id_tiempo, id_rango_etario_cliente),
    FOREIGN KEY (id_tiempo) REFERENCES GROUP_BY_GAMBETTA.BI_Dim_Tiempo(id_tiempo),
    FOREIGN KEY (id_rango_etario_cliente) REFERENCES GROUP_BY_GAMBETTA.BI_Dim_Rango_Etario_Cliente(id_rango_etario_cliente)
)
GO

-- Fact Propuesta

CREATE TABLE GROUP_BY_GAMBETTA.BI_Fact_Propuesta
(
    id_tiempo_emision INT NOT NULL,
    id_tiempo_solicitud INT NOT NULL,
    id_tiempo_inicio_viaje INT NOT NULL,

    id_rango_etario_agente INT NOT NULL,
    id_estado_propuesta INT NOT NULL,

    cant_propuestas INT NOT NULL,
    total_importe DECIMAL(18,2) NOT NULL,
    total_dias_respuesta INT NOT NULL,
    total_desvio_presupuesto DECIMAL(18,2) NOT NULL

    PRIMARY KEY (id_tiempo_emision,id_tiempo_solicitud, id_tiempo_inicio_viaje, id_rango_etario_agente,id_estado_propuesta),
    FOREIGN KEY (id_tiempo_emision) REFERENCES GROUP_BY_GAMBETTA.BI_Dim_Tiempo(id_tiempo),
    FOREIGN KEY (id_rango_etario_agente) REFERENCES GROUP_BY_GAMBETTA.BI_Dim_Rango_Etario_Agente(id_rango_etario_agente),
    FOREIGN KEY (id_estado_propuesta) REFERENCES GROUP_BY_GAMBETTA.BI_Dim_Estado_Propuesta(id_estado),
    FOREIGN KEY (id_tiempo_solicitud) REFERENCES GROUP_BY_GAMBETTA.BI_Dim_Tiempo(id_tiempo),
    FOREIGN KEY (id_tiempo_inicio_viaje) REFERENCES GROUP_BY_GAMBETTA.BI_Dim_Tiempo(id_tiempo)

)


-- Fact Encuesta

CREATE TABLE GROUP_BY_GAMBETTA.BI_Fact_Encuesta
(
    id_tiempo INT NOT NULL,
    id_aspecto INT NOT NULL,
    id_rango_etario_agente INT NOT NULL,

    cant_respuestas INT NOT NULL,
    total_puntaje DECIMAL(18,2) NOT NULL,

    PRIMARY KEY(id_tiempo,id_aspecto,id_rango_etario_agente),
    FOREIGN KEY(id_tiempo) REFERENCES GROUP_BY_GAMBETTA.BI_Dim_Tiempo(id_tiempo),
    FOREIGN KEY(id_aspecto) REFERENCES GROUP_BY_GAMBETTA.BI_Dim_Aspecto(id_aspecto),
    FOREIGN KEY(id_rango_etario_agente) REFERENCES GROUP_BY_GAMBETTA.BI_Dim_Rango_Etario_Agente(id_rango_etario_agente)
)
GO

-- SECCION 3: POBLACION DE DIMENSIONES

-- Poblar BI_Dim_Tiempo

CREATE PROCEDURE GROUP_BY_GAMBETTA.cargar_dimension_tiempo
AS
BEGIN 
DECLARE @fecha DATE = '2020-01-01'; 
DECLARE @fechafin DATE = '2028-01-01'; 

WHILE @fecha<=@fechafin
    BEGIN
        INSERT INTO GROUP_BY_GAMBETTA.BI_Dim_Tiempo (anio,cuatrimestre,mes,temporada)
        VALUES (
        YEAR(@fecha), 
        CASE
        WHEN MONTH(@fecha) BETWEEN 1 AND 4 THEN 1
        WHEN MONTH(@fecha) BETWEEN 5 AND 8 THEN 2
        ELSE 3
        END, 
        MONTH(@fecha),
        CASE
        WHEN MONTH(@fecha) BETWEEN 1 AND 3 THEN 'Verano'
        WHEN MONTH(@fecha) BETWEEN 4 AND 6 THEN 'Otoño'
        WHEN MONTH(@fecha) BETWEEN 7 AND 9 THEN 'Invierno'
        ELSE 'Primavera'
        END)
        SET @fecha = DATEADD(MONTH, 1, @fecha)
    END
END
GO


-- Poblar BI_Dim_RE_Cliente

CREATE PROCEDURE GROUP_BY_GAMBETTA.cargar_dimension_re_cliente
AS
BEGIN
INSERT INTO GROUP_BY_GAMBETTA.BI_Dim_Rango_Etario_Cliente
(descripcion,edad_min,edad_max)
VALUES ('Menores de 25 inclusive',0,25), ('Entre 25 y 35 inclusive',26,35), ('Entre 35 y 50 inclusive',36,50), ('Mayores de 50',51,120)
END
GO

-- Poblar BI_Dim_RE_Agente


CREATE PROCEDURE GROUP_BY_GAMBETTA.cargar_dimension_re_agente
AS
BEGIN

INSERT INTO GROUP_BY_GAMBETTA.BI_Dim_Rango_Etario_Agente
(descripcion,edad_min,edad_max)
VALUES ('Entre 25 y 35 inclusive',25,35),('Entre 35 y 50 inclusive',36,50),('Mayores de 50',51,120)
END
GO

-- Poblar BI_Dim_tipo_servicio

CREATE PROCEDURE GROUP_BY_GAMBETTA.cargar_dimension_tipo_servicio
AS
BEGIN

INSERT INTO GROUP_BY_GAMBETTA.BI_Dim_Tipo_Servicio
(descripcion)
VALUES('Venta Directa'), ('Propuesta a Medida')
END
GO

-- Poblar BI_Dim_estado_propuesta

CREATE PROCEDURE GROUP_BY_GAMBETTA.cargar_dimension_estado_propuesta
AS
BEGIN
INSERT INTO GROUP_BY_GAMBETTA.BI_Dim_Estado_Propuesta (id_estado, descripcion)
SELECT nro_estado, estado
FROM GROUP_BY_GAMBETTA.Estado
END
GO


-- Poblar BI_Dim_Canal_Venta
CREATE PROCEDURE GROUP_BY_GAMBETTA.cargar_dimension_canal_venta
AS
BEGIN 
INSERT INTO GROUP_BY_GAMBETTA.BI_Dim_Canal_Venta (id_canal_venta, nombre_canal)
SELECT id_canal_venta, nombre_canal
FROM GROUP_BY_GAMBETTA.Canal_Venta
END
GO

-- Poblar BI_Dim_Aspecto
CREATE PROCEDURE GROUP_BY_GAMBETTA.cargar_dimension_aspecto
AS
BEGIN 
INSERT INTO GROUP_BY_GAMBETTA.BI_Dim_Aspecto (id_aspecto, aspecto)
SELECT cod_aspecto, aspecto
FROM GROUP_BY_GAMBETTA.Aspecto
END
GO

-- SECCION 4: POBLACION DE FACTS


-- Poblar BI_Fact_Venta

CREATE PROCEDURE GROUP_BY_GAMBETTA.migrar_fact_venta
AS
BEGIN
    INSERT INTO GROUP_BY_GAMBETTA.BI_Fact_Venta (id_tiempo, id_rango_etario_cliente,
    id_canal_venta, id_tipo_servicio, cant_ventas, total_facturacion)
    SELECT
        dt.id_tiempo,
        rec.id_rango_etario_cliente,
        v.id_canal_venta,
        CASE
            WHEN vp.nro_propuesta IS NULL THEN 1
            ELSE 2
        END AS id_tipo_servicio,
        COUNT(*) AS cant_ventas,
        SUM(v.importe_total) AS total_facturacion
    FROM GROUP_BY_GAMBETTA.Venta v
    JOIN GROUP_BY_GAMBETTA.Cliente c ON c.nro_cliente = v.nro_cliente
    JOIN GROUP_BY_GAMBETTA.BI_Dim_Tiempo dt ON dt.anio = YEAR(v.fecha) AND dt.mes = MONTH(v.fecha)
    JOIN GROUP_BY_GAMBETTA.BI_Dim_Rango_Etario_Cliente rec ON
        (
            DATEDIFF(YEAR,c.fecha_nacimiento,v.fecha)
            -
            CASE
                WHEN DATEADD
                (
                  YEAR,
                  DATEDIFF(YEAR,c.fecha_nacimiento,v.fecha),
                  c.fecha_nacimiento
                ) > v.fecha
                THEN 1
                ELSE 0
            END
        )
        BETWEEN rec.edad_min AND rec.edad_max
    LEFT JOIN GROUP_BY_GAMBETTA.Venta_Propuesta vp ON vp.nro_venta = v.nro_venta
    GROUP BY dt.id_tiempo, rec.id_rango_etario_cliente, v.id_canal_venta,
        CASE
            WHEN vp.nro_propuesta IS NULL THEN 1
            ELSE 2
        END
END
GO





-- Poblar BI_Fact_Solicitud

CREATE PROCEDURE GROUP_BY_GAMBETTA.migrar_fact_solicitud
AS
BEGIN
    INSERT INTO GROUP_BY_GAMBETTA.BI_Fact_Solicitud
    (id_tiempo, id_rango_etario_cliente,cant_solicitudes,total_dias_anticipacion)
    SELECT
        dt.id_tiempo,
        rec.id_rango_etario_cliente,
        COUNT(*) AS cant_solicitudes,
        SUM(DATEDIFF(DAY,s.fecha_solicitud,s.fecha_inicio_tentativa)) AS total_dias_anticipacion
    FROM GROUP_BY_GAMBETTA.Solicitud s
    JOIN GROUP_BY_GAMBETTA.Cliente c ON c.nro_cliente = s.nro_cliente
    JOIN GROUP_BY_GAMBETTA.BI_Dim_Tiempo dt ON dt.anio = YEAR(s.fecha_solicitud) AND dt.mes = MONTH(s.fecha_solicitud)
    JOIN GROUP_BY_GAMBETTA.BI_Dim_Rango_Etario_Cliente rec
        ON (
            DATEDIFF(YEAR,c.fecha_nacimiento,s.fecha_solicitud)
            -
            CASE
                WHEN DATEADD(
                    YEAR,
                    DATEDIFF(YEAR,c.fecha_nacimiento,s.fecha_solicitud),
                    c.fecha_nacimiento
                ) > s.fecha_solicitud
                THEN 1
                ELSE 0
            END
        )
        BETWEEN rec.edad_min AND rec.edad_max
    GROUP BY dt.id_tiempo, rec.id_rango_etario_cliente
END
GO

-- Poblar BI_Fact_Propuesta

CREATE PROCEDURE GROUP_BY_GAMBETTA.migrar_fact_propuesta
AS
BEGIN
    INSERT INTO GROUP_BY_GAMBETTA.BI_Fact_Propuesta
    (
        id_tiempo_emision,
        id_tiempo_solicitud,
        id_tiempo_inicio_viaje,
        id_rango_etario_agente,
        id_estado_propuesta,
        cant_propuestas,
        total_importe,
        total_dias_respuesta,
        total_desvio_presupuesto
    )
    SELECT
        dte.id_tiempo,
        dts.id_tiempo,
        dti.id_tiempo,
        rea.id_rango_etario_agente,
        ep.id_estado,
        COUNT(*) AS cant_propuestas,
        SUM(p.importe_total) AS total_importe,
        SUM(DATEDIFF(DAY,s.fecha_solicitud,p.fecha_emision)) AS total_dias_respuesta,
        SUM(ABS(p.importe_total - s.presupuesto_estimado)) AS total_desvio_presupuesto
    FROM GROUP_BY_GAMBETTA.Propuesta p
    JOIN GROUP_BY_GAMBETTA.Solicitud s ON s.nro_solicitud = p.nro_solicitud
    JOIN GROUP_BY_GAMBETTA.Estado e ON e.nro_estado = p.nro_estado
    JOIN GROUP_BY_GAMBETTA.Agente a ON a.agente_legajo = p.agente_legajo
    JOIN GROUP_BY_GAMBETTA.BI_Dim_Tiempo dte ON dte.anio = YEAR(p.fecha_emision) AND dte.mes = MONTH(p.fecha_emision)
    JOIN GROUP_BY_GAMBETTA.BI_Dim_Tiempo dts ON dts.anio = YEAR(s.fecha_solicitud) AND dts.mes = MONTH(s.fecha_solicitud)
    JOIN GROUP_BY_GAMBETTA.BI_Dim_Tiempo dti ON dti.mes = MONTH(p.fecha_desde) and dti.anio = YEAR(p.fecha_desde)
    JOIN GROUP_BY_GAMBETTA.BI_Dim_Rango_Etario_Agente rea
        ON (
            DATEDIFF(YEAR,a.fecha_nacimiento,p.fecha_emision)
            -
            CASE
                WHEN DATEADD(
                    YEAR,
                    DATEDIFF(YEAR,a.fecha_nacimiento,p.fecha_emision),
                    a.fecha_nacimiento
                ) > p.fecha_emision
                THEN 1
                ELSE 0
            END
        )
        BETWEEN rea.edad_min AND rea.edad_max
    JOIN GROUP_BY_GAMBETTA.BI_Dim_Estado_Propuesta ep ON ep.descripcion = e.estado
    GROUP BY dte.id_tiempo,dti.id_tiempo, rea.id_rango_etario_agente, ep.id_estado,dts.id_tiempo
END
GO

-- Poblar BI_Fact_Encuesta

CREATE PROCEDURE GROUP_BY_GAMBETTA.migrar_fact_encuesta
AS
BEGIN
    INSERT INTO GROUP_BY_GAMBETTA.BI_Fact_Encuesta
    (id_tiempo,id_aspecto,id_rango_etario_agente,cant_respuestas,total_puntaje)
    SELECT
        dt.id_tiempo,
        de.cod_aspecto,
        rea.id_rango_etario_agente,
        COUNT(*) AS cant_respuestas,
        SUM(de.puntaje) AS total_puntaje
    FROM GROUP_BY_GAMBETTA.Encuesta e
    JOIN GROUP_BY_GAMBETTA.Detalle_Encuesta de ON de.codigo_encuesta = e.codigo_encuesta
    JOIN GROUP_BY_GAMBETTA.Agente a ON a.agente_legajo=e.agente_legajo
    JOIN GROUP_BY_GAMBETTA.BI_Dim_Tiempo dt ON dt.anio=YEAR(e.fecha_encuesta) AND dt.mes=MONTH(e.fecha_encuesta)
    JOIN GROUP_BY_GAMBETTA.BI_Dim_Rango_Etario_Agente rea
        ON (
            DATEDIFF(YEAR,a.fecha_nacimiento,e.fecha_encuesta)
            -
            CASE
                WHEN DATEADD(YEAR,DATEDIFF(YEAR,a.fecha_nacimiento,e.fecha_encuesta),a.fecha_nacimiento)>e.fecha_encuesta
                THEN 1
                ELSE 0
            END
        )
        BETWEEN rea.edad_min AND rea.edad_max
    GROUP BY
        dt.id_tiempo,
        de.cod_aspecto,
        rea.id_rango_etario_agente
END
GO


-- EXECS DE MIGRACION DE DIMENSIONES

EXEC GROUP_BY_GAMBETTA.cargar_dimension_tiempo
EXEC GROUP_BY_GAMBETTA.cargar_dimension_re_cliente
EXEC GROUP_BY_GAMBETTA.cargar_dimension_re_agente
EXEC GROUP_BY_GAMBETTA.cargar_dimension_canal_venta
EXEC GROUP_BY_GAMBETTA.cargar_dimension_aspecto
EXEC GROUP_BY_GAMBETTA.cargar_dimension_tipo_servicio
EXEC GROUP_BY_GAMBETTA.cargar_dimension_estado_propuesta

-- EXECS DE MIGRACION DE HECHOS
EXEC GROUP_BY_GAMBETTA.migrar_fact_venta
EXEC GROUP_BY_GAMBETTA.migrar_fact_solicitud
EXEC GROUP_BY_GAMBETTA.migrar_fact_propuesta
EXEC GROUP_BY_GAMBETTA.migrar_fact_encuesta
GO
-- SECCION 5: VISTAS

-- Vista 1: Ticket promedio 

CREATE VIEW GROUP_BY_GAMBETTA.BI_VW_Ticket_Promedio AS
SELECT t.anio, t.mes, rec.descripcion AS rango_etario_cliente, cv.nombre_canal AS canal_venta, SUM(fv.total_facturacion)/SUM(fv.cant_ventas) AS ticket_promedio
FROM GROUP_BY_GAMBETTA.BI_Fact_Venta fv
JOIN GROUP_BY_GAMBETTA.BI_Dim_Tiempo t ON t.id_tiempo = fv.id_tiempo
JOIN GROUP_BY_GAMBETTA.BI_Dim_Rango_Etario_Cliente rec ON rec.id_rango_etario_cliente = fv.id_rango_etario_cliente
JOIN GROUP_BY_GAMBETTA.BI_Dim_Canal_Venta cv ON cv.id_canal_venta = fv.id_canal_venta
GROUP BY t.anio, t.mes, rec.descripcion, cv.nombre_canal
GO

-- Vista 2: Distribucion de facturacion 

CREATE VIEW GROUP_BY_GAMBETTA.BI_VW_Distribucion_Facturacion AS
SELECT
    t.anio,
    t.cuatrimestre,
    ts.descripcion AS tipo_servicio,
    SUM(fv.total_facturacion)*100/tot.total_facturacion AS porcentaje_facturacion
FROM GROUP_BY_GAMBETTA.BI_Fact_Venta fv
JOIN GROUP_BY_GAMBETTA.BI_Dim_Tiempo t ON t.id_tiempo = fv.id_tiempo
JOIN GROUP_BY_GAMBETTA.BI_Dim_Tipo_Servicio ts ON ts.id_tipo_servicio = fv.id_tipo_servicio
JOIN (SELECT t.anio,t.cuatrimestre, SUM(total_facturacion) AS total_facturacion FROM GROUP_BY_GAMBETTA.BI_Fact_Venta fv
JOIN GROUP_BY_GAMBETTA.BI_Dim_Tiempo t ON t.id_tiempo = fv.id_tiempo
GROUP BY t.anio,t.cuatrimestre) tot ON tot.anio = t.anio AND t.cuatrimestre = tot.cuatrimestre
GROUP BY t.anio, t.cuatrimestre, ts.descripcion, tot.total_facturacion
GO

-- Vista 3: Ranking de solicitudes por temporada/anio y rango etario de cliente.

CREATE VIEW GROUP_BY_GAMBETTA.BI_VW_Ranking_Solicitudes_Temporada
AS
SELECT t.anio, t.temporada AS temporada, rec.descripcion AS rango_etario_cliente, SUM(fs.cant_solicitudes) AS cantidad_solicitudes
FROM GROUP_BY_GAMBETTA.BI_Fact_Solicitud fs
JOIN GROUP_BY_GAMBETTA.BI_Dim_Tiempo t ON t.id_tiempo = fs.id_tiempo
JOIN GROUP_BY_GAMBETTA.BI_Dim_Rango_Etario_Cliente rec ON rec.id_rango_etario_cliente = fs.id_rango_etario_cliente
GROUP BY t.anio, t.temporada, rec.descripcion
GO

-- Vista 4: Anticipacion promedio de solicitudes.


CREATE VIEW GROUP_BY_GAMBETTA.BI_VW_Anticipacion_Promedio_Solicitudes
AS
SELECT t.anio, t.cuatrimestre, rec.descripcion AS rango_etario_cliente,
    CAST(
        SUM(fs.total_dias_anticipacion) * 1.0
        /
        SUM(fs.cant_solicitudes)
        AS DECIMAL(18,2)
    ) AS promedio_dias_anticipacion
FROM GROUP_BY_GAMBETTA.BI_Fact_Solicitud fs
JOIN GROUP_BY_GAMBETTA.BI_Dim_Tiempo t ON t.id_tiempo = fs.id_tiempo
JOIN GROUP_BY_GAMBETTA.BI_Dim_Rango_Etario_Cliente rec ON rec.id_rango_etario_cliente = fs.id_rango_etario_cliente
GROUP BY t.anio, t.cuatrimestre, rec.descripcion
GO

-- Vista 5: Tasa de aceptacion de propuestas por cuatrimestre.


CREATE VIEW GROUP_BY_GAMBETTA.BI_VW_Tasa_Aceptacion_Propuestas
AS
SELECT
    t.anio,
    t.cuatrimestre,
    SUM(CASE WHEN ep.descripcion = 'Aceptada' THEN fp.cant_propuestas ELSE 0 END) * 100.0 /
    SUM(fp.cant_propuestas) AS tasa_aceptacion
FROM GROUP_BY_GAMBETTA.BI_Fact_Propuesta fp
JOIN GROUP_BY_GAMBETTA.BI_Dim_Tiempo t ON t.id_tiempo = fp.id_tiempo_emision
JOIN GROUP_BY_GAMBETTA.BI_Dim_Estado_Propuesta ep ON ep.id_estado = fp.id_estado_propuesta
GROUP BY t.anio,t.cuatrimestre
GO

-- Vista 6: Cotizacion promedio por temporada/anio.

CREATE VIEW GROUP_BY_GAMBETTA.BI_VW_Cotizacion_Promedio_Temporada
AS
SELECT
    dti.anio,
    dti.temporada AS temporada,
    SUM(fp.total_importe) / SUM(fp.cant_propuestas) AS cotizacion_promedio
FROM GROUP_BY_GAMBETTA.BI_Fact_Propuesta fp
JOIN GROUP_BY_GAMBETTA.BI_Dim_Tiempo dti ON dti.id_tiempo = fp.id_tiempo_inicio_viaje
GROUP BY dti.anio,dti.temporada
GO
-- Vista 7: Tiempo promedio de respuesta entre fecha_solicitud y fecha_emision propuesta.

CREATE VIEW GROUP_BY_GAMBETTA.BI_VW_Tiempo_Promedio_Respuesta
AS
SELECT
    t.anio,
    t.mes,
    rea.descripcion AS rango_etario_agente,
    CAST(SUM(fp.total_dias_respuesta) * 1.0 / SUM(fp.cant_propuestas) AS DECIMAL(18,2)) AS tiempo_promedio_respuesta
FROM GROUP_BY_GAMBETTA.BI_Fact_Propuesta fp
JOIN GROUP_BY_GAMBETTA.BI_Dim_Tiempo t ON t.id_tiempo = fp.id_tiempo_solicitud
JOIN GROUP_BY_GAMBETTA.BI_Dim_Rango_Etario_Agente rea ON rea.id_rango_etario_agente = fp.id_rango_etario_agente
GROUP BY t.anio,t.mes,rea.descripcion
GO

-- Vista 8: Desvio promedio de presupuesto.
-- Diferencia entre presupuesto_estimado (solicitud) e importe_total (propuesta).
-- JOIN entre BI_Fact_Propuesta y BI_Fact_Solicitud por nro_solicitud.

CREATE VIEW GROUP_BY_GAMBETTA.BI_VW_Desvio_Presupuesto
AS
SELECT
    CAST(SUM(fp.total_desvio_presupuesto) / SUM(fp.cant_propuestas) AS DECIMAL(18,2))
        AS desvio_promedio
FROM GROUP_BY_GAMBETTA.BI_Fact_Propuesta fp
GO

-- Vista 9: Ranking de aspectos mejor y peor valorados por cuatrimestre.
-- Promedio de puntaje por aspecto y cuatrimestre.

CREATE VIEW GROUP_BY_GAMBETTA.BI_VW_Ranking_Aspectos_Valorados
AS
SELECT
    t.anio,
    t.cuatrimestre,
    a.aspecto AS aspecto,
    CAST(SUM(fe.total_puntaje)*1.0/SUM(fe.cant_respuestas) AS DECIMAL(18,2)) AS puntaje_promedio
FROM GROUP_BY_GAMBETTA.BI_Fact_Encuesta fe
JOIN GROUP_BY_GAMBETTA.BI_Dim_Tiempo t ON t.id_tiempo=fe.id_tiempo
JOIN GROUP_BY_GAMBETTA.BI_Dim_Aspecto a ON a.id_aspecto=fe.id_aspecto
GROUP BY t.anio,t.cuatrimestre,a.aspecto
GO

-- Vista 10: Satisfaccion promedio por agente, segmentado por rango etario del agente y mes.

CREATE VIEW GROUP_BY_GAMBETTA.BI_VW_Satisfaccion_Promedio_Agente
AS
SELECT
    t.anio,
    t.mes,
    rea.descripcion AS rango_etario_agente,
    CAST(SUM(fe.total_puntaje)*1.0/SUM(fe.cant_respuestas) AS DECIMAL(18,2)) AS satisfaccion_promedio
FROM GROUP_BY_GAMBETTA.BI_Fact_Encuesta fe
JOIN GROUP_BY_GAMBETTA.BI_Dim_Tiempo t ON t.id_tiempo=fe.id_tiempo
JOIN GROUP_BY_GAMBETTA.BI_Dim_Rango_Etario_Agente rea ON rea.id_rango_etario_agente=fe.id_rango_etario_agente
GROUP BY t.anio,t.mes,rea.descripcion
GO

--SELECTS DE DIMENSIONES


/*SELECT * FROM GROUP_BY_GAMBETTA.BI_Dim_Tiempo;

SELECT * FROM GROUP_BY_GAMBETTA.BI_Dim_Rango_Etario_Cliente;

SELECT * FROM GROUP_BY_GAMBETTA.BI_Dim_Rango_Etario_Agente;

SELECT * FROM GROUP_BY_GAMBETTA.BI_Dim_Tipo_Servicio;

SELECT * FROM GROUP_BY_GAMBETTA.BI_Dim_Canal_Venta;

SELECT * FROM GROUP_BY_GAMBETTA.BI_Dim_Estado_Propuesta;

SELECT * FROM GROUP_BY_GAMBETTA.BI_Dim_Aspecto;*/

--SELECTS DE HECHOS

/*SELECT * FROM GROUP_BY_GAMBETTA.BI_Fact_Venta;

SELECT * FROM GROUP_BY_GAMBETTA.BI_Fact_Solicitud;

SELECT * FROM GROUP_BY_GAMBETTA.BI_Fact_Propuesta;

SELECT * FROM GROUP_BY_GAMBETTA.BI_Fact_Encuesta*/


--SELECTS DE VIEWS

/*SELECT * FROM GROUP_BY_GAMBETTA.BI_VW_Ticket_Promedio

SELECT * FROM GROUP_BY_GAMBETTA.BI_VW_Distribucion_Facturacion

SELECT * FROM GROUP_BY_GAMBETTA.BI_VW_Ranking_Solicitudes_Temporada

SELECT * FROM GROUP_BY_GAMBETTA.BI_VW_Anticipacion_Promedio_Solicitudes

SELECT * FROM GROUP_BY_GAMBETTA.BI_VW_Tasa_Aceptacion_Propuestas

SELECT * FROM GROUP_BY_GAMBETTA.BI_VW_Cotizacion_Promedio_Temporada

SELECT * FROM GROUP_BY_GAMBETTA.BI_VW_Tiempo_Promedio_Respuesta

SELECT * FROM GROUP_BY_GAMBETTA.BI_VW_Desvio_Presupuesto

SELECT * FROM GROUP_BY_GAMBETTA.BI_VW_Ranking_Aspectos_Valorados

SELECT * FROM GROUP_BY_GAMBETTA.BI_VW_Satisfaccion_Promedio_Agente*/
