--Punto 1
-- Crar tabla producto
DROP TABLE producto;
CREATE TABLE producto(cod_producto NUMBER(1)PRIMARY KEY, nom_producto VARCHAR(30));
-- Crear tabla bodega
DROP TABLE bodega;
CREATE TABLE bodega(cod_bodega NUMBER(5)PRIMARY KEY, nom_bodega VARCHAR(30), ubicacion_x NUMBER(2) CHECK(ubicacion_x BETWEEN 1 and 99)
, ubicacion_y NUMBER(2) CHECK(ubicacion_y BETWEEN 1 and 99));
-- Crear tabla anidada pedido
DROP TYPE detalle_tipo FORCE;
CREATE OR REPLACE TYPE detalle_tipo
AS OBJECT( 
 cod_producto NUMBER(3), 
 cantidad NUMBER(10));
/

CREATE OR REPLACE TYPE nest_detalle AS TABLE OF detalle_tipo;
/

CREATE OR REPLACE TYPE pedido_type AS 
OBJECT(cod_bodega NUMBER(3), 
       fecha NUMBER(5),
       detalles nest_detalle);
/
DROP TABLE pedido;
CREATE TABLE pedido OF pedido_type
(cod_bodega, fecha PRIMARY KEY) 
NESTED TABLE detalle STORE AS store_detalle
((PRIMARY KEY(NESTED_TABLE_ID, cod_producto)));

