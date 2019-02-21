-- Insert para bodega

INSERT INTO bodega (cod_bodega, nom_bodega, ubicacion_x, ubicacion_y) 
VALUES (110,'zipaquira',15,15);

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