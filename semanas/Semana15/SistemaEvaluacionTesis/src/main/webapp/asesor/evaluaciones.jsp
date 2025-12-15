<%@ page import="com.zonajava.sistemaevaluaciontesis.model.Usuario" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.dao.TesisDAO" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.model.Tesis" %>
<%@ page import="java.util.List" %>
<%
    Usuario asesor = (Usuario) session.getAttribute("usuario");
    if (asesor == null || !"asesor".equals(asesor.getRol())) {
        response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
        return;
    }
    
    TesisDAO dao = new TesisDAO();
    List<Tesis> tesisPendientes = dao.listarPorAsesor(asesor.getIdUsuario());
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Evaluaciones Pendientes</title>
    <style>
        /* Mismo estilo que dashboard.jsp */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            margin: 0;
            padding: 0;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .header {
            background: linear-gradient(to right, #2980b9, #2c3e50);
            color: white;
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            border-radius: 8px;
        }
        
        .nav-links {
            display: flex;
            gap: 1rem;
        }
        
        .nav-links a {
            color: white;
            text-decoration: none;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            transition: background 0.3s;
        }
        
        .nav-links a:hover {
            background: rgba(255,255,255,0.1);
        }
        
        .page-title {
            color: #2c3e50;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .pendientes-list {
            background: white;
            border-radius: 8px;
            padding: 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .pendiente-item {
            padding: 1rem;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .pendiente-item:last-child {
            border-bottom: none;
        }
        
        .btn-evaluar {
            background: #27ae60;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #7f8c8d;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>Evaluaciones Pendientes</h2>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/asesor">Inicio</a>
                <a href="<%= request.getContextPath() %>/asesor/dashboard.jsp">Dashboard</a>
                <a href="<%= request.getContextPath() %>/asesor/ver-perfil.jsp">Mi Perfil</a>
                <a href="<%= request.getContextPath() %>/logout">Cerrar Sesión</a>
            </div>
        </div>
        
        <h1 class="page-title">
            <i class="fas fa-clipboard-list"></i> Tesis Pendientes de Evaluación
        </h1>
        
        <div class="pendientes-list">
            <% if (tesisPendientes == null || tesisPendientes.isEmpty()) { %>
                <div class="empty-state">
                    <h3>No hay evaluaciones pendientes</h3>
                    <p>Todas las tesis asignadas han sido evaluadas.</p>
                </div>
            <% } else { 
                for (Tesis t : tesisPendientes) { 
                    if ("enviada".equals(t.getEstado())) { %>
                        <div class="pendiente-item">
                            <div>
                                <h3><%= t.getTitulo() %></h3>
                                <p>Estudiante: <%= t.getEstudianteNombre() %></p>
                                <p>Fecha: <%= t.getFechaCreacion() != null ? 
                                    new java.text.SimpleDateFormat("dd/MM/yyyy").format(t.getFechaCreacion()) 
                                    : "N/A" %></p>
                            </div>
                            <a href="<%= request.getContextPath() %>/asesor/evaluar.jsp?id_tesis=<%= t.getIdTesis() %>" 
                               class="btn-evaluar">
                                <i class="fas fa-clipboard-check"></i> Evaluar
                            </a>
                        </div>
                    <% } 
                } 
            } %>
        </div>
    </div>
</body>
</html>