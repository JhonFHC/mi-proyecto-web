package com.zonajava.sistemaevaluaciontesis.filter;

import com.zonajava.sistemaevaluaciontesis.model.Usuario;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(
    filterName = "AuthFilter",
    urlPatterns = {"/admin/*", "/asesor/*", "/estudiante/*", "/jurado/*"},
    dispatcherTypes = { DispatcherType.REQUEST, DispatcherType.FORWARD }
)
public class AuthFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("✅ AuthFilter inicializado");
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, 
                         FilterChain chain) throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        String path = httpRequest.getRequestURI();
        
        System.out.println("🔍 AuthFilter - Path: " + path);
        
        if (session == null) {
            System.out.println("❌ Sesión nula, redirigiendo a login");
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/vistas/login.jsp");
            return;
        }
        
        Usuario u = (Usuario) session.getAttribute("usuario");
        if (u == null) {
            System.out.println("❌ Usuario no autenticado en sesión, redirigiendo a login");
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/vistas/login.jsp");
            return;
        }
        
        String rol = u.getRol();
        if (!tienePermiso(rol, path)) {
            System.out.println("❌ Acceso denegado para rol: " + rol + " a ruta: " + path);
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/vistas/acceso-denegado.jsp");
            return;
        }
        
        System.out.println("✅ Acceso permitido para: " + u.getEmail() + " (" + rol + ")");
        chain.doFilter(request, response);
    }
    
    private boolean tienePermiso(String rol, String path) {
        if (path.contains("/admin/") && !"admin".equals(rol)) {
            return false;
        }
        if (path.contains("/asesor/") && !"asesor".equals(rol)) {
            return false;
        }
        if (path.contains("/estudiante/") && !"estudiante".equals(rol)) {
            return false;
        }
        if (path.contains("/jurado/") && !"jurado".equals(rol)) {
            return false;
        }
        return true;
    }
    
    @Override
    public void destroy() {
        System.out.println("✅ AuthFilter destruido");
    }
}