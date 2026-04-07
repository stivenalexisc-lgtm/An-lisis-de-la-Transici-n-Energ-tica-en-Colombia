-- ============================================================
--  PROYECTO FINAL: TRANSICIÓN ENERGÉTICA EN COLOMBIA
--  Base de datos: energia_colombia
--  Motor: MySQL 8.0+
--  Equipo: Talento Tech / Universidad de Caldas
-- ============================================================

CREATE DATABASE IF NOT EXISTS energia_colombia
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE energia_colombia;

-- ============================================================
-- TABLA 1: DEPARTAMENTOS
-- ============================================================
DROP TABLE IF EXISTS departamentos;
CREATE TABLE departamentos (
  id_departamento   INT          AUTO_INCREMENT PRIMARY KEY,
  nombre            VARCHAR(80)  NOT NULL,
  region            VARCHAR(50)  NOT NULL,
  area_km2          DECIMAL(10,2),
  poblacion_2023    INT,
  pib_per_capita_usd DECIMAL(10,2),
  UNIQUE (nombre)
) ENGINE=InnoDB;

INSERT INTO departamentos (nombre, region, area_km2, poblacion_2023, pib_per_capita_usd) VALUES
  ('Antioquia',        'Andina',      63612.00,  6729000, 7800.00),
  ('Cundinamarca',     'Andina',      24210.00,  3200000, 8200.00),
  ('Caldas',           'Andina',       7888.00,   997000, 5400.00),
  ('Risaralda',        'Andina',       3592.00,   985000, 5800.00),
  ('Valle del Cauca',  'Pacífica',    22140.00,  4800000, 7100.00),
  ('Bolívar',          'Caribe',      25978.00,  2300000, 4900.00),
  ('Atlántico',        'Caribe',       3388.00,  2700000, 6300.00),
  ('La Guajira',       'Caribe',      20848.00,   950000, 3800.00),
  ('Cesar',            'Caribe',      22905.00,  1150000, 4200.00),
  ('Meta',             'Orinoquía',   85635.00,  1100000, 6700.00),
  ('Boyacá',           'Andina',      23189.00,  1270000, 4600.00),
  ('Nariño',           'Pacífica',    33268.00,  1780000, 3500.00),
  ('Huila',            'Andina',      19890.00,  1170000, 4800.00),
  ('Córdoba',          'Caribe',      25020.00,  1850000, 3700.00),
  ('Santander',        'Andina',      30537.00,  2200000, 7200.00);

-- ============================================================
-- TABLA 2: FUENTES DE ENERGÍA
-- ============================================================
DROP TABLE IF EXISTS fuentes_energia;
CREATE TABLE fuentes_energia (
  id_fuente   INT          AUTO_INCREMENT PRIMARY KEY,
  nombre      VARCHAR(60)  NOT NULL,
  tipo        ENUM('Renovable','No Renovable','Transición') NOT NULL,
  descripcion TEXT,
  UNIQUE (nombre)
) ENGINE=InnoDB;

INSERT INTO fuentes_energia (nombre, tipo, descripcion) VALUES
  ('Hidroeléctrica',  'Renovable',     'Generación a partir de caída y flujo de agua'),
  ('Solar Fotovoltaica','Renovable',   'Paneles que convierten radiación solar en electricidad'),
  ('Eólica',          'Renovable',     'Turbinas movidas por viento'),
  ('Biomasa',         'Renovable',     'Combustión de materia orgánica y residuos agrícolas'),
  ('Geotérmica',      'Renovable',     'Calor del subsuelo terrestre'),
  ('Gas Natural',     'No Renovable',  'Combustible fósil de menor huella que carbón y petróleo'),
  ('Carbón',          'No Renovable',  'Combustible sólido de alta densidad energética'),
  ('Petróleo/Diesel', 'No Renovable',  'Derivados del petróleo para generación eléctrica'),
  ('Hidrógeno Verde', 'Transición',    'H₂ producido mediante electrólisis con energía renovable'),
  ('Pequeñas Hidroeléctricas','Renovable','PCH con capacidad menor a 20 MW');

