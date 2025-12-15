package com.zonajava.sistemaevaluaciontesis.dao;

import com.zonajava.sistemaevaluaciontesis.model.CriterioEvaluacion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class CriterioEvaluacionDAO {
    private static final Logger LOGGER = Logger.getLogger(CriterioEvaluacionDAO.class.getName());
    
    public List<CriterioEvaluacion> obtenerCriteriosActivos() {
        List<CriterioEvaluacion> criterios = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT * FROM criterios_evaluacion WHERE estado = 'activo' ORDER BY numero";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                CriterioEvaluacion criterio = new CriterioEvaluacion();
                criterio.setIdCriterio(rs.getInt("id_criterio"));
                criterio.setNumero(rs.getInt("numero"));
                criterio.setSeccion(rs.getString("seccion"));
                criterio.setDescripcion(rs.getString("descripcion"));
                criterio.setPeso(rs.getDouble("peso"));
                criterio.setEstado(rs.getString("estado"));
                criterios.add(criterio);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error al obtener criterios activos: " + e.getMessage());
        } finally {
            cerrarRecursos(conn, stmt, rs);
        }
        return criterios;
    }
    
    public CriterioEvaluacion obtenerPorId(int idCriterio) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT * FROM criterios_evaluacion WHERE id_criterio = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idCriterio);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                CriterioEvaluacion criterio = new CriterioEvaluacion();
                criterio.setIdCriterio(rs.getInt("id_criterio"));
                criterio.setNumero(rs.getInt("numero"));
                criterio.setSeccion(rs.getString("seccion"));
                criterio.setDescripcion(rs.getString("descripcion"));
                criterio.setPeso(rs.getDouble("peso"));
                criterio.setEstado(rs.getString("estado"));
                return criterio;
            }
        } catch (SQLException e) {
            LOGGER.severe("Error al obtener criterio por ID: " + e.getMessage());
        } finally {
            cerrarRecursos(conn, stmt, rs);
        }
        return null;
    }
    
    public int obtenerTotalCriterios() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT COUNT(*) FROM criterios_evaluacion WHERE estado = 'activo'";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error al obtener total de criterios: " + e.getMessage());
        } finally {
            cerrarRecursos(conn, stmt, rs);
        }
        return 0;
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