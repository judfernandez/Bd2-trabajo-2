
--trigger para control de insercion en pedidos: maximo numero de detalles, actualiza registros, control de cantidades
  CREATE OR REPLACE TRIGGER llenado_registro 
  BEFORE INSERT ON pedido
  FOR EACH ROW 
  DECLARE
  validacion NUMBER := 0;
  bodega_null EXCEPTION;
  detalles_expected EXCEPTION;
  producto_unregister EXCEPTION; 
  detalles_cantidad EXCEPTION;

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
                       RAISE detalles_cantidad;
                  ELSE              
                    UPDATE TABLE(SELECT inventario
                                FROM registro r
                                WHERE r.cod_bodega=:NEW.cod_bodega)
                    SET existencias = existencias+:NEW.detalles(i).cantidad
                    WHERE cod_producto = :NEW.detalles(i).cod_producto;
                  END IF;
                ELSE  
                   RAISE producto_unregister; 
                  
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
  WHEN detalles_cantidad THEN
    RAISE_APPLICATION_ERROR(-20505, '¡LOS DETALLES DEBEN ESTAR ENTRE 1 Y 50 UNIDADES');
  WHEN OTHERS THEN 
     RAISE_APPLICATION_ERROR(-20505,'HA OCURRIDO UN ERROR');	
  END;
  /

-- Trigger para asegurar maximo 10 bodegas y espaciadas 5 unidades
CREATE OR REPLACE TRIGGER bodegaBefore 
BEFORE INSERT ON bodega
FOR EACH ROW
DECLARE
bodega_full EXCEPTION;
espacio_wrong EXCEPTION;
validacion NUMBER:=0;
CURSOR espacios IS SELECT ubicacion_x, ubicacion_y FROM bodega;
BEGIN

  SELECT count(*) INTO validacion FROM bodega; 
  IF (validacion >= 10) THEN
    RAISE bodega_full; 
  ELSE
    FOR i IN espacios LOOP
      IF(SQRT((:NEW.ubicacion_x-i.ubicacion_x)**2+(:NEW.ubicacion_y-i.ubicacion_y)**2)<=5)THEN
        RAISE espacio_wrong; 
      END IF;
    END LOOP;
  END IF;
  EXCEPTION
  WHEN bodega_full THEN
    RAISE_APPLICATION_ERROR(-20505, '¡DEPOSITO LLENO(NO SE PERMITEN MAS DE DIEZ BODEGAS)!');
  WHEN espacio_wrong THEN 
    RAISE_APPLICATION_ERROR(-20505, '¡LAS BODEGAS DEBEN TENER UN ESPACIO LIBRE DE 5 UNIDADESA A LA REDONDA!');
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20505, '¡HA OCURRIDO UN ERROR!');
END;  
/

--trigger para inicializar los registros de una bodega insertada
CREATE OR REPLACE TRIGGER bodegaAfter
AFTER INSERT ON bodega
FOR EACH ROW
BEGIN
  INSERT into registro values(:NEW.cod_bodega,nest_inventario(inventario_tipo(1,0),
                                                inventario_tipo(2,0),
                                                inventario_tipo(3,0),
                                                inventario_tipo(4,0),
                                                inventario_tipo(5,0)));
  EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20505, '¡HA OCURRIDO UN ERROR!');
END;  
/