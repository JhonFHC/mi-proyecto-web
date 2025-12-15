package com.zonajava.sistemaevaluaciontesis.dao;

import java.sql.*;
import java.util.*;

public class ResultadoFinalDAO {
    public List<Object[]> listarTesisListas() {
        List<Object[]> lista = new ArrayList<>();
        String sql = "SELECT t.id_tesis, t.titulo, "
                   + "SUM(CASE WHEN e.estado = 'completada' THEN 1 ELSE 0 END) AS completadas "
                   + "FROM tesis t "
                   + "JOIN evaluaciones e ON t.id_tesis = e.id_tesis "
                   + "GROUP BY t.id_tesis, t.titulo "
                   + "HAVING completadas = 3";
        
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                lista.add(new Object[]{
                    rs.getInt("id_tesis"),
                    rs.getString("titulo"),
                    rs.getInt("completadas")
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }
    
    public void actualizarEstadoTesis(int idTesis, String estado) {
        String sql = "UPDATE tesis SET estado = ? WHERE id_tesis = ?";
        
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, estado);
            ps.setInt(2, idTesis);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}