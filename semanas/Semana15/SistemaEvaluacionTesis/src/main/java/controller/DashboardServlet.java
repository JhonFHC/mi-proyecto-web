package com.zonajava.sistemaevaluaciontesis.controller;

import com.zonajava.sistemaevaluaciontesis.dao.TesisDAO;
import com.zonajava.sistemaevaluaciontesis.model.Usuario;
import com.zonajava.sistemaevaluaciontesis.model.Tesis;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {
    private TesisDAO tesisDAO;
    
    @Override
    public void init() throws ServletException {
        tesisDAO = new TesisDAO();
    }
    
    private void cargarDashboardAsesor(HttpServletRequest request, 
            HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {
        request.getRequestDispatcher("/asesor/dashboard.jsp").forward(request, response);
    }
    
    private void cargarDashboardJurado(HttpServletRequest request, 
            HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {
        request.getRequestDispatcher("/jurado/dashboard.jsp").forward(request, response);
    }
    
    private void cargarDashboardAdmin(HttpServletRequest request, 
            HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}