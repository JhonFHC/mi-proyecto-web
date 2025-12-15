package com.zonajava.sistemaevaluaciontesis.controller;

import com.zonajava.sistemaevaluaciontesis.dao.TesisDAO;
import com.zonajava.sistemaevaluaciontesis.model.Usuario;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/estudiante")
public class EstudianteDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
            return;
        }
        
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null || !"estudiante".equals(usuario.getRol())) {
            response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
            return;
        }
        
        TesisDAO tesisDAO = new TesisDAO();
        
        // Obtener tesis actual del estudiante
        Object[] tesisActual = tesisDAO.obtenerResultadoFinalPorEstudiante(usuario.getIdUsuario());
        
        // Obtener historial
        List<Object[]> historial = tesisDAO.listarHistorialPorEstudiante(usuario.getIdUsuario());
        
        // Pasar datos a la vista
        request.setAttribute("usuario", usuario);
        request.setAttribute("tesisActual", tesisActual);
        request.setAttribute("historial", historial);
        
        // Redirigir al dashboard
        request.getRequestDispatcher("/estudiante/dashboard.jsp").forward(request, response);
    }
}