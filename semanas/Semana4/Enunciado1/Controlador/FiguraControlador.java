/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controlador;

import Modelo.*;
import Vista.CuadradoVista;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class FiguraControlador {
    private Figura modelo;
    private final CuadradoVista vista;

    public FiguraControlador(CuadradoVista vista) {
        this.vista = vista;

        this.vista.agregarCalcularListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                calcular();
            }
        });

        this.vista.agregarNuevoListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                vista.limpiarCampos();
            }
        });

        this.vista.agregarSairListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                System.exit(0);
            }
        });
    }

    public void calcular() {
        double lado = vista.obtenerLado();
        String figura = vista.getFiguraSeleccionada();

        switch (figura) {
            case "cuadrado":
                modelo = new Cuadrado(lado);
                break;
            case "circulo":
                modelo = new Circulo(lado);
                break;
            case "triangulo":
                modelo = new Triangulo(lado);
                break;
            default:
                vista.mostrarResultados(0, 0);
                return;
        }

        double area = modelo.calcularArea();
        double perimetro = modelo.calcularPerimetro();
        vista.mostrarResultados(area, perimetro);
    }
}
