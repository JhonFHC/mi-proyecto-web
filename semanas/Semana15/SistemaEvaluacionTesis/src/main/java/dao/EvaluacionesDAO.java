package com.zonajava.sistemaevaluaciontesis.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EvaluacionesDAO {
    public List<Object[]> listarPendientesPorJurado(int idJurado) {
        List<Object[]> lista = new ArrayList<>();
        String sql = "SELECT e.id_evaluacion, t.id_tesis, t.titulo "
                   + "FROM evaluaciones e "
                   + "INNER JOIN tesis t ON e.id_tesis = t.id_tesis "
                   + "WHERE e.id_jurado = ? AND e.estado = 'pendiente'";
        
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idJurado);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                lista.add(new Object[]{
                    rs.getInt("id_evaluacion"),
                    rs.getInt("id_tesis"),
                    rs.getString("titulo")
                });
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}