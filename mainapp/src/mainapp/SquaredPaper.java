package mainapp;

import javax.swing.*;
import java.awt.*;
import java.sql.*;
import java.math.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class SquaredPaper extends JFrame {

    public java.util.List<Integer> cod_bodegas_rutas = new ArrayList<>();
    Map<Integer, java.util.List<String>> dictionary = new HashMap<Integer, java.util.List<String>>();
    int xi, yi, xf, yf, orden;
    String nombre_bodega;

    public void paint(Graphics g) {
        Dimension d = getSize();
        int x = d.width;
        int y = d.height;
        String ultimoorden = "";
        int ultimax = 0, ultimay = 0, aux = 0;

        g.setColor(Color.white);
        g.fillRect(0, 0, x, y);

        g.setColor(Color.green);
        for (int i = 0; i < y; i += 25) {
            g.drawLine(0, i, x, i);
        }
        for (int i = 0; i < x; i += 25) {
            g.drawLine(i, 0, i, y);
        }

        g.setColor(Color.black);
        g.drawLine(x / 2, 0, x / 2, y);
        g.drawLine(0, y / 2, x, y / 2);

        g.setColor(Color.black);

        Connection conn;
        Statement sentencia;
        ResultSet resultado;

        try { // Se carga el driver JDBC-ODBC
            Class.forName("oracle.jdbc.driver.OracleDriver");
        } catch (Exception e) {
            System.out.println("No se pudo cargar el driver JDBC");
            return;
        }

        try { // Se establece la conexión con la base de datos Oracle Express
            conn = DriverManager.getConnection("jdbc:oracle:thin:@LAPTOP-UNKNNU64:1521:xe", "gato", "gato");
            sentencia = conn.createStatement();
        } catch (SQLException e) {
            System.out.println("No hay conexión con la base de datos.");
            return;
        }

        try {
            
            for (int i = 0; i < this.cod_bodegas_rutas.size(); i++) {
                if (i != this.cod_bodegas_rutas.size() - 1) {
                    String queryIndividual = ("select r1.cod_bodega AS orden,r1.nom_bodega AS nombre, r1.ubicacion_x AS a, r1.ubicacion_y AS b from bodega r1 where r1.cod_bodega = " + Integer.toString(this.cod_bodegas_rutas.get(i)));
                    resultado = sentencia.executeQuery(queryIndividual);

                    while (resultado.next()) {
                        orden = resultado.getInt("orden");
                        nombre_bodega = resultado.getString("nombre");
                        xi = resultado.getInt("a");
                        yi = resultado.getInt("b");
                    }
                    queryIndividual = ("select r1.cod_bodega AS orden,r1.nom_bodega AS nombre, r1.ubicacion_x AS a, r1.ubicacion_y AS b from bodega r1 where r1.cod_bodega = " + Integer.toString(this.cod_bodegas_rutas.get(i + 1)));
                    resultado = sentencia.executeQuery(queryIndividual);

                    while (resultado.next()) {
                        xf = resultado.getInt("a");
                        yf = resultado.getInt("b");
                    }

                } else {
                     String queryIndividual = ("select r1.cod_bodega AS orden,r1.nom_bodega AS nombre, r1.ubicacion_x AS a, r1.ubicacion_y AS b from bodega r1 where r1.cod_bodega = " + Integer.toString(this.cod_bodegas_rutas.get(i)));
                    resultado = sentencia.executeQuery(queryIndividual);

                    while (resultado.next()) {
                        orden = resultado.getInt("orden");
                        nombre_bodega = resultado.getString("nombre");
                        xi = resultado.getInt("a");
                        yi = resultado.getInt("b");
                        xf = resultado.getInt("a");
                        yf = resultado.getInt("b");
                    }
                    
                }
                
               for(int j=0; j<this.dictionary.get(orden).size(); j++){
                   g.drawString(this.dictionary.get(orden).get(j), xi * 10, (yi -2)* 10);
               }
                g.drawString(nombre_bodega, xi * 10, yi * 10);
                g.drawLine(xi * 10, yi * 10, xf * 10, yf * 10);
            }
            conn.close();
        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }

    public static void main(String args[]) {
        SquaredPaper DrawWindow = new SquaredPaper();

        DrawWindow.setSize(500, 500);
        DrawWindow.setResizable(true);
        DrawWindow.setLocation(200, 50);
        DrawWindow.setTitle("Ruta de recogida en bodegas");
        DrawWindow.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        DrawWindow.setVisible(true);
    }
}
