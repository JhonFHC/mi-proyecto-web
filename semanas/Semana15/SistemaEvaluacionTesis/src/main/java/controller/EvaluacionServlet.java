package com.zonajava.sistemaevaluaciontesis.controller;

import com.zonajava.sistemaevaluaciontesis.dao.*;
import com.zonajava.sistemaevaluaciontesis.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "EvaluacionServlet", urlPatterns = {"/evaluacion"})
public class EvaluacionServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
            return;
        }
        
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if ("guardar-evaluacion".equals(request.getParameter("action")) && 
            "jurado".equals(usuario.getRol())) {
            procesarEvaluacion(request, response, usuario);
        }
    }
    
    private void procesarEvaluacion(HttpServletRequest request, 
            HttpServletResponse response, Usuario jurado)
            throws IOException {
        try {
            int idEvaluacion = Integer.parseInt(request.getParameter("idEvaluacion"));
            String comentarios = request.getParameter("comentarios");
            String recomendacion = request.getParameter("recomendacion");
            
            CriterioDAO criterioDAO = new CriterioDAO();
            List<CriterioEvaluacion> criterios = criterioDAO.obtenerTodosCriterios();
            
            EvaluacionDAO evaluacionDAO = new EvaluacionDAO();
            double puntajeTotal = 0.0;
            
            for (CriterioEvaluacion criterio : criterios) {
                String paramName = "criterio_" + criterio.getIdCriterio();
                String puntajeStr = request.getParameter(paramName);
                
                if (puntajeStr != null) {
                    double puntaje = Double.parseDouble(puntajeStr);
                    puntajeTotal += puntaje;
                    
                    DetalleEvaluacion detalle = new DetalleEvaluacion();
                    detalle.setIdEvaluacion(idEvaluacion);
                    detalle.setIdCriterio(criterio.getIdCriterio());
                    detalle.setPuntaje(puntaje);
                    
                    String comentarioParam = "comentario_" + criterio.getIdCriterio();
                    String comentario = request.getParameter(comentarioParam);
                    
                    if (comentario != null && !comentario.trim().isEmpty()) {
                        detalle.setComentario(comentario);
                    }
                    
                    evaluacionDAO.guardarDetalleEvaluacion(detalle);
                }
            }
            
            evaluacionDAO.completarEvaluacion(idEvaluacion, puntajeTotal, 
                comentarios, recomendacion);
            
            response.sendRedirect(request.getContextPath() + 
                "/jurado/dashboard.jsp?success=evaluacion_completada&puntaje=" + puntajeTotal);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + 
                "/jurado/dashboard.jsp?error=evaluacion_fallida");
        }
    }
}