package com.zonajava.sistemaevaluaciontesis.dao;

import com.zonajava.sistemaevaluaciontesis.model.Tesis;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TesisDAO {
    public boolean insertar(Tesis t) {
        String sql = "INSERT INTO tesis (titulo, descripcion, id_estudiante, id_asesor, "
                   + "estado, archivo_url, fecha_envio) "
                   + "VALUES (?, ?, ?, ?, 'enviada', ?, NOW())";
        
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, t.getTitulo());
            ps.setString(2, t.getDescripcion());
            ps.setInt(3, t.getIdEstudiante());
            ps.setInt(4, t.getIdAsesor());
            ps.setString(5, t.getArchivoUrl());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<Tesis> listarPorEstudiante(int idEstudiante) {
        List<Tesis> lista = new ArrayList<>();
        String sql = "SELECT t.*, u1.nombre_completo AS estudiante_nombre, "
                   + "u2.nombre_completo AS asesor_nombre "
                   + "FROM tesis t "
                   + "JOIN usuarios u1 ON t.id_estudiante = u1.id_usuario "
                   + "JOIN usuarios u2 ON t.id_asesor = u2.id_usuario "
                   + "WHERE t.id_estudiante = ? "
                   + "ORDER BY t.fecha_creacion DESC";
        
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idEstudiante);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Tesis t = new Tesis();
                t.setIdTesis(rs.getInt("id_tesis"));
                t.setTitulo(rs.getString("titulo"));
                t.setDescripcion(rs.getString("descripcion"));
                t.setEstado(rs.getString("estado"));
                t.setArchivoUrl(rs.getString("archivo_url"));
                t.setEstudianteNombre(rs.getString("estudiante_nombre"));
                t.setAsesorNombre(rs.getString("asesor_nombre"));
                lista.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
    
    public List<Tesis> listarPorAsesor(int idAsesor) {
        List<Tesis> lista = new ArrayList<>();
        String sql = "SELECT t.*, u.nombre_completo AS estudiante_nombre "
                   + "FROM tesis t "
                   + "JOIN usuarios u ON t.id_estudiante = u.id_usuario "
                   + "WHERE t.id_asesor = ? AND t.estado = 'enviada'";
        
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idAsesor);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Tesis t = new Tesis();
                t.setIdTesis(rs.getInt("id_tesis"));
                t.setTitulo(rs.getString("titulo"));
                t.setDescripcion(rs.getString("descripcion"));
                t.setEstado(rs.getString("estado"));
                t.setEstudianteNombre(rs.getString("estudiante_nombre"));
                t.setArchivoUrl(rs.getString("archivo_url"));
                lista.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
    
    public boolean evaluarPorAsesor(int idTesis, String observaciones, String recomendacion) {
        String sql = "UPDATE tesis SET estado = ?, "
                   + "descripcion = CONCAT(IFNULL(descripcion,''), "
                   + "'\n\nOBSERVACIONES ASESOR:\n', ?) "
                   + "WHERE id_tesis = ?";
        
        String nuevoEstado = recomendacion.equals("aprobada") ? "en_evaluacion" : "borrador";
        
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, nuevoEstado);
            ps.setString(2, observaciones);
            ps.setInt(3, idTesis);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<Tesis> listarParaJurados() {
        List<Tesis> lista = new ArrayList<>();
        String sql = "SELECT t.*, u.nombre_completo AS estudiante_nombre "
                   + "FROM tesis t "
                   + "JOIN usuarios u ON t.id_estudiante = u.id_usuario "
                   + "WHERE t.estado = 'en_evaluacion'";
        
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Tesis t = new Tesis();
                t.setIdTesis(rs.getInt("id_tesis"));
                t.setTitulo(rs.getString("titulo"));
                t.setEstudianteNombre(rs.getString("estudiante_nombre"));
                t.setArchivoUrl(rs.getString("archivo_url"));
                lista.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
    
    public Object[] obtenerResultadoFinalPorEstudiante(int idEstudiante) {
        String sql = "SELECT t.id_tesis, t.titulo, t.estado, t.archivo_url, " +
                     "ROUND(AVG(e.calificacion_final), 2) AS promedio " +
                     "FROM tesis t " +
                     "LEFT JOIN evaluaciones e ON t.id_tesis = e.id_tesis " +
                     "WHERE t.id_estudiante = ? " +
                     "GROUP BY t.id_tesis, t.titulo, t.estado, t.archivo_url " +
                     "ORDER BY t.fecha_creacion DESC LIMIT 1";
        
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idEstudiante);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return new Object[]{
                    rs.getString("titulo"),
                    rs.getString("estado"),
                    rs.getDouble("promedio"),
                    rs.getInt("id_tesis"),
                    rs.getString("archivo_url")
                };
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Object[]> listarHistorialPorEstudiante(int idEstudiante) {
        List<Object[]> lista = new ArrayList<>();
        String sql = "SELECT t.id_tesis, t.titulo, t.estado, "
                   + "ROUND(AVG(e.calificacion_final), 2) AS promedio, "
                   + "t.fecha_creacion "
                   + "FROM tesis t "
                   + "LEFT JOIN evaluaciones e ON t.id_tesis = e.id_tesis "
                   + "WHERE t.id_estudiante = ? "
                   + "GROUP BY t.id_tesis "
                   + "ORDER BY t.fecha_creacion DESC";
        
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idEstudiante);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                lista.add(new Object[]{
                    rs.getInt("id_tesis"),
                    rs.getString("titulo"),
                    rs.getString("estado"),
                    rs.getDouble("promedio"),
                    rs.getTimestamp("fecha_creacion")
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }
    
    public Integer obtenerIdTesisActualPorEstudiante(int idEstudiante) {
        String sql = "SELECT id_tesis FROM tesis WHERE id_estudiante = ? " +
                     "ORDER BY fecha_creacion DESC LIMIT 1";
        
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idEstudiante);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("id_tesis");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}