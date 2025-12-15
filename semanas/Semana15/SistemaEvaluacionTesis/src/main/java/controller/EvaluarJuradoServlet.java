package com.zonajava.sistemaevaluaciontesis.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/jurado/evaluar")
public class EvaluarJuradoServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/jurado?error=id_invalido");
                return;
            }
            
            int idEvaluacion = Integer.parseInt(idParam);
            request.setAttribute("idEvaluacion", idEvaluacion);
            request.getRequestDispatcher("/jurado/evaluar.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/jurado?error=id_invalido");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/jurado?error=inesperado");
        }
    }
}