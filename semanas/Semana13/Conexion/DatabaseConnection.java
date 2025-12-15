package com.zonajava.sistemaevaluaciontesis.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Logger;

public class DatabaseConnection {
    private static final Logger LOGGER = Logger.getLogger(DatabaseConnection.class.getName());
    
    private static final String URL = "jdbc:mysql://localhost:3306/sistema_evaluacion_tesis";
    private static final String USER = "gestion";
    private static final String PASSWORD = "admin123";
    
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            LOGGER.info("Driver MySQL cargado correctamente");
        } catch (ClassNotFoundException e) {
            LOGGER.severe("Error al cargar el driver MySQL: " + e.getMessage());
            throw new RuntimeException("No se pudo cargar el driver MySQL", e);
        }
    }
    
    private DatabaseConnection() { }
    
    public static Connection getConnection() throws SQLException {
        try {
            Connection connection = DriverManager.getConnection(URL, USER, PASSWORD);
            LOGGER.info("Conexión establecida con éxito a MySQL");
            return connection;
        } catch (SQLException e) {
            LOGGER.severe("Error al conectar a MySQL: " + e.getMessage());
            throw new SQLException("No se pudo conectar a la base de datos", e);
        }
    }
    
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
                LOGGER.fine("Conexión cerrada");
            } catch (SQLException e) {
                LOGGER.warning("Error al cerrar conexión: " + e.getMessage());
            }
        }
    }
}