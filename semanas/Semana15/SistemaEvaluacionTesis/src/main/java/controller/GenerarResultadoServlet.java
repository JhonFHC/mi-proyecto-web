package com.zonajava.sistemaevaluaciontesis.servlet;

import com.zonajava.sistemaevaluaciontesis.dao.DatabaseConnection;
import com.zonajava.sistemaevaluaciontesis.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/admin/generar-resultado")
public class GenerarResultadoServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Usuario admin = (Usuario) request.getSession().getAttribute("usuario");
        if (admin == null || !"admin".equals(admin.getRol())) {
            response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
            return;
        }
        
        int idTesis = Integer.parseInt(request.getParameter("id_tesis"));
        
        try (Connection con = DatabaseConnection.getConnection()) {
            String sqlProm = """
                SELECT AVG(calificacion_final) AS promedio
                FROM evaluaciones
                WHERE id_tesis = ? AND estado = 'completada'
                """;
            
            PreparedStatement ps = con.prepareStatement(sqlProm);
            ps.setInt(1, idTesis);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                double promedio = rs.getDouble("promedio");
                String estadoFinal = promedio >= 11 ? "aprobada" : "rechazada";
                
                PreparedStatement ps2 = con.prepareStatement(
                    "UPDATE tesis SET estado=? WHERE id_tesis=?");
                ps2.setString(1, estadoFinal);
                ps2.setInt(2, idTesis);
                ps2.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
    }
}