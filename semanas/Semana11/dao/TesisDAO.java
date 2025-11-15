package com.zonajava.sistemaevaluaciontesis.dao;

import com.zonajava.sistemaevaluaciontesis.model.Tesis;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TesisDAO {
    
    // Crear tesis
    public boolean crearTesis(Tesis tesis) {
        String sql = "INSERT INTO tesis (titulo, descripcion, id_estudiante, id_asesor, archivo_url) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, tesis.getTitulo());
            stmt.setString(2, tesis.getDescripcion());
            stmt.setInt(3, tesis.getIdEstudiante());
            stmt.setInt(4, tesis.getIdAsesor());
            stmt.setString(5, tesis.getArchivoUrl());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Obtener todas las tesis con información de estudiantes y asesores
    public List<Tesis> obtenerTodasTesis() {
        List<Tesis> tesisList = new ArrayList<>();
        String sql = "SELECT t.*, ue.nombre_completo as nombre_estudiante, ua.nombre_completo as nombre_asesor " +
                    "FROM tesis t " +
                    "LEFT JOIN usuarios ue ON t.id_estudiante = ue.id_usuario " +
                    "LEFT JOIN usuarios ua ON t.id_asesor = ua.id_usuario " +
                    "ORDER BY t.fecha_creacion DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Tesis tesis = new Tesis();
                tesis.setIdTesis(rs.getInt("id_tesis"));
                tesis.setTitulo(rs.getString("titulo"));
                tesis.setDescripcion(rs.getString("descripcion"));
                tesis.setIdEstudiante(rs.getInt("id_estudiante"));
                tesis.setIdAsesor(rs.getInt("id_asesor"));
                tesis.setEstado(rs.getString("estado"));
                tesis.setArchivoUrl(rs.getString("archivo_url"));
                tesis.setFechaEnvio(rs.getTimestamp("fecha_envio"));
                tesis.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
                tesis.setNombreEstudiante(rs.getString("nombre_estudiante"));
                tesis.setNombreAsesor(rs.getString("nombre_asesor"));
                tesisList.add(tesis);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tesisList;
    }
    
    // Obtener tesis por estudiante
    public List<Tesis> obtenerTesisPorEstudiante(int idEstudiante) {
        List<Tesis> tesisList = new ArrayList<>();
        String sql = "SELECT t.*, ue.nombre_completo as nombre_estudiante, ua.nombre_completo as nombre_asesor " +
                    "FROM tesis t " +
                    "LEFT JOIN usuarios ue ON t.id_estudiante = ue.id_usuario " +
                    "LEFT JOIN usuarios ua ON t.id_asesor = ua.id_usuario " +
                    "WHERE t.id_estudiante = ? " +
                    "ORDER BY t.fecha_creacion DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idEstudiante);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Tesis tesis = new Tesis();
                tesis.setIdTesis(rs.getInt("id_tesis"));
                tesis.setTitulo(rs.getString("titulo"));
                tesis.setDescripcion(rs.getString("descripcion"));
                tesis.setIdEstudiante(rs.getInt("id_estudiante"));
                tesis.setIdAsesor(rs.getInt("id_asesor"));
                tesis.setEstado(rs.getString("estado"));
                tesis.setArchivoUrl(rs.getString("archivo_url"));
                tesis.setFechaEnvio(rs.getTimestamp("fecha_envio"));
                tesis.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
                tesis.setNombreEstudiante(rs.getString("nombre_estudiante"));
                tesis.setNombreAsesor(rs.getString("nombre_asesor"));
                tesisList.add(tesis);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tesisList;
    }
    
    // Obtener tesis por asesor
    public List<Tesis> obtenerTesisPorAsesor(int idAsesor) {
        List<Tesis> tesisList = new ArrayList<>();
        String sql = "SELECT t.*, ue.nombre_completo as nombre_estudiante, ua.nombre_completo as nombre_asesor " +
                    "FROM tesis t " +
                    "LEFT JOIN usuarios ue ON t.id_estudiante = ue.id_usuario " +
                    "LEFT JOIN usuarios ua ON t.id_asesor = ua.id_usuario " +
                    "WHERE t.id_asesor = ? " +
                    "ORDER BY t.fecha_creacion DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idAsesor);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Tesis tesis = new Tesis();
                tesis.setIdTesis(rs.getInt("id_tesis"));
                tesis.setTitulo(rs.getString("titulo"));
                tesis.setDescripcion(rs.getString("descripcion"));
                tesis.setIdEstudiante(rs.getInt("id_estudiante"));
                tesis.setIdAsesor(rs.getInt("id_asesor"));
                tesis.setEstado(rs.getString("estado"));
                tesis.setArchivoUrl(rs.getString("archivo_url"));
                tesis.setFechaEnvio(rs.getTimestamp("fecha_envio"));
                tesis.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
                tesis.setNombreEstudiante(rs.getString("nombre_estudiante"));
                tesis.setNombreAsesor(rs.getString("nombre_asesor"));
                tesisList.add(tesis);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tesisList;
    }
    
    // Actualizar estado de tesis
    public boolean actualizarEstadoTesis(int idTesis, String estado) {
        String sql = "UPDATE tesis SET estado = ?, fecha_envio = CASE WHEN ? = 'enviada' THEN NOW() ELSE fecha_envio END WHERE id_tesis = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, estado);
            stmt.setString(2, estado);
            stmt.setInt(3, idTesis);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Buscar tesis
    public List<Tesis> buscarTesis(String criterio) {
        List<Tesis> tesisList = new ArrayList<>();
        String sql = "SELECT t.*, ue.nombre_completo as nombre_estudiante, ua.nombre_completo as nombre_asesor " +
                    "FROM tesis t " +
                    "LEFT JOIN usuarios ue ON t.id_estudiante = ue.id_usuario " +
                    "LEFT JOIN usuarios ua ON t.id_asesor = ua.id_usuario " +
                    "WHERE t.titulo LIKE ? OR t.descripcion LIKE ? OR ue.nombre_completo LIKE ? " +
                    "ORDER BY t.fecha_creacion DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String likeCriterio = "%" + criterio + "%";
            stmt.setString(1, likeCriterio);
            stmt.setString(2, likeCriterio);
            stmt.setString(3, likeCriterio);
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Tesis tesis = new Tesis();
                tesis.setIdTesis(rs.getInt("id_tesis"));
                tesis.setTitulo(rs.getString("titulo"));
                tesis.setDescripcion(rs.getString("descripcion"));
                tesis.setIdEstudiante(rs.getInt("id_estudiante"));
                tesis.setIdAsesor(rs.getInt("id_asesor"));
                tesis.setEstado(rs.getString("estado"));
                tesis.setArchivoUrl(rs.getString("archivo_url"));
                tesis.setFechaEnvio(rs.getTimestamp("fecha_envio"));
                tesis.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
                tesis.setNombreEstudiante(rs.getString("nombre_estudiante"));
                tesis.setNombreAsesor(rs.getString("nombre_asesor"));
                tesisList.add(tesis);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tesisList;
    }
    
    // Asignar jurados a tesis
    public boolean asignarJurados(int idTesis, List<Integer> idJurados) {
        String sql = "INSERT INTO tesis_jurados (id_tesis, id_jurado) VALUES (?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            // Eliminar asignaciones anteriores
            eliminarJuradosTesis(idTesis);
            
            // Insertar nuevos jurados
            for (Integer idJurado : idJurados) {
                stmt.setInt(1, idTesis);
                stmt.setInt(2, idJurado);
                stmt.addBatch();
            }
            
            stmt.executeBatch();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Eliminar jurados de tesis
    private void eliminarJuradosTesis(int idTesis) throws SQLException {
        String sql = "DELETE FROM tesis_jurados WHERE id_tesis = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idTesis);
            stmt.executeUpdate();
        }
    }
    
    // Obtener jurados asignados a tesis
    public List<Integer> obtenerJuradosTesis(int idTesis) {
        List<Integer> jurados = new ArrayList<>();
        String sql = "SELECT id_jurado FROM tesis_jurados WHERE id_tesis = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idTesis);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                jurados.add(rs.getInt("id_jurado"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return jurados;
    }
    
        // Actualizar tesis (método simplificado para la versión 1.0)
    public boolean actualizarTesis(Tesis tesis) {
        String sql = "UPDATE tesis SET titulo = ?, descripcion = ?, id_asesor = ?, archivo_url = ? WHERE id_tesis = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, tesis.getTitulo());
            stmt.setString(2, tesis.getDescripcion());
            stmt.setInt(3, tesis.getIdAsesor());
            stmt.setString(4, tesis.getArchivoUrl());
            stmt.setInt(5, tesis.getIdTesis());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}