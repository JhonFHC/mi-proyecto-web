package com.zonajava.sistemaevaluaciontesis.servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import com.zonajava.sistemaevaluaciontesis.dao.ResultadoFinalDAO;
import com.zonajava.sistemaevaluaciontesis.model.Usuario;

@WebServlet("/admin/resultados")
public class ResultadosAdminServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println(">>> ENTRO A ResultadosAdminServlet <<<");
        Usuario admin = (Usuario) request.getSession().getAttribute("usuario");
        
        if (admin == null || !"admin".equals(admin.getRol())) {
            response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
            return;
        }
        
        ResultadoFinalDAO dao = new ResultadoFinalDAO();
        List<Object[]> lista = dao.listarTesisListas();
        request.setAttribute("lista", lista);
        request.getRequestDispatcher("/vistas/admin/resultados.jsp").forward(request, response);
    }
}