-- ============================================================
-- TABLA 3: PLANTAS DE GENERACIÓN
-- ============================================================
DROP TABLE IF EXISTS plantas;
CREATE TABLE plantas (
  id_planta         INT            AUTO_INCREMENT PRIMARY KEY,
  nombre            VARCHAR(100)   NOT NULL,
  id_departamento   INT            NOT NULL,
  id_fuente         INT            NOT NULL,
  capacidad_mw      DECIMAL(10,2)  NOT NULL COMMENT 'Capacidad instalada en MW',
  año_entrada       YEAR,
  estado            ENUM('Operativa','En construcción','Proyectada','Suspendida') DEFAULT 'Operativa',
  empresa_operadora VARCHAR(100),
  latitud           DECIMAL(9,6),
  longitud          DECIMAL(9,6),
  FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento),
  FOREIGN KEY (id_fuente)       REFERENCES fuentes_energia(id_fuente)
) ENGINE=InnoDB;

INSERT INTO plantas (nombre, id_departamento, id_fuente, capacidad_mw, año_entrada, estado, empresa_operadora, latitud, longitud) VALUES
  ('Hidroituango',           1,  1,  2400.00, 2022, 'Operativa',       'EPM',             7.1306,  -75.7067),
  ('Porce III',              1,  1,   660.00, 2010, 'Operativa',       'EPM',             7.0400,  -75.1800),
  ('Chivor',                 2,  1,  1000.00, 1977, 'Operativa',       'AES Chivor',      5.0500,  -73.2300),
  ('El Quimbo',              13, 1,   400.00, 2015, 'Operativa',       'Enel',            1.8000,  -75.6500),
  ('Betania',                13, 1,   540.00, 1987, 'Operativa',       'Emgesa',          2.3200,  -75.5900),
  ('Sogamoso',               15, 1,   820.00, 2014, 'Operativa',       'Isagen',          6.8700,  -73.4800),
  ('Miel I',                 3,  1,   396.00, 2002, 'Operativa',       'Isagen',          5.5800,  -74.8700),
  ('Termocol',               5,  7,   330.00, 1998, 'Operativa',       'Termocol S.A.',   3.8200,  -76.5000),
  ('Termosierra',            9,  6,   460.00, 2006, 'Operativa',       'Cerro Matoso',    9.9800,  -73.5200),
  ('Parque Solar La Loma',   9,  2,   202.00, 2021, 'Operativa',       'Celsia',         10.1800,  -73.6100),
  ('Guajira I (Eólica)',     8,  3,   300.00, 2022, 'Operativa',       'Enel Green Power', 11.5000, -72.9000),
  ('Jepírachi',              8,  3,    19.50, 2004, 'Operativa',       'EPM',            11.7800,  -72.4500),
  ('Parque Solar Acacías',   10, 2,   100.00, 2023, 'Operativa',       'Celsia',          3.9900,  -73.7700),
  ('Alpha Solar',            6,  2,    50.00, 2023, 'Operativa',       'Enel',            8.9000,  -74.5000),
  ('Biomasa Sucromiles',     5,  4,    25.00, 2018, 'Operativa',       'Manuelita',       3.5500,  -76.3200),
  ('PCH Morro Azul',         4,  10,   19.80, 2015, 'Operativa',       'Chec',            5.1700,  -75.9800),
  ('PCH Consota',            4,  10,   18.50, 2012, 'Operativa',       'Chec',            4.8100,  -75.7600),
  ('H2 Verde Piloto Barranquilla', 7, 9, 0.50, 2024, 'En construcción','AirProducts',   10.9878,  -74.7889),
  ('Parque Eólico Alta Guajira',8,  3,  200.00, 2025, 'En construcción','Enel Green Power',11.8500,-72.5000),
  ('Solar Sabana Centro',    2,  2,   150.00, 2025, 'Proyectada',      'Celsia',          5.0000,  -74.0000);

-- ============================================================
-- TABLA 4: GENERACIÓN MENSUAL (GWh)
-- ============================================================
DROP TABLE IF EXISTS generacion_mensual;
CREATE TABLE generacion_mensual (
  id_gen        BIGINT  AUTO_INCREMENT PRIMARY KEY,
  id_planta     INT     NOT NULL,
  año           YEAR    NOT NULL,
  mes           TINYINT NOT NULL CHECK (mes BETWEEN 1 AND 12),
  generacion_gwh DECIMAL(10,3) NOT NULL,
  factor_capacidad DECIMAL(5,4) COMMENT '0.0 a 1.0',
  FOREIGN KEY (id_planta) REFERENCES plantas(id_planta)
) ENGINE=InnoDB;

