package com.zonajava.sistemaevaluaciontesis.dao;

import com.zonajava.sistemaevaluaciontesis.model.Evaluacion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EvaluacionDAO {
    
    // Crear evaluación
    public boolean crearEvaluacion(Evaluacion evaluacion) {
        String sql = "INSERT INTO evaluaciones (id_tesis, id_jurado, estado) VALUES (?, ?, 'pendiente')";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, evaluacion.getIdTesis());
            stmt.setInt(2, evaluacion.getIdJurado());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Obtener evaluaciones por jurado
    public List<Evaluacion> obtenerEvaluacionesPorJurado(int idJurado) {
        List<Evaluacion> evaluaciones = new ArrayList<>();
        String sql = "SELECT e.*, t.titulo as titulo_tesis, u.nombre_completo as nombre_jurado " +
                    "FROM evaluaciones e " +
                    "JOIN tesis t ON e.id_tesis = t.id_tesis " +
                    "JOIN usuarios u ON e.id_jurado = u.id_usuario " +
                    "WHERE e.id_jurado = ? " +
                    "ORDER BY e.fecha_evaluacion DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idJurado);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Evaluacion evaluacion = new Evaluacion();
                evaluacion.setIdEvaluacion(rs.getInt("id_evaluacion"));
                evaluacion.setIdTesis(rs.getInt("id_tesis"));
                evaluacion.setIdJurado(rs.getInt("id_jurado"));
                evaluacion.setCalificacionFinal(rs.getDouble("calificacion_final"));
                evaluacion.setComentarios(rs.getString("comentarios"));
                evaluacion.setFechaEvaluacion(rs.getTimestamp("fecha_evaluacion"));
                evaluacion.setEstado(rs.getString("estado"));
                evaluacion.setTituloTesis(rs.getString("titulo_tesis"));
                evaluacion.setNombreJurado(rs.getString("nombre_jurado"));
                evaluaciones.add(evaluacion);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return evaluaciones;
    }
    
    // Obtener evaluaciones por tesis
    public List<Evaluacion> obtenerEvaluacionesPorTesis(int idTesis) {
        List<Evaluacion> evaluaciones = new ArrayList<>();
        String sql = "SELECT e.*, t.titulo as titulo_tesis, u.nombre_completo as nombre_jurado " +
                    "FROM evaluaciones e " +
                    "JOIN tesis t ON e.id_tesis = t.id_tesis " +
                    "JOIN usuarios u ON e.id_jurado = u.id_usuario " +
                    "WHERE e.id_tesis = ? " +
                    "ORDER BY e.fecha_evaluacion DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idTesis);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Evaluacion evaluacion = new Evaluacion();
                evaluacion.setIdEvaluacion(rs.getInt("id_evaluacion"));
                evaluacion.setIdTesis(rs.getInt("id_tesis"));
                evaluacion.setIdJurado(rs.getInt("id_jurado"));
                evaluacion.setCalificacionFinal(rs.getDouble("calificacion_final"));
                evaluacion.setComentarios(rs.getString("comentarios"));
                evaluacion.setFechaEvaluacion(rs.getTimestamp("fecha_evaluacion"));
                evaluacion.setEstado(rs.getString("estado"));
                evaluacion.setTituloTesis(rs.getString("titulo_tesis"));
                evaluacion.setNombreJurado(rs.getString("nombre_jurado"));
                evaluaciones.add(evaluacion);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return evaluaciones;
    }
    
    // Actualizar evaluación
    public boolean actualizarEvaluacion(Evaluacion evaluacion) {
        String sql = "UPDATE evaluaciones SET calificacion_final = ?, comentarios = ?, estado = 'completada', fecha_evaluacion = NOW() WHERE id_evaluacion = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDouble(1, evaluacion.getCalificacionFinal());
            stmt.setString(2, evaluacion.getComentarios());
            stmt.setInt(3, evaluacion.getIdEvaluacion());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Obtener estadísticas para dashboard
    public int obtenerTotalEvaluacionesPendientes(int idJurado) {
        String sql = "SELECT COUNT(*) as total FROM evaluaciones WHERE id_jurado = ? AND estado = 'pendiente'";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idJurado);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int obtenerTotalEvaluacionesCompletadas(int idJurado) {
        String sql = "SELECT COUNT(*) as total FROM evaluaciones WHERE id_jurado = ? AND estado = 'completada'";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idJurado);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}