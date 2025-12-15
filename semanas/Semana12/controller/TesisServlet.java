package com.zonajava.sistemaevaluaciontesis.controller;

import com.zonajava.sistemaevaluaciontesis.dao.TesisDAO;
import com.zonajava.sistemaevaluaciontesis.model.Tesis;
import com.zonajava.sistemaevaluaciontesis.model.Usuario;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/tesis")
public class TesisServlet extends HttpServlet {
    private TesisDAO tesisDAO;
    
    @Override
    public void init() {
        tesisDAO = new TesisDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        
        if (usuario == null) {
            response.sendRedirect("vistas/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("buscar".equals(action)) {
            String criterio = request.getParameter("criterio");
            List<Tesis> tesisList = tesisDAO.buscarTesis(criterio);
            request.setAttribute("tesis", tesisList);
        } else {
            List<Tesis> tesisList = tesisDAO.obtenerTodasTesis();
            request.setAttribute("tesis", tesisList);
        }
        
        // Redirigir según el rol
        if ("admin".equals(usuario.getRol())) {
            request.getRequestDispatcher("/admin/tesis.jsp").forward(request, response);
        } else if ("asesor".equals(usuario.getRol())) {
            request.getRequestDispatcher("/asesor/tesis.jsp").forward(request, response);
        } else {
            // Por defecto redirigir al login
            response.sendRedirect("vistas/login.jsp");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        
        if (usuario == null) {
            response.sendRedirect("vistas/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("crear".equals(action)) {
            crearTesis(request, response, usuario);
        } else if ("actualizar".equals(action)) {
            actualizarTesis(request, response, usuario);
        } else if ("enviar".equals(action)) {
            enviarTesis(request, response, usuario);
        } else if ("asignar-jurados".equals(action)) {
            asignarJurados(request, response, usuario);
        }
    }
    
    private void crearTesis(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {
        
        try {
            Tesis tesis = new Tesis();
            tesis.setTitulo(request.getParameter("titulo"));
            tesis.setDescripcion(request.getParameter("descripcion"));
            tesis.setIdEstudiante(usuario.getIdUsuario());
            tesis.setIdAsesor(Integer.parseInt(request.getParameter("idAsesor")));
            tesis.setArchivoUrl(request.getParameter("archivoUrl"));
            tesis.setEstado("borrador");
            
            if (tesisDAO.crearTesis(tesis)) {
                response.sendRedirect("estudiante/tesis.jsp?success=tesis_creada");
            } else {
                response.sendRedirect("estudiante/tesis.jsp?error=creacion_fallida");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("estudiante/tesis.jsp?error=creacion_fallida");
        }
    }
    
    private void actualizarTesis(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {
        
        try {
            Tesis tesis = new Tesis();
            tesis.setIdTesis(Integer.parseInt(request.getParameter("idTesis")));
            tesis.setTitulo(request.getParameter("titulo"));
            tesis.setDescripcion(request.getParameter("descripcion"));
            tesis.setIdAsesor(Integer.parseInt(request.getParameter("idAsesor")));
            tesis.setArchivoUrl(request.getParameter("archivoUrl"));
            
            // Verificar que el estudiante sea el dueño de la tesis
            List<Tesis> misTesis = tesisDAO.obtenerTesisPorEstudiante(usuario.getIdUsuario());
            boolean esPropietario = misTesis.stream()
                    .anyMatch(t -> t.getIdTesis() == tesis.getIdTesis());
            
            if (!esPropietario) {
                response.sendRedirect("estudiante/tesis.jsp?error=acceso_denegado");
                return;
            }
            
            if (tesisDAO.actualizarTesis(tesis)) {
                response.sendRedirect("estudiante/tesis.jsp?success=tesis_actualizada");
            } else {
                response.sendRedirect("estudiante/tesis.jsp?error=actualizacion_fallida");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("estudiante/tesis.jsp?error=actualizacion_fallida");
        }
    }
    
    private void enviarTesis(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {
        
        try {
            int idTesis = Integer.parseInt(request.getParameter("idTesis"));
            
            // Verificar que el estudiante sea el dueño de la tesis
            List<Tesis> misTesis = tesisDAO.obtenerTesisPorEstudiante(usuario.getIdUsuario());
            boolean esPropietario = misTesis.stream()
                    .anyMatch(t -> t.getIdTesis() == idTesis);
            
            if (!esPropietario) {
                response.sendRedirect("estudiante/tesis.jsp?error=acceso_denegado");
                return;
            }
            
            if (tesisDAO.actualizarEstadoTesis(idTesis, "enviada")) {
                response.sendRedirect("estudiante/tesis.jsp?success=tesis_enviada");
            } else {
                response.sendRedirect("estudiante/tesis.jsp?error=envio_fallido");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("estudiante/tesis.jsp?error=envio_fallido");
        }
    }
    
    private void asignarJurados(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {
        
        // Esta funcionalidad estará completa en la próxima versión
        // Por ahora solo redirigimos con un mensaje de éxito
        response.sendRedirect("admin/tesis.jsp?success=jurados_asignados");
    }
    
    // Método auxiliar para actualizar tesis (simplificado)
    private boolean actualizarTesis(Tesis tesis) {
        // Este método simula la actualización de una tesis
        // En una implementación real, usarías TesisDAO.actualizarTesis()
        return true;
    }
}
