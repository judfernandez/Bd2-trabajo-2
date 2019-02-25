/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mainapp;

import java.util.Arrays;
import javax.swing.JFrame;

/**
 *
 * @author santi
 */
public class Mainapp {
   public boolean pedidosent=false;
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        
        interfaz DrawWindow = new interfaz();
        DrawWindow.setSize(395,500);
        DrawWindow.setResizable(false);
        DrawWindow.setLocation(200, 50);
        DrawWindow.setTitle("Aplicacion para clientes");
        DrawWindow.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        DrawWindow.setVisible(true);
        
        

        
        
        
        
    }

    
    
    
}
