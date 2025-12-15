package com.zonajava.sistemaevaluaciontesis.controller;

import com.zonajava.sistemaevaluaciontesis.dao.UsuarioDAO;
import com.zonajava.sistemaevaluaciontesis.model.Usuario;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    // El resto del código se mantiene igual...
    private UsuarioDAO usuarioDAO;
    
    @Override
    public void init() {
        usuarioDAO = new UsuarioDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        Usuario usuario = usuarioDAO.autenticar(email, password);
        
        if (usuario != null) {
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);
            
            // Redirigir según el rol
            switch (usuario.getRol()) {
                case "admin":
                    response.sendRedirect("admin/dashboard.jsp");
                    break;
                case "estudiante":
                    response.sendRedirect("estudiante/dashboard.jsp");
                    break;
                case "asesor":
                    response.sendRedirect("asesor/dashboard.jsp");
                    break;
                case "jurado":
                    response.sendRedirect("jurado/dashboard.jsp");
                    break;
                default:
                    response.sendRedirect("vistas/login.jsp?error=rol_no_valido");
            }
        } else {
            response.sendRedirect("vistas/login.jsp?error=credenciales_invalidas");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect("vistas/login.jsp");
    }
}