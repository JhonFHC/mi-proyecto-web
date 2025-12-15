package com.zonajava.sistemaevaluaciontesis.dao;

import com.zonajava.sistemaevaluaciontesis.dao.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminDAO {
    public boolean asignarJurados(int idTesis, List<Integer> jurados) {
        if (jurados == null || jurados.isEmpty()) {
            throw new IllegalArgumentException("La lista de jurados no puede estar vacía");
        }
        
        String sqlTesisJurados = 
            "INSERT IGNORE INTO tesis_jurados (id_tesis, id_jurado) VALUES (?, ?)";
        String sqlEvaluaciones = 
            "INSERT INTO evaluaciones (id_tesis, id_jurado, estado) " +
            "VALUES (?, ?, 'pendiente') ON DUPLICATE KEY UPDATE estado = 'pendiente'";
        
        Connection con = null;
        try {
            con = DatabaseConnection.getConnection();
            con.setAutoCommit(false);
            
            try (PreparedStatement psTesisJurados = con.prepareStatement(sqlTesisJurados);
                 PreparedStatement psEvaluaciones = con.prepareStatement(sqlEvaluaciones)) {
                
                for (Integer idJurado : jurados) {
                    if (idJurado == null || idJurado <= 0) {
                        throw new IllegalArgumentException("ID de jurado inválido: " + idJurado);
                    }
                    
                    psTesisJurados.setInt(1, idTesis);
                    psTesisJurados.setInt(2, idJurado);
                    psTesisJurados.executeUpdate();
                    
                    psEvaluaciones.setInt(1, idTesis);
                    psEvaluaciones.setInt(2, idJurado);
                    psEvaluaciones.executeUpdate();
                }
                con.commit();
                return true;
            } catch (SQLException e) {
                if (con != null) {
                    con.rollback();
                }
                throw e;
            }
        } catch (SQLException e) {
            System.err.println("Error al asignar jurados: " + e.getMessage());
            e.printStackTrace();
            return false;
        } catch (IllegalArgumentException e) {
            System.err.println("Error de validación: " + e.getMessage());
            return false;
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    System.err.println("Error al cerrar conexión: " + e.getMessage());
                }
            }
        }
    }
    
    public boolean existenAsignacionesPrevias(int idTesis, List<Integer> jurados) 
            throws SQLException {
        String sql = "SELECT COUNT(*) FROM tesis_jurados WHERE id_tesis = ? AND id_jurado = ?";
        
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            for (Integer idJurado : jurados) {
                ps.setInt(1, idTesis);
                ps.setInt(2, idJurado);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        return true;
                    }
                }
            }
        }
        return false;
    }
    
    public List<Integer> obtenerJuradosAsignados(int idTesis) throws SQLException {
        List<Integer> jurados = new ArrayList<>();
        String sql = "SELECT id_jurado FROM tesis_jurados WHERE id_tesis = ?";
        
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idTesis);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    jurados.add(rs.getInt("id_jurado"));
                }
            }
        }
        return jurados;
    }
    
    public List<Object[]> listarTesisListasParaResultado() {
        List<Object[]> lista = new ArrayList<>();
        String sql = """
            SELECT t.id_tesis, t.titulo, 
                   SUM(CASE WHEN e.estado = 'completada' THEN 1 ELSE 0 END) as completadas
            FROM tesis t
            JOIN evaluaciones e ON t.id_tesis = e.id_tesis
            GROUP BY t.id_tesis, t.titulo
            HAVING completadas >= 3
            """;
        
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(new Object[]{
                    rs.getInt("id_tesis"),
                    rs.getString("titulo"),
                    rs.getInt("completadas")
                });
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}