-- Insertar datos de generación 2020-2024 (resumen anual por planta)
INSERT INTO generacion_mensual (id_planta, año, mes, generacion_gwh, factor_capacidad) VALUES
-- Hidroituango 2022-2024 (opera parcialmente desde 2022)
(1,2022,1,350.00,0.82),(1,2022,4,290.00,0.68),(1,2022,7,380.00,0.89),(1,2022,10,370.00,0.87),
(1,2023,1,560.00,0.79),(1,2023,4,510.00,0.72),(1,2023,7,630.00,0.89),(1,2023,10,610.00,0.86),
(1,2024,1,580.00,0.82),(1,2024,4,530.00,0.74),(1,2024,7,650.00,0.92),(1,2024,10,620.00,0.87),
-- Chivor 2020-2024
(3,2020,1,280.00,0.38),(3,2020,4,320.00,0.43),(3,2020,7,350.00,0.48),(3,2020,10,370.00,0.50),
(3,2021,1,290.00,0.39),(3,2021,4,330.00,0.44),(3,2021,7,360.00,0.49),(3,2021,10,380.00,0.51),
(3,2022,1,295.00,0.40),(3,2022,4,335.00,0.45),(3,2022,7,365.00,0.50),(3,2022,10,385.00,0.52),
(3,2023,1,300.00,0.40),(3,2023,4,340.00,0.46),(3,2023,7,370.00,0.50),(3,2023,10,390.00,0.53),
(3,2024,1,305.00,0.41),(3,2024,4,345.00,0.47),(3,2024,7,375.00,0.51),(3,2024,10,395.00,0.53),
-- Solar La Loma 2021-2024
(10,2021,1,20.00,0.14),(10,2021,4,24.00,0.17),(10,2021,7,22.00,0.15),(10,2021,10,21.00,0.15),
(10,2022,1,25.00,0.18),(10,2022,4,29.00,0.20),(10,2022,7,27.00,0.19),(10,2022,10,26.00,0.18),
(10,2023,1,30.00,0.21),(10,2023,4,34.00,0.24),(10,2023,7,32.00,0.22),(10,2023,10,31.00,0.22),
(10,2024,1,35.00,0.24),(10,2024,4,39.00,0.27),(10,2024,7,37.00,0.26),(10,2024,10,36.00,0.25),
-- Guajira Eólica 2022-2024
(11,2022,1,45.00,0.21),(11,2022,4,55.00,0.25),(11,2022,7,62.00,0.29),(11,2022,10,48.00,0.22),
(11,2023,1,50.00,0.23),(11,2023,4,61.00,0.28),(11,2023,7,69.00,0.32),(11,2023,10,53.00,0.25),
(11,2024,1,55.00,0.26),(11,2024,4,67.00,0.31),(11,2024,7,76.00,0.35),(11,2024,10,58.00,0.27);

-- ============================================================
-- TABLA 5: INDICADORES ENERGÉTICOS POR DEPARTAMENTO Y AÑO
-- ============================================================
DROP TABLE IF EXISTS indicadores_energia;
CREATE TABLE indicadores_energia (
  id_indicador         INT          AUTO_INCREMENT PRIMARY KEY,
  id_departamento      INT          NOT NULL,
  año                  YEAR         NOT NULL,
  consumo_gwh          DECIMAL(12,3) NOT NULL  COMMENT 'Consumo total eléctrico',
  cobertura_pct        DECIMAL(5,2)            COMMENT '% hogares con acceso eléctrico',
  precio_kwh_cop       DECIMAL(8,2)            COMMENT 'Precio promedio kWh en pesos',
  emision_tco2_gwh     DECIMAL(8,3)            COMMENT 'tonCO2 por GWh generado',
  inversion_mmusd      DECIMAL(10,2)           COMMENT 'Inversión en energías limpias (MMUSD)',
  FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento)
) ENGINE=InnoDB;

