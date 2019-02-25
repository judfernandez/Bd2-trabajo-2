package mainapp;

import javax.swing.*;
import java.awt.*;
import java.sql.*;
import java.math.*;
import java.util.ArrayList;
 
public class SquaredPaper extends JFrame {
 public java.util.List<Integer> cod_bodegas_rutas = new ArrayList<>();  
 
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
     ("jdbc:oracle:thin:@santi-PC:1521:xe","santiago", "santiago");
      sentencia = conn.createStatement();
    } catch( SQLException e ) {
      System.out.println("No hay conexión con la base de datos.");
      return;
      }
       
    try {
     String c1="select * from bodega where ";
     for ( int i : this.cod_bodegas_rutas) {
         if(this.cod_bodegas_rutas.size()-1==this.cod_bodegas_rutas.indexOf(i)){
             c1=c1+"cod_bodega="+Integer.toString(i);
         }
         else{
             c1=c1+"cod_bodega="+Integer.toString(i)+" OR ";
         }
         
        } 
     String p1="select r1.cod_bodega AS orden, r1.ubicacion_x AS a, r1.ubicacion_y AS b, r2.ubicacion_x AS c, r2.ubicacion_y AS d from ";
     String sub1="("+c1+") r1,";
     String sub2="("+c1+") r2 ";
     String p3="WHERE r1.cod_bodega = r2.cod_bodega-1 ORDER BY r1.cod_bodega";
     String queryfinal=p1+sub1+sub2+p3;
     System.out.println(queryfinal);
     
     resultado = sentencia.executeQuery(queryfinal);
     while (resultado.next())
      {
       g.drawString("Bodega " + resultado.getString("orden"),resultado.getInt("a")*5,resultado.getInt("b")*5);
       g.drawLine(resultado.getInt("a")*5,resultado.getInt("b")*5,resultado.getInt("c")*5,resultado.getInt("d")*5);
       //Estas cuatro instrucciones que siguen son solo para pintar el punto final, es decir, ´
       //mediante la instrucción g.drawString que está luego de cerrar el ciclo while
       aux = resultado.getInt("orden")+1;
       ultimoorden = Integer.toString(aux);
       ultimax =  resultado.getInt("c")*5;
       ultimay = resultado.getInt("d")*5;
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
