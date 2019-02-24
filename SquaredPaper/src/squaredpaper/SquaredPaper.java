package squaredpaper;

import javax.swing.*;
import java.awt.*;
import java.sql.*;
import java.math.*;
 
public class SquaredPaper extends JFrame {
 public void paint(Graphics g) {
   Dimension d = getSize();
   int x = d.width;
   int y = d.height;
   String ultimoorden = "";
   int ultimax = 0, ultimay = 0, aux = 0;
 
   g.setColor(Color.white);
   g.fillRect(0,0,x,y);
 
   g.setColor(Color.green);
   for (int i = 0; i < y; i+=25) g.drawLine(0,i,x,i);
   for (int i = 0; i < x; i+=25) g.drawLine(i,0,i,y);
 
   g.setColor(Color.black);
   g.drawLine(x/2,0,x/2,y);
   g.drawLine(0,y/2,x,y/2);
  
   g.setColor(Color.black);  
  
    Connection conn;
    Statement sentencia;
    ResultSet resultado;

    try{ // Se carga el driver JDBC-ODBC
     Class.forName ("oracle.jdbc.driver.OracleDriver");
    } catch( Exception e ) {
      System.out.println("No se pudo cargar el driver JDBC");
      return;           
      }

    try{ // Se establece la conexión con la base de datos Oracle Express
     conn = DriverManager.getConnection  
     ("jdbc:oracle:thin:@DESKTOP-65L7KH5:1521:xe","Daniel", "32279723");
      sentencia = conn.createStatement();
    } catch( SQLException e ) {
      System.out.println("No hay conexión con la base de datos.");
      return;
      }
       
    try {
     resultado = sentencia.executeQuery("SELECT r1.cod_bodega AS orden, r1.ubicacion_x AS a, r1.ubicacion_y AS b, r2.ubicacion_x AS c, r2.ubicacion_y AS d FROM bodega r1, bodega r2 WHERE r1.cod_bodega = r2.cod_bodega-1 ORDER BY r1.cod_bodega");
     while (resultado.next())
      {
       g.drawString("Bod. " + resultado.getString("orden"),resultado.getInt("a"),resultado.getInt("b"));
       g.drawLine(resultado.getInt("a"),resultado.getInt("b"),resultado.getInt("c"),resultado.getInt("d"));
       //Estas cuatro instrucciones que siguen son solo para pintar el punto final, es decir, ´
       //mediante la instrucción g.drawString que está luego de cerrar el ciclo while
       aux = resultado.getInt("orden")+1;
       ultimoorden = Integer.toString(aux);
       ultimax =  resultado.getInt("c");
       ultimay = resultado.getInt("d");
      }
      g.drawString("Bod. " + ultimoorden,ultimax, ultimay);
           
      //Se cierra la conexion con la BD
      conn.close();  
    } catch(SQLException e ){      
      System.out.println("Error: " + e.getMessage());
      }              
 }
 
 public static void main(String args[]) {
   SquaredPaper DrawWindow = new SquaredPaper();
 
   DrawWindow.setSize(500,500);
   DrawWindow.setResizable(true);
   DrawWindow.setLocation(200, 50);
   DrawWindow.setTitle("Pintando la ruta que viene de la BD");
   DrawWindow.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
   DrawWindow.setVisible(true);
 }
}
