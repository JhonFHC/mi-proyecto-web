package com.zonajava.sistemaevaluaciontesis.controller;

import com.zonajava.sistemaevaluaciontesis.model.Usuario;
import com.zonajava.sistemaevaluaciontesis.dao.TesisDAO;
import com.zonajava.sistemaevaluaciontesis.dao.AdminDAO;
import com.zonajava.sistemaevaluaciontesis.model.Tesis;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin")
public class AdminDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
            return;
        }
        
        Usuario admin = (Usuario) session.getAttribute("usuario");
        if (!"admin".equals(admin.getRol())) {
            response.sendRedirect(request.getContextPath() + "/vistas/acceso-denegado.jsp");
            return;
        }
        
        TesisDAO tesisDAO = new TesisDAO();
        AdminDAO adminDAO = new AdminDAO();
        
        List<Tesis> tesisPendientes = tesisDAO.listarParaJurados();
        List<Object[]> tesisListas = adminDAO.listarTesisListasParaResultado();
        
        request.setAttribute("tesisPendientes", tesisPendientes);
        request.setAttribute("tesisListas", tesisListas);
        request.setAttribute("admin", admin);
        
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}