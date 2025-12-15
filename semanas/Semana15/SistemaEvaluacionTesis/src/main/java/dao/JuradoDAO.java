package com.zonajava.sistemaevaluaciontesis.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Map;

public class JuradoDAO {
    public boolean guardarEvaluacion(
            int idEvaluacion,
            Map<Integer, Double> puntajes,
            Map<Integer, String> comentarios,
            double calificacionFinal) {
        
        String sqlDetalle = "INSERT INTO detalle_evaluaciones (id_evaluacion, id_criterio, puntaje, comentario) "
                          + "VALUES (?, ?, ?, ?)";
        String sqlEval = "UPDATE evaluaciones SET calificacion_final = ?, estado = 'completada' "
                       + "WHERE id_evaluacion = ?";
        
        try (Connection con = DatabaseConnection.getConnection()) {
            con.setAutoCommit(false);
            
            try (PreparedStatement ps1 = con.prepareStatement(sqlDetalle);
                 PreparedStatement ps2 = con.prepareStatement(sqlEval)) {
                
                for (Integer idCriterio : puntajes.keySet()) {
                    ps1.setInt(1, idEvaluacion);
                    ps1.setInt(2, idCriterio);
                    ps1.setDouble(3, puntajes.get(idCriterio));
                    ps1.setString(4, comentarios.get(idCriterio));
                    ps1.executeUpdate();
                }
                
                ps2.setDouble(1, calificacionFinal);
                ps2.setInt(2, idEvaluacion);
                ps2.executeUpdate();
                
                con.commit();
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}