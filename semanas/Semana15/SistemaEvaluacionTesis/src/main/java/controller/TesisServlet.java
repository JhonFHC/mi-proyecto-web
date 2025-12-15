package com.zonajava.sistemaevaluaciontesis.controller;

import com.zonajava.sistemaevaluaciontesis.dao.TesisDAO;
import com.zonajava.sistemaevaluaciontesis.model.Tesis;
import com.zonajava.sistemaevaluaciontesis.model.Usuario;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;

@WebServlet("/tesis")
@MultipartConfig(maxFileSize = 1024 * 1024 * 10)
public class TesisServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Usuario estudiante = (Usuario) session.getAttribute("usuario");
        
        if (estudiante == null || !"estudiante".equals(estudiante.getRol())) {
            response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
            return;
        }
        
        String titulo = request.getParameter("titulo");
        String descripcion = request.getParameter("descripcion");
        int idAsesor = Integer.parseInt(request.getParameter("id_asesor"));
        Part archivo = request.getPart("archivo");
        
        String nombreArchivo = "tesis_" + estudiante.getIdUsuario() + "_" +
            System.currentTimeMillis() + ".pdf";
        String ruta = "C:/tesis_uploads";
        
        File carpeta = new File(ruta);
        if (!carpeta.exists()) {
            carpeta.mkdirs();
        }
        
        archivo.write(ruta + File.separator + nombreArchivo);
        
        Tesis t = new Tesis();
        t.setTitulo(titulo);
        t.setDescripcion(descripcion);
        t.setIdEstudiante(estudiante.getIdUsuario());
        t.setIdAsesor(idAsesor);
        t.setArchivoUrl(nombreArchivo);
        
        TesisDAO dao = new TesisDAO();
        if (dao.insertar(t)) {
            response.sendRedirect(request.getContextPath() + 
                "/estudiante/dashboard.jsp?success=tesis_subida");
        } else {
            response.sendRedirect(request.getContextPath() + 
                "/estudiante/subir-tesis.jsp?error=registro");
        }
    }
}