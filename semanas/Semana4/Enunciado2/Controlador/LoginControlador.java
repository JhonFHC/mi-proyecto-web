/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controlador;

import Modelo.Usuario;
import Vista.LoginVista;
import Vista.ConversionVista;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.List;

public class LoginControlador {
    private final LoginVista loginVista;
    private final List<Usuario> usuarios;

    public LoginControlador(LoginVista vista, List<Usuario> usuarios) {
        this.loginVista = vista;
        this.usuarios = usuarios;

        this.loginVista.agregarLoginListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                login();
            }
        });
    }

    private void login() {
        String usuario = loginVista.getUsuario();
        String password = loginVista.getPassword();

        Usuario userEncontrado = usuarios.stream()
                .filter(u -> u.getUsername().equals(usuario) && u.getPassword().equals(password))
                .findFirst()
                .orElse(null);

        if (userEncontrado == null) {
            loginVista.setMensaje("Usuario o contraseña incorrectos.");
        } else {
            loginVista.setMensaje("Bienvenido " + userEncontrado.getUsername());
            abrirConversionVista(userEncontrado);
        }
    }

    private void abrirConversionVista(Usuario usuario) {
        SwingUtilities.invokeLater(() -> {
            ConversionVista conversionVista = new ConversionVista();
            ConversionControlador conversionControlador = new ConversionControlador(conversionVista, usuario, usuarios);
            conversionVista.setRol(usuario.getRol());
            conversionVista.setVisible(true);
            loginVista.dispose();
        });
    }
}
