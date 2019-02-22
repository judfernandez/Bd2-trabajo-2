-- Insert para bodega

INSERT INTO bodega (cod_bodega, nom_bodega, ubicacion_x, ubicacion_y) 
VALUES (110,'bodega 1',15,15);
INSERT INTO bodega (cod_bodega, nom_bodega, ubicacion_x, ubicacion_y) 
VALUES (111,'bodega 2',10,10);
INSERT INTO bodega (cod_bodega, nom_bodega, ubicacion_x, ubicacion_y) 
VALUES (112,'bodega 3', 1, 1);
INSERT INTO bodega (cod_bodega, nom_bodega, ubicacion_x, ubicacion_y) 
VALUES (113,'bodega 4', 6, 6);
INSERT INTO bodega (cod_bodega, nom_bodega, ubicacion_x, ubicacion_y) 
VALUES (114,'bodega 5',42,10);
INSERT INTO bodega (cod_bodega, nom_bodega, ubicacion_x, ubicacion_y) 
VALUES (115,'bodega 6',2,15);
INSERT INTO bodega (cod_bodega, nom_bodega, ubicacion_x, ubicacion_y) 
VALUES (116,'bodega 7',99,13);
INSERT INTO bodega (cod_bodega, nom_bodega, ubicacion_x, ubicacion_y) 
VALUES (117,'bodega 8',80, 78);
INSERT INTO bodega (cod_bodega, nom_bodega, ubicacion_x, ubicacion_y) 
VALUES (118,'bodega 9',25,78);
INSERT INTO bodega (cod_bodega, nom_bodega, ubicacion_x, ubicacion_y) 
VALUES (119,'bodega 10',15,50);

-- CASOS en los que debe fallar
INSERT INTO bodega (cod_bodega, nom_bodega, ubicacion_x, ubicacion_y) 
VALUES (120,'bodega 11',50,50); --FALLA POR QUE ES EL ELEMENTO 11
INSERT INTO bodega (cod_bodega, nom_bodega, ubicacion_x, ubicacion_y) 
VALUES (113,'bodega 4',15,15); --FALLA POR 5 UNIDADES A LA REDONDA
INSERT INTO bodega (cod_bodega, nom_bodega, ubicacion_x, ubicacion_y) 
VALUES (110,'bodega 1',70,70); --FALLA POR BODEGA REPETIDA

-- Insert para producto

INSERT INTO producto (cod_producto, nom_producto) 
VALUES (1, 'Bolsa de leche de gato');

INSERT INTO producto (cod_producto, nom_producto) 
VALUES (2, 'Pollo verde');

INSERT INTO producto (cod_producto, nom_producto) 
VALUES (3, 'Niño azul');

INSERT INTO producto (cod_producto, nom_producto) 
VALUES (4, 'Botella de jugo de cerdo');

INSERT INTO producto (cod_producto, nom_producto) 
VALUES (5, 'Paleta de miel de oveja');

-- caso producto no existe
INSERT INTO pedido VALUES (115,3,nest_detalle(detalle_tipo(1,1),
                                              detalle_tipo(2,1),
                                              detalle_tipo(3,1),
                                              detalle_tipo(4,1),
                                              detalle_tipo(17,1)));
---


INSERT INTO registro VALUES(115,nest_inventario(inventario_tipo(1,55),
                                                inventario_tipo(2,30),
                                                inventario_tipo(12,80),
                                                inventario_tipo(4,200),
                                                inventario_tipo(15,200)));

INSERT INTO registro VALUES(115,2,nest_inventario(inventario_tipo(1,1),
                                                inventario_tipo(2,1),
                                                inventario_tipo(3,1),
                                                inventario_tipo(4,1),
                                                
                                                inventario_tipo(6,10)));