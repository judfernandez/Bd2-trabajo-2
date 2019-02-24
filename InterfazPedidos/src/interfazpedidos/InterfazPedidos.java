/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package interfazpedidos;

import javax.swing.JFrame;

/**
 *
 * @author santi
 */
public class InterfazPedidos {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        interfaz DrawWindow = new interfaz();
        DrawWindow.setSize(395,500);
        DrawWindow.setResizable(false);
        DrawWindow.setLocation(200, 50);
        DrawWindow.setTitle("Pintando la ruta que viene de la BD");
        DrawWindow.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        DrawWindow.setVisible(true);
    }
    
}
