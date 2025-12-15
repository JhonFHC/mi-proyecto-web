package com.zonajava.sistemaevaluaciontesis.dao;

import com.zonajava.sistemaevaluaciontesis.model.CriterioEvaluacion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class CriterioDAO {
    private static final Logger LOGGER = Logger.getLogger(CriterioDAO.class.getName());
    
    public List<CriterioEvaluacion> obtenerTodosCriterios() {
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
            
            LOGGER.info("Obtenidos " + criterios.size() + " criterios de evaluación");
        } catch (SQLException e) {
            LOGGER.severe("Error al obtener criterios: " + e.getMessage());
        } finally {
            cerrarRecursos(conn, stmt, rs);
        }
        return criterios;
    }
    
    public List<CriterioEvaluacion> obtenerPorSeccion(String seccion) {
        List<CriterioEvaluacion> criterios = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT * FROM criterios_evaluacion WHERE seccion = ? AND estado = 'activo' ORDER BY numero";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, seccion);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                CriterioEvaluacion criterio = new CriterioEvaluacion();
                criterio.setIdCriterio(rs.getInt("id_criterio"));
                criterio.setNumero(rs.getInt("numero"));
                criterio.setSeccion(rs.getString("seccion"));
                criterio.setDescripcion(rs.getString("descripcion"));
                criterios.add(criterio);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error al obtener criterios por sección: " + e.getMessage());
        } finally {
            cerrarRecursos(conn, stmt, rs);
        }
        return criterios;
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