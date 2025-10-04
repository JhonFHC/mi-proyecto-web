/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Clases;

/**
 *
 * @author La Zona Vip
 */
public class COfertaProducto {
    private float precioDocena;
    private int cantidadDocenas;

    // Constructor vacío
    public COfertaProducto() {}

    // Setters
    public void setPrecioDocena(float precioDocena) {
        this.precioDocena = precioDocena;
    }

    public void setCantidadDocenas(int cantidadDocenas) {
        this.cantidadDocenas = cantidadDocenas;
    }

    // Cálculo del importe de compra
    public float calcularImporteCompra() {
        return precioDocena * cantidadDocenas;
    }

    // Cálculo del descuento
    public float calcularDescuento() {
        float importe = calcularImporteCompra();
        if (cantidadDocenas >= 10) {
            return importe * 0.20f;
        } else {
            return importe * 0.10f;
        }
    }

    // Cálculo del importe a pagar
    public float calcularImportePagar() {
        return calcularImporteCompra() - calcularDescuento();
    }

    // Cálculo de lapiceros obsequio
    public int calcularLapiceros() {
        float importePagar = calcularImportePagar();
        if (importePagar >= 200) {
            return cantidadDocenas * 2;
        } else {
            return 0;
        }
    }
}
