package com.zonajava.sistemaevaluaciontesis.dao;

import com.zonajava.sistemaevaluaciontesis.model.Usuario;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {
    public Usuario autenticar(String email, String password) {
        String sql = "SELECT * FROM usuarios WHERE email = ? AND password = ? AND estado = 'activo'";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapearUsuario(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Usuario> obtenerAsesores() {
        return obtenerPorRol("asesor");
    }
    
    public List<Usuario> obtenerJurados() {
        return obtenerPorRol("jurado");
    }
    
    private List<Usuario> obtenerPorRol(String rol) {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuarios WHERE rol = ? AND estado = 'activo'";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, rol);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                lista.add(mapearUsuario(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
    
    private Usuario mapearUsuario(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setIdUsuario(rs.getInt("id_usuario"));
        u.setCodigoUpla(rs.getString("codigo_upla"));
        u.setNombreCompleto(rs.getString("nombre_completo"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setRol(rs.getString("rol"));
        u.setDepartamento(rs.getString("departamento"));
        u.setEstado(rs.getString("estado"));
        return u;
    }

    // LISTAR TODOS
    public List<Usuario> listarUsuarios() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuarios";

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Usuario u = mapearUsuario(rs);
                lista.add(u);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    // OBTENER POR ID
    public Usuario obtenerPorId(int id) {
        String sql = "SELECT * FROM usuarios WHERE id_usuario=?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapearUsuario(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // CREAR
    public void crearUsuario(Usuario u) {
        String sql = """
            INSERT INTO usuarios 
            (codigo_upla, nombre_completo, email, password, rol, departamento)
            VALUES (?, ?, ?, ?, ?, ?)
        """;

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, u.getCodigoUpla());
            ps.setString(2, u.getNombreCompleto());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getPassword());
            ps.setString(5, u.getRol());
            ps.setString(6, u.getDepartamento());
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // EDITAR
    public void actualizarUsuario(Usuario u) {
        String sql = """
            UPDATE usuarios 
            SET nombre_completo=?, email=?, rol=?, departamento=?, estado=?
            WHERE id_usuario=?
        """;

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, u.getNombreCompleto());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getRol());
            ps.setString(4, u.getDepartamento());
            ps.setString(5, u.getEstado());
            ps.setInt(6, u.getIdUsuario());
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ELIMINAR
    public void eliminarUsuario(int id) {
        String sql = "DELETE FROM usuarios WHERE id_usuario=?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}