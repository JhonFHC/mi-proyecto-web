/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controlador;

import Modelo.*;
import Vista.ConversionVista;
import Vista.LoginVista;

import java.util.List;

public class ConversionControlador {
    private ConversionVista vista;
    private Usuario usuario;
    private List<Usuario> usuarios;

    public ConversionControlador(ConversionVista vista, Usuario usuario, List<Usuario> usuarios) {
        this.vista = vista;
        this.usuario = usuario;
        this.usuarios = usuarios;

        vista.setRol(usuario.getRol());

        vista.agregarCalcularListener(e -> calcular());
        vista.agregarGuardarSalirListener(e -> guardarYSalir());
        vista.agregarEliminarListener(e -> eliminarTodo());

        if ("PROFESOR".equalsIgnoreCase(usuario.getRol())) {
            mostrarConversionesGuardadas();
        }
    }

    private void calcular() {
        try {
            double valor = Double.parseDouble(vista.getValor());
            String origen = vista.getUnidadOrigen();
            String destino = vista.getUnidadDestino();
            double resultado = convertir(valor, origen, destino);

            vista.setResultado(valor + " " + origen + " = " + resultado + " " + destino);
        } catch (NumberFormatException ex) {
            vista.setResultado("Por favor, ingrese un número válido.");
        }
    }

    private double convertir(double valor, String origen, String destino) {
        double valorEnMetros = switch (origen) {
            case "cm" -> valor / 100;
            case "mm" -> valor / 1000;
            case "km" -> valor * 1000;
            default -> valor;
        };

        return switch (destino) {
            case "cm" -> valorEnMetros * 100;
            case "mm" -> valorEnMetros * 1000;
            case "km" -> valorEnMetros / 1000;
            default -> valorEnMetros;
        };
    }

    private void guardarYSalir() {
        try {
            double valor = Double.parseDouble(vista.getValor());
            String origen = vista.getUnidadOrigen();
            String destino = vista.getUnidadDestino();
            double resultado = convertir(valor, origen, destino);

            RepositorioConversiones.guardar(new Conversion(valor, origen, destino, resultado));
        } catch (NumberFormatException ex) {
            vista.setResultado("Error al guardar: valor no numérico.");
        }

        volverAlLogin();
    }

    private void eliminarTodo() {
        RepositorioConversiones.limpiarConversiones();
        vista.setResultado("Conversiones eliminadas.");
    }

    private void mostrarConversionesGuardadas() {
        StringBuilder sb = new StringBuilder();
        for (Conversion c : RepositorioConversiones.obtenerConversiones()) {
            sb.append(c.toString()).append("\n");
        }
        vista.mostrarConversiones(sb.toString());
    }

    private void volverAlLogin() {
        vista.dispose();
        LoginVista loginVista = new LoginVista();
        new LoginControlador(loginVista, usuarios); // Corrección: ahora pasamos la lista
        loginVista.setVisible(true);
    }
}
