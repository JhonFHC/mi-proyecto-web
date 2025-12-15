package com.zonajava.sistemaevaluaciontesis.controller;

import com.zonajava.sistemaevaluaciontesis.dao.UsuarioDAO;
import com.zonajava.sistemaevaluaciontesis.model.Usuario;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/usuarios")
public class AdminUsuarioServlet extends HttpServlet {
    
    private UsuarioDAO usuarioDAO;
    
    @Override
    public void init() throws ServletException {
        usuarioDAO = new UsuarioDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Verificar que sea admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
            return;
        }
        
        Usuario admin = (Usuario) session.getAttribute("usuario");
        if (!"admin".equals(admin.getRol())) {
            response.sendRedirect(request.getContextPath() + "/vistas/acceso-denegado.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null) {
            // Listar todos los usuarios
            listarUsuarios(request, response);
        } else {
            switch (action) {
                case "nuevo":
                    mostrarFormularioNuevo(request, response);
                    break;
                case "editar":
                    mostrarFormularioEditar(request, response);
                    break;
                case "eliminar":
                    eliminarUsuario(request, response);
                    break;
                case "ver":
                    verUsuario(request, response);
                    break;
                default:
                    listarUsuarios(request, response);
            }
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("guardar".equals(action)) {
            guardarUsuario(request, response);
        } else if ("actualizar".equals(action)) {
            actualizarUsuario(request, response);
        }
    }
    
    private void listarUsuarios(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Usuario> usuarios = usuarioDAO.listarUsuarios();
        request.setAttribute("usuarios", usuarios);
        request.getRequestDispatcher("/admin/usuarios.jsp").forward(request, response);
    }
    
    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/admin/usuario-form.jsp").forward(request, response);
    }
    
    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        Usuario usuario = usuarioDAO.obtenerPorId(id);
        
        if (usuario != null) {
            request.setAttribute("usuario", usuario);
            request.getRequestDispatcher("/admin/usuario-form.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/usuarios?error=usuarioNoEncontrado");
        }
    }
    
    private void verUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        Usuario usuario = usuarioDAO.obtenerPorId(id);
        
        if (usuario != null) {
            request.setAttribute("usuario", usuario);
            request.getRequestDispatcher("/admin/ver-usuario.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/usuarios?error=usuarioNoEncontrado");
        }
    }
    
    private void eliminarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        Usuario usuarioActual = (Usuario) request.getSession().getAttribute("usuario");
        
        // Verificar que no se elimine a sí mismo
        if (usuarioActual.getIdUsuario() == id) {
            response.sendRedirect(request.getContextPath() + "/admin/usuarios?error=noAutoEliminar");
            return;
        }
        
        usuarioDAO.eliminarUsuario(id);
        response.sendRedirect(request.getContextPath() + "/admin/usuarios?success=usuarioEliminado");
    }
    
    private void guardarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Usuario usuario = new Usuario();
        usuario.setCodigoUpla(request.getParameter("codigoUpla"));
        usuario.setNombreCompleto(request.getParameter("nombreCompleto"));
        usuario.setEmail(request.getParameter("email"));
        usuario.setPassword(request.getParameter("password"));
        usuario.setRol(request.getParameter("rol"));
        usuario.setDepartamento(request.getParameter("departamento"));
        
        usuarioDAO.crearUsuario(usuario);
        response.sendRedirect(request.getContextPath() + "/admin/usuarios?success=usuarioCreado");
    }
    
    private void actualizarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Usuario usuario = new Usuario();
        usuario.setIdUsuario(Integer.parseInt(request.getParameter("idUsuario")));
        usuario.setCodigoUpla(request.getParameter("codigoUpla"));
        usuario.setNombreCompleto(request.getParameter("nombreCompleto"));
        usuario.setEmail(request.getParameter("email"));
        usuario.setRol(request.getParameter("rol"));
        usuario.setDepartamento(request.getParameter("departamento"));
        usuario.setEstado(request.getParameter("estado"));
        
        usuarioDAO.actualizarUsuario(usuario);
        response.sendRedirect(request.getContextPath() + "/admin/usuarios?success=usuarioActualizado");
    }
}