INSERT INTO indicadores_energia (id_departamento, año, consumo_gwh, cobertura_pct, precio_kwh_cop, emision_tco2_gwh, inversion_mmusd) VALUES
-- Antioquia
(1, 2020, 14200.0, 97.5, 480.00, 82.4, 120.5),
(1, 2021, 14600.0, 97.8, 495.00, 80.1, 145.2),
(1, 2022, 15100.0, 98.1, 520.00, 75.3, 180.0),
(1, 2023, 15500.0, 98.4, 540.00, 70.2, 220.0),
(1, 2024, 16000.0, 98.7, 558.00, 65.8, 280.0),
-- Caldas
(3, 2020, 2100.0, 96.2, 510.00, 45.2, 18.5),
(3, 2021, 2150.0, 96.5, 525.00, 43.8, 22.0),
(3, 2022, 2220.0, 96.9, 548.00, 41.0, 28.5),
(3, 2023, 2290.0, 97.2, 565.00, 38.5, 35.0),
(3, 2024, 2360.0, 97.5, 580.00, 36.1, 42.0),
-- La Guajira
(8, 2020, 980.0, 78.3, 380.00, 210.5, 45.0),
(8, 2021, 1020.0, 79.5, 390.00, 195.0, 68.0),
(8, 2022, 1080.0, 81.2, 405.00, 170.2, 120.0),
(8, 2023, 1150.0, 83.8, 420.00, 140.5, 185.0),
(8, 2024, 1230.0, 86.5, 438.00, 108.3, 250.0),
-- Atlántico
(7, 2020, 4200.0, 95.1, 420.00, 180.3, 30.0),
(7, 2021, 4350.0, 95.4, 435.00, 172.5, 38.0),
(7, 2022, 4510.0, 95.8, 455.00, 160.0, 55.0),
(7, 2023, 4680.0, 96.2, 472.00, 142.5, 80.0),
(7, 2024, 4850.0, 96.6, 490.00, 125.8, 110.0),
-- Valle del Cauca
(5, 2020, 9800.0, 97.8, 460.00, 95.5, 80.0),
(5, 2021, 10050.0, 98.0, 475.00, 91.2, 95.0),
(5, 2022, 10350.0, 98.3, 498.00, 85.8, 120.0),
(5, 2023, 10650.0, 98.5, 515.00, 80.3, 150.0),
(5, 2024, 10950.0, 98.7, 532.00, 75.1, 190.0);

-- ============================================================
-- TABLA 6: POLÍTICAS Y REGULACIONES
-- ============================================================
DROP TABLE IF EXISTS politicas;
CREATE TABLE politicas (
  id_politica   INT          AUTO_INCREMENT PRIMARY KEY,
  nombre        VARCHAR(150) NOT NULL,
  tipo          VARCHAR(60),
  año_promulga  YEAR,
  descripcion   TEXT,
  meta_2030     VARCHAR(200)
) ENGINE=InnoDB;

INSERT INTO politicas (nombre, tipo, año_promulga, descripcion, meta_2030) VALUES
  ('Ley 1715 de 2014','Ley Nacional',2014,'Regula la integración de energías renovables no convencionales al sistema energético nacional. Ofrece incentivos tributarios, arancelarios y contables.','Reducir 20% emisiones GEI respecto a línea base 2010'),
  ('Ley 2099 de 2021','Ley Nacional',2021,'Modifica y amplía la Ley 1715. Establece metas de transición energética y creación del Ministerio de Minas y Energía como ente rector.','11.2 GW de FNCER instalados para 2030'),
  ('CONPES 4075 de 2022','Política Pública',2022,'Política de transición energética del Estado colombiano. Define hoja de ruta hacia carbono neutralidad.','Reducir 51% emisiones para 2030 vs escenario tendencial'),
  ('Subasta FNCER 2021','Mecanismo de Mercado',2021,'Primera subasta de largo plazo de energías renovables no convencionales: contratos PPA por 15 años.','Contratar 1.800 MW de nueva capacidad renovable'),
  ('Plan Energía 2050','Planificación',2020,'Visión de largo plazo del sector energético colombiano hacia la descarbonización y universalización del servicio.','100% de cobertura eléctrica y carbono neutralidad 2050'),
  ('Resolución CREG 174/2021','Regulación',2021,'Regula la participación de generadores de FNCER en el Mercado de Energía Mayorista (MEM).','Simplificar trámites para proyectos < 5 MW'),
  ('Decreto 829 de 2023','Decreto Ejecutivo',2023,'Establece incentivos a la autogeneración distribuida y comunidades energéticas.','100.000 nuevos prosumidores para 2026');

-- ============================================================
-- CONSULTAS ANALÍTICAS
-- ============================================================

-- CONSULTA 1: Capacidad instalada total por tipo de fuente
SELECT 
  fe.tipo,
  fe.nombre AS fuente,
  COUNT(p.id_planta)           AS num_plantas,
  ROUND(SUM(p.capacidad_mw),2) AS capacidad_total_mw,
  ROUND(SUM(p.capacidad_mw) * 100.0 / 
    (SELECT SUM(capacidad_mw) FROM plantas WHERE estado = 'Operativa'), 2) AS pct_total
