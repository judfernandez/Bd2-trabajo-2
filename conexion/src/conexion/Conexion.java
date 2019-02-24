package conexion;
import java.sql.*;
class conexion 
{
  static public void main( String[] args ) 
  {
    Connection conn;
    Statement sentencia;
    ResultSet resultado;

    System.out.println( "Conexión a la base de datos..." );
try{ // Se carga el driver JDBC-ODBC
     Class.forName ("oracle.jdbc.driver.OracleDriver"); 
   } catch( ClassNotFoundException e ) {
     System.out.println("No se pudo cargar el driver JDBC");
     return;             
     }
try{ // Se establece la conexión con la base de datos
     conn = DriverManager.getConnection   
     ("jdbc:oracle:thin:@DESKTOP-65L7KH5:1521:xe","Daniel", "32279723");
      sentencia = conn.createStatement();
   } catch( SQLException e ) {
     System.out.println( "No hay conexión con la base de datos." );
     return;
     } 
try {
      System.out.println( "Seleccionando..." );
      resultado = sentencia.executeQuery
      ("SELECT cod_bodega, nom_bodega, ubicacion_x, ubicacion_y FROM bodega");
      //Se recorren las tuplas retornadas
      while (resultado.next())
      {
       System.out.println(resultado.getInt("cod_bodega")+ 
       "---" + resultado.getString("nom_bodega")+ "---" + 
       resultado.getInt("ubicacion_x") + "---" + 
       resultado.getInt("ubicacion_y"));
      }
conn.close(); //Cierre de la conexión
    } catch( SQLException e ){       
             System.out.println("Error: " + 
              e.getMessage());
      }            
    System.out.println("Consulta finalizada.");
  } //Fin del main
} //Fin de la clase     