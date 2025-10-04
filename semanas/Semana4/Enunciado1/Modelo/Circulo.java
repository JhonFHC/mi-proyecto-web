/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Modelo;

/**
 *
 * @author La Zona Vip
 */
public class Circulo extends Figura {

    public Circulo(double radio) {
        super(radio);
    }

    @Override
    public double calcularArea() {
        return Math.PI * lado * lado;
    }

    @Override
    public double calcularPerimetro() {
        return 2 * Math.PI * lado;
    }
}
