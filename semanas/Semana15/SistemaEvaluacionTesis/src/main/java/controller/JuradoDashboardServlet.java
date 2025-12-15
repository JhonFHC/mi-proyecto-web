package com.zonajava.sistemaevaluaciontesis.controller;

import com.zonajava.sistemaevaluaciontesis.dao.EvaluacionesDAO;
import com.zonajava.sistemaevaluaciontesis.model.Usuario;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/jurado")
public class JuradoDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Usuario jurado = (Usuario) session.getAttribute("usuario");
        
        if (jurado == null || !"jurado".equals(jurado.getRol())) {
            response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
            return;
        }
        
        EvaluacionesDAO dao = new EvaluacionesDAO();
        request.setAttribute("lista", 
            dao.listarPendientesPorJurado(jurado.getIdUsuario()));
        request.getRequestDispatcher("/jurado/dashboard.jsp").forward(request, response);
    }
}