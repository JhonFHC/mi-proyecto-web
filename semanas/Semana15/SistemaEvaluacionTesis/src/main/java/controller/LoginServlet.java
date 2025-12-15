package com.zonajava.sistemaevaluaciontesis.controller;

import com.zonajava.sistemaevaluaciontesis.dao.UsuarioDAO;
import com.zonajava.sistemaevaluaciontesis.model.Usuario;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        if (email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + 
                "/vistas/login.jsp?error=datosVacios");
            return;
        }
        
        UsuarioDAO dao = new UsuarioDAO();
        Usuario usuario = dao.autenticar(email, password);
        
        if (usuario != null) {
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }
            
            HttpSession newSession = request.getSession(true);
            newSession.setAttribute("usuario", usuario);
            newSession.setMaxInactiveInterval(30 * 60);
            newSession.setAttribute("loginTime", System.currentTimeMillis());
            newSession.setAttribute("ipAddress", request.getRemoteAddr());
            
            String redirectPath = determinarRedirectPath(
                usuario.getRol(), request.getContextPath());
            response.sendRedirect(redirectPath);
        } else {
            System.out.println("Intento de login fallido para email: " + email);
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
            response.sendRedirect(request.getContextPath() + 
                "/vistas/login.jsp?error=credenciales");
        }
    }
    
    private String determinarRedirectPath(String rol, String contextPath) {
        switch (rol) {
            case "admin":
                return contextPath + "/admin/dashboard.jsp";
            case "asesor":
                return contextPath + "/asesor/dashboard.jsp";
            case "jurado":
                return contextPath + "/jurado";
            case "estudiante":
                return contextPath + "/estudiante/dashboard.jsp";
            default:
                return contextPath + "/vistas/login.jsp?error=rol";
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                Usuario usuario = (Usuario) session.getAttribute("usuario");
                if (usuario != null) {
                    System.out.println("Logout exitoso para: " + usuario.getEmail());
                }
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + 
                "/vistas/login.jsp?msg=logoutExitoso");
        } else if ("check".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("usuario") != null) {
                response.getWriter().write("{\"loggedIn\": true}");
            } else {
                response.getWriter().write("{\"loggedIn\": false}");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
        }
    }
}