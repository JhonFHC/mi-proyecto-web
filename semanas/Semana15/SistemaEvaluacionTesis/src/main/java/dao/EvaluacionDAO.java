package com.zonajava.sistemaevaluaciontesis.dao;

import com.zonajava.sistemaevaluaciontesis.model.Evaluacion;
import com.zonajava.sistemaevaluaciontesis.model.DetalleEvaluacion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class EvaluacionDAO {
    private static final Logger LOGGER = Logger.getLogger(EvaluacionDAO.class.getName());
    
    public int crearEvaluacion(Evaluacion evaluacion) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "INSERT INTO evaluaciones (id_tesis, id_jurado, estado) VALUES (?, ?, 'pendiente')";
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, evaluacion.getIdTesis());
            stmt.setInt(2, evaluacion.getIdJurado());
            stmt.executeUpdate();
            
            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error al crear evaluación: " + e.getMessage());
        } finally {
            cerrarRecursos(conn, stmt, rs);
        }
        return -1;
    }
    
    public boolean guardarDetalleEvaluacion(DetalleEvaluacion detalle) {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "INSERT INTO detalle_evaluaciones (id_evaluacion, id_criterio, puntaje, comentario) VALUES (?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, detalle.getIdEvaluacion());
            stmt.setInt(2, detalle.getIdCriterio());
            stmt.setDouble(3, detalle.getPuntaje());
            stmt.setString(4, detalle.getComentario());
            
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            LOGGER.severe("Error al guardar detalle de evaluación: " + e.getMessage());
            return false;
        } finally {
            cerrarRecursos(conn, stmt, null);
        }
    }
    
    public boolean completarEvaluacion(int idEvaluacion, double calificacionFinal, 
                                      String comentarios, String recomendacion) {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "UPDATE evaluaciones SET calificacion_final = ?, comentarios = ?, "
                       + "recomendacion = ?, estado = 'completada', fecha_evaluacion = NOW() "
                       + "WHERE id_evaluacion = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setDouble(1, calificacionFinal);
            stmt.setString(2, comentarios);
            stmt.setString(3, recomendacion);
            stmt.setInt(4, idEvaluacion);
            
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            LOGGER.severe("Error al completar evaluación: " + e.getMessage());
            return false;
        } finally {
            cerrarRecursos(conn, stmt, null);
        }
    }
    
    public List<Evaluacion> obtenerPorJurado(int idJurado) {
        List<Evaluacion> evaluaciones = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT e.*, t.titulo as tesis_titulo FROM evaluaciones e "
                       + "JOIN tesis t ON e.id_tesis = t.id_tesis "
                       + "WHERE e.id_jurado = ? ORDER BY e.fecha_evaluacion DESC";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idJurado);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                evaluaciones.add(mapearEvaluacion(rs));
            }
        } catch (SQLException e) {
            LOGGER.severe("Error al obtener evaluaciones por jurado: " + e.getMessage());
        } finally {
            cerrarRecursos(conn, stmt, rs);
        }
        return evaluaciones;
    }
    
    public List<DetalleEvaluacion> obtenerDetalleEvaluacion(int idEvaluacion) {
        List<DetalleEvaluacion> detalles = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT de.*, ce.numero, ce.seccion, ce.descripcion "
                       + "FROM detalle_evaluaciones de "
                       + "JOIN criterios_evaluacion ce ON de.id_criterio = ce.id_criterio "
                       + "WHERE de.id_evaluacion = ? ORDER BY ce.numero";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idEvaluacion);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                DetalleEvaluacion detalle = new DetalleEvaluacion();
                detalle.setIdDetalle(rs.getInt("id_detalle"));
                detalle.setIdEvaluacion(rs.getInt("id_evaluacion"));
                detalle.setIdCriterio(rs.getInt("id_criterio"));
                detalle.setPuntaje(rs.getDouble("puntaje"));
                detalle.setComentario(rs.getString("comentario"));
                detalle.setCriterioNumero(rs.getInt("numero"));
                detalle.setCriterioSeccion(rs.getString("seccion"));
                detalle.setCriterioDescripcion(rs.getString("descripcion"));
                detalles.add(detalle);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error al obtener detalle de evaluación: " + e.getMessage());
        } finally {
            cerrarRecursos(conn, stmt, rs);
        }
        return detalles;
    }
    
    public boolean asignarJuradoATesis(int idTesis, int idJurado) {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            
            String checkSql = "SELECT COUNT(*) FROM tesis_jurados WHERE id_tesis = ? AND id_jurado = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setInt(1, idTesis);
            checkStmt.setInt(2, idJurado);
            ResultSet rs = checkStmt.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                return false;
            }
            
            String sql = "INSERT INTO tesis_jurados (id_tesis, id_jurado) VALUES (?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idTesis);
            stmt.setInt(2, idJurado);
            
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                Evaluacion evaluacion = new Evaluacion();
                evaluacion.setIdTesis(idTesis);
                evaluacion.setIdJurado(idJurado);
                crearEvaluacion(evaluacion);
            }
            return rows > 0;
        } catch (SQLException e) {
            LOGGER.severe("Error al asignar jurado: " + e.getMessage());
            return false;
        } finally {
            cerrarRecursos(conn, stmt, null);
        }
    }
    
    public List<Integer> obtenerJuradosDeTesis(int idTesis) {
        List<Integer> jurados = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT id_jurado FROM tesis_jurados WHERE id_tesis = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idTesis);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                jurados.add(rs.getInt("id_jurado"));
            }
        } catch (SQLException e) {
            LOGGER.severe("Error al obtener jurados de tesis: " + e.getMessage());
        } finally {
            cerrarRecursos(conn, stmt, rs);
        }
        return jurados;
    }
    
    private Evaluacion mapearEvaluacion(ResultSet rs) throws SQLException {
        Evaluacion evaluacion = new Evaluacion();
        evaluacion.setIdEvaluacion(rs.getInt("id_evaluacion"));
        evaluacion.setIdTesis(rs.getInt("id_tesis"));
        evaluacion.setIdJurado(rs.getInt("id_jurado"));
        evaluacion.setCalificacionFinal(rs.getDouble("calificacion_final"));
        evaluacion.setComentarios(rs.getString("comentarios"));
        evaluacion.setFechaEvaluacion(rs.getTimestamp("fecha_evaluacion"));
        evaluacion.setEstado(rs.getString("estado"));
        evaluacion.setRecomendacion(rs.getString("recomendacion"));
        evaluacion.setTesisTitulo(rs.getString("tesis_titulo"));
        return evaluacion;
    }
    
    private void cerrarRecursos(Connection conn, PreparedStatement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) DatabaseConnection.closeConnection(conn);
        } catch (SQLException e) {
            LOGGER.warning("Error al cerrar recursos: " + e.getMessage());
        }
    }
}