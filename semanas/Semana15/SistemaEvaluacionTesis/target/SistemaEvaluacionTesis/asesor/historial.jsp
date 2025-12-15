<%@ page import="com.zonajava.sistemaevaluaciontesis.model.Usuario" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.dao.AsesorDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    Usuario asesor = (Usuario) session.getAttribute("usuario");
    if (asesor == null || !"asesor".equals(asesor.getRol())) {
        response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
        return;
    }
    
    AsesorDAO dao = new AsesorDAO();
    List<Map<String, Object>> historial = dao.obtenerHistorialEvaluaciones(asesor.getIdUsuario());
%>
<!DOCTYPE html>
<html>
<head>
    <title>Mi Historial</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/global.css">
    <style>
        .navbar {
            background: #2980b9;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .page-title {
            color: #2c3e50;
            margin-bottom: 20px;
        }
        
        .history-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .history-table th {
            background: #34495e;
            color: white;
            padding: 15px;
            text-align: left;
        }
        
        .history-table td {
            padding: 15px;
            border-bottom: 1px solid #ecf0f1;
        }
        
        .history-table tr:hover {
            background: #f8f9fa;
        }
        
        .status-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            color: white;
            display: inline-block;
        }
        
        .empty-state {
            text-align: center;
            padding: 40px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h2>? Historial de Evaluaciones</h2>
        <div style="display: flex; gap: 15px;">
            <a href="<%= request.getContextPath() %>/asesor" style="color: white; text-decoration: none;">
                ? Volver al inicio
            </a>
        </div>
    </div>
    
    <div class="container">
        <h1 class="page-title">? Historial Completo de Evaluaciones</h1>
        
        <% if (historial == null || historial.isEmpty()) { %>
            <div class="empty-state">
                <h3>? No hay historial disponible</h3>
                <p>Aún no has realizado evaluaciones.</p>
            </div>
        <% } else { %>
            <table class="history-table">
                <thead>
                    <tr>
                        <th>Tesis</th>
                        <th>Estudiante</th>
                        <th>Estado</th>
                        <th>Fecha</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, Object> item : historial) { %>
                        <tr>
                            <td><strong><%= item.get("titulo") %></strong></td>
                            <td><%= item.get("estudiante") %></td>
                            <td>
                                <span class="status-badge" 
                                      style="background: <% 
                                          if ("enviada".equals(item.get("estado"))) { %>#f39c12
                                          <% } else if ("en_evaluacion".equals(item.get("estado"))) { %>#3498db
                                          <% } else if ("borrador".equals(item.get("estado"))) { %>#e74c3c
                                          <% } else { %>#95a5a6<% } %>;">
                                    <%= item.get("estado") %>
                                </span>
                            </td>
                            <td>
                                <%= item.get("fecha_creacion") != null ? 
                                    new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(item.get("fecha_creacion")) 
                                    : "" %>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</body>
</html>