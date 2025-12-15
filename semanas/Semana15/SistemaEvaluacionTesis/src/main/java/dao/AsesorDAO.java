package com.zonajava.sistemaevaluaciontesis.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AsesorDAO {
    
    public Map<String, Integer> obtenerEstadisticasAsesor(int idAsesor) {
        Map<String, Integer> estadisticas = new HashMap<>();
        
        String sql = "SELECT " +
                    "COUNT(CASE WHEN estado = 'enviada' THEN 1 END) AS pendientes, " +
                    "COUNT(CASE WHEN estado = 'en_evaluacion' THEN 1 END) AS en_evaluacion, " +
                    "COUNT(CASE WHEN estado = 'borrador' THEN 1 END) AS observadas " +
                    "FROM tesis WHERE id_asesor = ?";
        
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idAsesor);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                estadisticas.put("pendientes", rs.getInt("pendientes"));
                estadisticas.put("en_evaluacion", rs.getInt("en_evaluacion"));
                estadisticas.put("observadas", rs.getInt("observadas"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return estadisticas;
    }
    
    public List<Map<String, Object>> obtenerHistorialEvaluaciones(int idAsesor) {
        List<Map<String, Object>> historial = new ArrayList<>();
        
        String sql = "SELECT t.titulo, t.estado, t.fecha_creacion, " +
                    "u.nombre_completo AS estudiante " +
                    "FROM tesis t " +
                    "JOIN usuarios u ON t.id_estudiante = u.id_usuario " +
                    "WHERE t.id_asesor = ? " +
                    "ORDER BY t.fecha_creacion DESC " +
                    "LIMIT 10";
        
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idAsesor);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> registro = new HashMap<>();
                registro.put("titulo", rs.getString("titulo"));
                registro.put("estudiante", rs.getString("estudiante"));
                registro.put("estado", rs.getString("estado"));
                registro.put("fecha_creacion", rs.getTimestamp("fecha_creacion"));
                historial.add(registro);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return historial;
    }
}