/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mainapp;


import java.awt.Frame;
import java.awt.Graphics;
import java.awt.Color;

class Pantalla extends Frame {

public Pantalla() {
this.setSize(200,150 );
this.setVisible( true );
}

public void paint(Graphics g) {
g.setColor(Color.RED);
g.drawLine(50, 50, 100, 100);
}

public static void main( String[] args ) {
Pantalla p = new Pantalla();
}

}