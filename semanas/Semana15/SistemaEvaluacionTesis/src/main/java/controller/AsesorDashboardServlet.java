package com.zonajava.sistemaevaluaciontesis.controller;

import com.zonajava.sistemaevaluaciontesis.dao.TesisDAO;
import com.zonajava.sistemaevaluaciontesis.model.Usuario;
import com.zonajava.sistemaevaluaciontesis.model.Tesis;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/asesor")
public class AsesorDashboardServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario asesor = (Usuario) session.getAttribute("usuario");
        
        if (asesor == null || !"asesor".equals(asesor.getRol())) {
            response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
            return;
        }
        
        TesisDAO dao = new TesisDAO();
        List<Tesis> tesis = dao.listarPorAsesor(asesor.getIdUsuario());
        
        request.setAttribute("asesor", asesor);
        request.setAttribute("tesis", tesis);
        request.setAttribute("cantidadTesis", tesis != null ? tesis.size() : 0);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/asesor/dashboard.jsp");
        dispatcher.forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}