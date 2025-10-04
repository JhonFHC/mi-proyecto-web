/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */

package com.zonajava.enunciado02;

import Controlador.LoginControlador;
import Modelo.Usuario;
import Vista.LoginVista;

import javax.swing.*;
import java.util.List;
/**
 *
 * @author La Zona Vip
 */
public class Enunciado02 {

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            List<Usuario> usuarios = List.of(
                new Usuario("alumno1", "pass1", "ALUMNO"),
                new Usuario("profesor1", "pass2", "PROFESOR")
            );

            LoginVista login = new LoginVista();
            LoginControlador controlador = new LoginControlador(login, usuarios);
            login.setVisible(true);
        });
    }
}
