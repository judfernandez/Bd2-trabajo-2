package interfaz_cliente;
import javax.swing.JFrame;

public class Interfaz_cliente {
    public static void main(String[] args) {
        interfaz DrawWindow = new interfaz();
        DrawWindow.setSize(500,500);
        DrawWindow.setResizable(false);
        DrawWindow.setLocation(200, 50);
        DrawWindow.setTitle("Pintando la ruta que viene de la BD");
        DrawWindow.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        DrawWindow.setVisible(true);
    }
}
