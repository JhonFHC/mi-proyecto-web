package com.zonajava.sistemaevaluaciontesis.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;

@WebServlet("/ver-tesis")
public class DescargarTesisServlet extends HttpServlet {
    private static final String RUTA_BASE = "C:/tesis_uploads/";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String archivo = request.getParameter("file");
        if (archivo == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, 
                "Archivo no especificado");
            return;
        }
        
        File file = new File(RUTA_BASE + archivo);
        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, 
                "Archivo no encontrado");
            return;
        }
        
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", 
            "inline; filename=\"" + file.getName() + "\"");
        
        try (FileInputStream fis = new FileInputStream(file);
             OutputStream os = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytes;
            while ((bytes = fis.read(buffer)) != -1) {
                os.write(buffer, 0, bytes);
            }
        }
    }
}