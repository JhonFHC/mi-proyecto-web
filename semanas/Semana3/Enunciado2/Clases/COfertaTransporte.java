/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Clase;

/**
 *
 * @author La Zona Vip
 */
public class COfertaTransporte {
    private String turno; // "Mañana" o "Noche"
    private int cantidadPasajes;
    private final float precioPasaje = 37.5f;

    public void setTurno(String turno) {
        this.turno = turno;
    }

    public void setCantidadPasajes(int cantidadPasajes) {
        this.cantidadPasajes = cantidadPasajes;
    }

    public float calcularImporteCompra() {
        return precioPasaje * cantidadPasajes;
    }

    public float calcularDescuento() {
        float importe = calcularImporteCompra();
        float porcentajeDescuento = (cantidadPasajes >= 15) ? 0.08f : 0.05f;
        return importe * porcentajeDescuento;
    }

    public float calcularImportePagar() {
        return calcularImporteCompra() - calcularDescuento();
    }

    public int calcularCaramelos() {
        float importePagar = calcularImportePagar();
        if (importePagar > 200) {
            return 2 * cantidadPasajes;
        }
        return 0;
    }
}
