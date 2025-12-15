package com.zonajava.sistemaevaluaciontesis.servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import com.zonajava.sistemaevaluaciontesis.dao.ResultadoFinalDAO;

@WebServlet("/admin/procesar-resultado")
public class ProcesarResultadoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int idTesis = Integer.parseInt(request.getParameter("id_tesis"));
        ResultadoFinalDAO dao = new ResultadoFinalDAO();
        dao.actualizarEstadoTesis(idTesis, "aprobada");
        response.sendRedirect(request.getContextPath() + "/admin/resultados");
    }
}