package com.zonajava.sistemaevaluaciontesis.controller;

import com.zonajava.sistemaevaluaciontesis.dao.AdminDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/asignar-jurados")
public class AsignarJuradosServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int idTesis = Integer.parseInt(request.getParameter("id_tesis"));
        String[] jurados = request.getParameterValues("jurados");
        
        if (jurados == null || jurados.length != 3) {
            response.sendRedirect(request.getContextPath() + 
                "/admin/asignar.jsp?id_tesis=" + idTesis + "&error=3jurados");
            return;
        }
        
        List<Integer> ids = new ArrayList<>();
        for (String j : jurados) {
            ids.add(Integer.parseInt(j));
        }
        
        AdminDAO dao = new AdminDAO();
        boolean ok = dao.asignarJurados(idTesis, ids);
        
        if (ok) {
            response.sendRedirect(request.getContextPath() + 
                "/admin/dashboard.jsp?success=asignado");
        } else {
            response.sendRedirect(request.getContextPath() + 
                "/admin/asignar.jsp?id_tesis=" + idTesis + "&error=bd");
        }
    }
}