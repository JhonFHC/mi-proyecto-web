/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */

package com.zonajava.enunciado01;

import Controlador.FiguraControlador;
import Vista.CuadradoVista;

public class Enunciado01 {
    public static void main(String[] args) {
        CuadradoVista vista = new CuadradoVista();
        FiguraControlador controlador = new FiguraControlador(vista);
        vista.setVisible(true);
    }
}

