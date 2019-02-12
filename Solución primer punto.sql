--Punto 1
CREATE TABLE producto(cod_producto NUMBER(1)PRIMARY KEY, nom_producto VARCHAR(30));
CREATE TABLE bodega(cod_bodega NUMBER(5)PRIMARY KEY, nom_bodega VARCHAR(30), ubicacion_x NUMBER(2) CHECK(ubicacion_x BETWEEN 1 and 99)
, ubicacion_y NUMBER(2) CHECK(ubicacion_y BETWEEN 1 and 99));
DROP TYPE bodega