FROM plantas p
JOIN fuentes_energia fe ON p.id_fuente = fe.id_fuente
WHERE p.estado = 'Operativa'
GROUP BY fe.tipo, fe.nombre
ORDER BY capacidad_total_mw DESC;

-- CONSULTA 2: Evolución de inversión en energías limpias (top 5 departamentos)
SELECT 
  d.nombre AS departamento,
  ie.año,
  ie.inversion_mmusd,
  ROUND(ie.inversion_mmusd - LAG(ie.inversion_mmusd) 
    OVER (PARTITION BY d.id_departamento ORDER BY ie.año), 2) AS crecimiento_anual_usd
FROM indicadores_energia ie
JOIN departamentos d ON ie.id_departamento = d.id_departamento
ORDER BY d.nombre, ie.año;

-- CONSULTA 3: Factor de reducción de emisiones por departamento 2020→2024
SELECT 
  d.nombre AS departamento,
  MAX(CASE WHEN ie.año = 2020 THEN ie.emision_tco2_gwh END) AS emision_2020,
  MAX(CASE WHEN ie.año = 2024 THEN ie.emision_tco2_gwh END) AS emision_2024,
  ROUND(
    (MAX(CASE WHEN ie.año = 2020 THEN ie.emision_tco2_gwh END) -
     MAX(CASE WHEN ie.año = 2024 THEN ie.emision_tco2_gwh END)) * 100.0 /
     MAX(CASE WHEN ie.año = 2020 THEN ie.emision_tco2_gwh END), 2
  ) AS reduccion_pct
FROM indicadores_energia ie
JOIN departamentos d ON ie.id_departamento = d.id_departamento
GROUP BY d.nombre
ORDER BY reduccion_pct DESC;

-- CONSULTA 4: Generación total anual por tipo de fuente (GWh)
SELECT 
  fe.tipo,
  fe.nombre AS fuente,
  gm.año,
  ROUND(SUM(gm.generacion_gwh), 2) AS total_gwh,
  ROUND(AVG(gm.factor_capacidad), 4) AS factor_capacidad_prom
FROM generacion_mensual gm
JOIN plantas p ON gm.id_planta = p.id_planta
JOIN fuentes_energia fe ON p.id_fuente = fe.id_fuente
GROUP BY fe.tipo, fe.nombre, gm.año
ORDER BY gm.año, total_gwh DESC;

-- CONSULTA 5: Plantas con mayor generación acumulada (subquery)
SELECT 
  p.nombre AS planta,
  fe.nombre AS fuente,
  d.nombre AS departamento,
  p.capacidad_mw,
  total.gen_total_gwh
FROM plantas p
JOIN fuentes_energia fe ON p.id_fuente = fe.id_fuente
JOIN departamentos d    ON p.id_departamento = d.id_departamento
JOIN (
  SELECT id_planta, ROUND(SUM(generacion_gwh), 2) AS gen_total_gwh
  FROM generacion_mensual
  GROUP BY id_planta
) AS total ON total.id_planta = p.id_planta
ORDER BY total.gen_total_gwh DESC
LIMIT 10;

-- CONSULTA 6: Correlación cobertura eléctrica vs emisiones
SELECT 
  d.nombre,
  d.region,
  AVG(ie.cobertura_pct)     AS cobertura_prom,
  AVG(ie.emision_tco2_gwh)  AS emision_prom,
  AVG(ie.precio_kwh_cop)    AS precio_prom_cop
FROM indicadores_energia ie
JOIN departamentos d ON ie.id_departamento = d.id_departamento
GROUP BY d.nombre, d.region
ORDER BY cobertura_prom ASC;

-- CONSULTA 7: JOIN múltiple – Ranking regional de transición
SELECT 
  d.region,
  COUNT(DISTINCT p.id_planta)  AS plantas_renovables,
  ROUND(SUM(p.capacidad_mw),0) AS mw_renovable,
  ROUND(AVG(ie.inversion_mmusd),1) AS inversion_prom_mmusd,
  ROUND(AVG(ie.cobertura_pct),1)   AS cobertura_prom
FROM plantas p
JOIN fuentes_energia fe ON p.id_fuente = fe.id_fuente
JOIN departamentos d    ON p.id_departamento = d.id_departamento
LEFT JOIN indicadores_energia ie ON ie.id_departamento = d.id_departamento
WHERE fe.tipo = 'Renovable'
  AND p.estado IN ('Operativa','En construcción')
GROUP BY d.region
ORDER BY mw_renovable DESC;
