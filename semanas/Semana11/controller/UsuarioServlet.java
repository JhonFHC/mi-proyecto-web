package com.zonajava.sistemaevaluaciontesis.controller;

import com.zonajava.sistemaevaluaciontesis.dao.UsuarioDAO;
import com.zonajava.sistemaevaluaciontesis.model.Usuario;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/usuarios")
public class UsuarioServlet extends HttpServlet {
    // El resto del código se mantiene igual...
    private UsuarioDAO usuarioDAO;
    
    @Override
    public void init() {
        usuarioDAO = new UsuarioDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        
        if (usuario == null || !"admin".equals(usuario.getRol())) {
            response.sendRedirect("../vistas/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("buscar".equals(action)) {
            String criterio = request.getParameter("criterio");
            List<Usuario> usuarios = usuarioDAO.buscarUsuarios(criterio);
            request.setAttribute("usuarios", usuarios);
        } else {
            List<Usuario> usuarios = usuarioDAO.obtenerTodosUsuarios();
            request.setAttribute("usuarios", usuarios);
        }
        
        request.getRequestDispatcher("/admin/usuarios.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
        
        if (usuarioSesion == null || !"admin".equals(usuarioSesion.getRol())) {
            response.sendRedirect("../vistas/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("crear".equals(action)) {
            crearUsuario(request, response);
        } else if ("actualizar".equals(action)) {
            actualizarUsuario(request, response);
        } else if ("eliminar".equals(action)) {
            eliminarUsuario(request, response);
        }
    }
    
    private void crearUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Usuario usuario = new Usuario();
        usuario.setNombreCompleto(request.getParameter("nombreCompleto"));
        usuario.setEmail(request.getParameter("email"));
        usuario.setPassword(request.getParameter("password"));
        usuario.setRol(request.getParameter("rol"));
        usuario.setDepartamento(request.getParameter("departamento"));
        
        if (usuarioDAO.crearUsuario(usuario)) {
            response.sendRedirect("usuarios?success=usuario_creado");
        } else {
            response.sendRedirect("usuarios?error=creacion_fallida");
        }
    }
    
    private void actualizarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Usuario usuario = new Usuario();
        usuario.setIdUsuario(Integer.parseInt(request.getParameter("idUsuario")));
        usuario.setNombreCompleto(request.getParameter("nombreCompleto"));
        usuario.setEmail(request.getParameter("email"));
        usuario.setRol(request.getParameter("rol"));
        usuario.setDepartamento(request.getParameter("departamento"));
        usuario.setEstado(request.getParameter("estado"));
        
        if (usuarioDAO.actualizarUsuario(usuario)) {
            response.sendRedirect("usuarios?success=usuario_actualizado");
        } else {
            response.sendRedirect("usuarios?error=actualizacion_fallida");
        }
    }
    
    private void eliminarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
        
        if (usuarioDAO.eliminarUsuario(idUsuario)) {
            response.sendRedirect("usuarios?success=usuario_eliminado");
        } else {
            response.sendRedirect("usuarios?error=eliminacion_fallida");
        }
    }
}
