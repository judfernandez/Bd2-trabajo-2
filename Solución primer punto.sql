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
DROP TYPE nest_detalle FORCE;
CREATE OR REPLACE TYPE nest_detalle AS TABLE OF detalle_tipo;
/
DROP TYPE pedido_type FORCE;
CREATE OR REPLACE TYPE pedido_type AS 
OBJECT(cod_bodega NUMBER(3), 
       fecha NUMBER(5),
       detalles nest_detalle);
/
DROP TABLE pedido;
CREATE TABLE pedido OF pedido_type
NESTED TABLE detalles STORE AS pedido_tab
((PRIMARY KEY(NESTED_TABLE_ID, cod_producto)));


alter table pedido ADD PRIMARY KEY (cod_bodega, fecha);
alter table pedido ADD CONSTRAINT  fecha_positiva CHECK(fecha > 0);


--Crear foraneas de pedido y detalle

alter table pedido
  add constraint foranea_bodega
  foreign key (cod_bodega)
  references bodega (cod_bodega);


-- Crear tabla aidada registro

DROP TYPE inventario_tipo FORCE;
CREATE OR REPLACE TYPE inventario_tipo
AS OBJECT( 
 cod_producto NUMBER(3), 
 existencias NUMBER(10));
/
DROP TYPE nest_inventario FORCE;
CREATE OR REPLACE TYPE nest_inventario AS TABLE OF inventario_tipo;
/
DROP TYPE registro_type FORCE;
CREATE OR REPLACE TYPE registro_type AS 
OBJECT(cod_bodega NUMBER(3), 
       inventario nest_inventario);
/
DROP TABLE registro;
CREATE TABLE registro OF registro_type
(cod_bodega PRIMARY KEY) 
NESTED TABLE inventario STORE AS store_inventario
((PRIMARY KEY(NESTED_TABLE_ID, cod_producto)));

--Crear foraneas de registro e inventario

alter table registro
  add constraint foranea_rbodega
  foreign key (cod_bodega)
  references bodega (cod_bodega); 

--Código del trigguer 50%
  CREATE OR REPLACE TRIGGER llenado_registro 
  BEFORE INSERT ON pedido
  FOR EACH ROW 
  DECLARE
  validacion NUMBER := 0;
  bodega_null EXCEPTION;
  detalles_expected EXCEPTION;
  producto_unregister EXCEPTION; 

  BEGIN 
    SELECT count(*) INTO validacion FROM bodega WHERE cod_bodega = :NEW.cod_bodega;

      IF (validacion > 0) THEN
        IF(:NEW.detalles.COUNT>5)THEN
          RAISE detalles_expected;
        ELSE
          FOR i IN 1..:NEW.detalles.COUNT LOOP
                SELECT count(*) INTO validacion FROM producto WHERE cod_producto = :NEW.detalles(i).cod_producto;
                IF (validacion>0) THEN
                  IF(:NEW.detalles(i).cantidad<1 OR :NEW.detalles(i).cantidad>50)THEN
                      DBMS_OUTPUT.PUT_LINE('la cantidad de un detalle debe estar entre 1 y 50 unidades');
                      CONTINUE;
                  ELSE              
                    UPDATE TABLE(SELECT inventario
                                FROM registro r
                                WHERE r.cod_bodega=:NEW.cod_bodega)
                    SET existencias = existencias+:NEW.detalles(i).cantidad
                    WHERE cod_producto = :NEW.detalles(i).cod_producto;
                  END IF;
                ELSE                  
                   RAISE producto_unregister; 
                   CONTINUE;
                END IF;                
          END LOOP;	
        END IF;
              
    ELSE 
      RAISE bodega_null;
    END IF;
  EXCEPTION
  WHEN bodega_null THEN
    RAISE_APPLICATION_ERROR(-20505, '¡BODEGA INEXISTENTE!');	
  WHEN detalles_expected THEN
    RAISE_APPLICATION_ERROR(-20505, '¡MAXIMO 5 DETALLES POR PEDIDO!');
  WHEN producto_unregister THEN
    RAISE_APPLICATION_ERROR(-20505, '¡PRODUCTO INEXISTENTE!');
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('');
	
  END;
  /

-- Trigger para evitar 10 o más elementos en bodega

CREATE OR REPLACE TRIGGER limitar_bodegas 
BEFORE INSERT ON bodega
FOR EACH ROW
DECLARE
bodega_full EXCEPTION;
BEGIN
  IF ((SELECT count(* FROM bodega)) >= 10) THEN
    RAISE bodega_full;
  END IF;
  EXCEPTION
  WHEN bodega_full THEN
    RAISE_APPLICATION_ERROR(-20505, '¡DEPOSITO LLENO(NO SE PERMITEN MAS DE DIEZ BODEGAS)!');
END;  
/

-- Trigger para evitar 5 o más elementos en detalle.pedido

CREATE OR REPLACE TRIGGER limitar_detalle
BEFORE INSERT ON pedido
FOR EACH ROW
DECLARE
detalle_full EXCEPTION;
BEGIN
  IF ((TABLE(count(SELECT detalle 
                    FROM pedido 
                    WHERE cod_bodega = :NEW.cod_bodega, fecha = :NEW.fecha))) >= 5) THEN
    RAISE detalle_full;
  END IF;
  EXCEPTION
  WHEN detalle_full THEN
    RAISE_APPLICATION_ERROR(-20505, '¡BODEGA LLENA(NO SE PERMITEN MAS DE 5 ITEMS)!');
END;  
/


SELECT cod_bodega, t2. * FROM pedido t, TABLE(t.detalle) t2;


















































-- Lo guardo po si acaso equis dé
CREATE OR REPLACE TYPE detalles_sub
AS OBJECT( 
 cod_producto NUMBER(3), 
 cantidad NUMBER(10));
/

CREATE OR REPLACE TYPE detalles
AS VARRAY (5) of detalles_sub
/

CREATE TABLE pedido
(cod_bodega NUMBER(3),
 fecha NUMBER(5),
 detalle detalles);
/
