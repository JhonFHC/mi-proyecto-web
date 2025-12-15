package com.zonajava.sistemaevaluaciontesis.controller;

import com.zonajava.sistemaevaluaciontesis.dao.TesisDAO;
import com.zonajava.sistemaevaluaciontesis.model.Usuario;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/evaluar-asesor")
public class EvaluacionAsesorServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Usuario asesor = (Usuario) session.getAttribute("usuario");
        
        if (asesor == null || !"asesor".equals(asesor.getRol())) {
            response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
            return;
        }
        
        int idTesis = Integer.parseInt(request.getParameter("id_tesis"));
        String observaciones = request.getParameter("observaciones");
        String recomendacion = request.getParameter("recomendacion");
        
        TesisDAO dao = new TesisDAO();
        boolean ok = dao.evaluarPorAsesor(idTesis, observaciones, recomendacion);
        
        if (ok) {
            response.sendRedirect(request.getContextPath() + 
                "/asesor/dashboard.jsp?success=evaluado");
        } else {
            response.sendRedirect(request.getContextPath() + 
                "/asesor/evaluar.jsp?id_tesis=" + idTesis + "&error=guardar");
        }
    }
}