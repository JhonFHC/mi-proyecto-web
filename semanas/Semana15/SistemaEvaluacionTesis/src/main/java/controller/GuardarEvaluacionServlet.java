package com.zonajava.sistemaevaluaciontesis.controller;

import com.zonajava.sistemaevaluaciontesis.dao.EvaluacionDAO;
import com.zonajava.sistemaevaluaciontesis.dao.CriterioEvaluacionDAO;
import com.zonajava.sistemaevaluaciontesis.model.DetalleEvaluacion;
import com.zonajava.sistemaevaluaciontesis.model.Usuario;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/jurado/guardar")
public class GuardarEvaluacionServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Usuario jurado = (Usuario) session.getAttribute("usuario");
        
        if (jurado == null || !"jurado".equals(jurado.getRol())) {
            response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
            return;
        }
        
        try {
            int idEvaluacion = Integer.parseInt(request.getParameter("id_evaluacion"));
            double calificacionFinal = 0;
            int criteriosEvaluados = 0;
            
            EvaluacionDAO evaluacionDAO = new EvaluacionDAO();
            CriterioEvaluacionDAO criterioDAO = new CriterioEvaluacionDAO();
            
            List<com.zonajava.sistemaevaluaciontesis.model.CriterioEvaluacion> criterios = criterioDAO.obtenerCriteriosActivos();
            
            // Guardar cada criterio individualmente
            for (com.zonajava.sistemaevaluaciontesis.model.CriterioEvaluacion criterio : criterios) {
                String puntajeParam = request.getParameter("puntaje_" + criterio.getIdCriterio());
                String comentarioParam = request.getParameter("comentario_" + criterio.getIdCriterio());
                
                if (puntajeParam != null && !puntajeParam.isEmpty()) {
                    double puntaje = Double.parseDouble(puntajeParam);
                    String comentario = comentarioParam != null ? comentarioParam : ""; // Comentario opcional
                    
                    DetalleEvaluacion detalle = new DetalleEvaluacion();
                    detalle.setIdEvaluacion(idEvaluacion);
                    detalle.setIdCriterio(criterio.getIdCriterio());
                    detalle.setPuntaje(puntaje);
                    detalle.setComentario(comentario);
                    
                    evaluacionDAO.guardarDetalleEvaluacion(detalle);
                    calificacionFinal += puntaje;
                    criteriosEvaluados++;
                }
            }
            
            if (criteriosEvaluados > 0) {
                double totalCriterios = criterios.size();
                double porcentaje = (calificacionFinal / totalCriterios) * 100;
                
                String recomendacion;
                String comentarioGeneral = request.getParameter("comentario_general");
                
                // Determinar recomendación basada en porcentaje
                if (porcentaje >= 70) {
                    recomendacion = "aprobado";
                } else if (porcentaje >= 50) {
                    recomendacion = "aprobado_obs";
                } else {
                    recomendacion = "desaprobado";
                }
                
                // Comentario general es opcional
                String comentarioFinal = comentarioGeneral != null && !comentarioGeneral.trim().isEmpty() 
                    ? comentarioGeneral 
                    : "Evaluación completada sin comentario general.";
                
                // Guardar evaluación final
                boolean exito = evaluacionDAO.completarEvaluacion(
                    idEvaluacion, 
                    porcentaje,
                    comentarioFinal,
                    recomendacion
                );
                
                if (exito) {
                    response.sendRedirect(request.getContextPath() + "/jurado?msg=exito");
                } else {
                    response.sendRedirect(request.getContextPath() + "/jurado?error=guardar");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/jurado?error=criterios");
            }
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/jurado?error=id_invalido");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/jurado?error=inesperado");
        }
    }
}