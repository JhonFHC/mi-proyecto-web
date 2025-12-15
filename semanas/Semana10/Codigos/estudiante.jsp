<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.model.Usuario" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.model.Tesis" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.dao.TesisDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Verificar sesión
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null || !"estudiante".equals(usuario.getRol())) {
        response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
        return;
    }
    
    // Obtener datos del DAO
    TesisDAO dao = new TesisDAO();
    
    // Obtener tesis actual del estudiante
    Object[] tesisActual = dao.obtenerResultadoFinalPorEstudiante(usuario.getIdUsuario());
    
    // Obtener historial de tesis
    List<Tesis> listaTesis = dao.listarPorEstudiante(usuario.getIdUsuario());
    
    // Obtener historial detallado
    List<Object[]> historial = dao.listarHistorialPorEstudiante(usuario.getIdUsuario());
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdfCompleto = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Estudiante</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }
        
        body {
            background-color: #f5f7fa;
            color: #333;
            min-height: 100vh;
        }
        
        /* Header */
        .header {
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
            color: white;
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        
        .header-logo {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.3rem;
            font-weight: 600;
        }
        
        .header-user {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .user-info {
            text-align: right;
        }
        
        .user-name {
            font-weight: 500;
            font-size: 1.1rem;
        }
        
        .user-details {
            font-size: 0.85rem;
            opacity: 0.9;
            margin-top: 2px;
        }
        
        .header-actions {
            display: flex;
            gap: 10px;
        }
        
        .header-btn {
            background: rgba(255,255,255,0.2);
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 20px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 5px;
            transition: all 0.3s;
            text-decoration: none;
            font-size: 0.9rem;
        }
        
        .header-btn:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-2px);
        }
        
        /* Container */
        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1.5rem;
        }
        
        /* Welcome Banner */
        .welcome-banner {
            background: linear-gradient(135deg, #27ae60 0%, #219653 100%);
            color: white;
            border-radius: 12px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 6px 15px rgba(39, 174, 96, 0.3);
        }
        
        .welcome-title {
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .welcome-subtitle {
            opacity: 0.95;
            margin-bottom: 1rem;
        }
        
        .welcome-info {
            background: rgba(255,255,255,0.15);
            padding: 1rem;
            border-radius: 8px;
            margin-top: 1rem;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 0.5rem;
        }
        
        .info-item {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        /* Main Content Grid */
        .content-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 2rem;
            margin-bottom: 2rem;
        }
        
        @media (max-width: 768px) {
            .content-grid {
                grid-template-columns: 1fr;
            }
        }
        
        /* Cards */
        .card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            height: 100%;
        }
        
        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .card-title {
            color: #3498db;
            font-size: 1.3rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .card-badge {
            background: #e3f2fd;
            color: #3498db;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        
        /* Current Thesis */
        .current-thesis {
            border-left: 4px solid #3498db;
        }
        
        .thesis-details {
            margin: 1.5rem 0;
        }
        
        .detail-item {
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .detail-label {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .detail-value {
            font-size: 1.1rem;
            font-weight: 500;
            color: #2c3e50;
        }
        
        /* Badges */
        .status-badge {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-borrador { background: #fff3cd; color: #856404; }
        .status-enviada { background: #cce5ff; color: #004085; }
        .status-en_evaluacion { background: #d4edda; color: #155724; }
        .status-aprobada { background: #d1ecf1; color: #0c5460; }
        .status-rechazada { background: #f8d7da; color: #721c24; }
        
        .score-high { color: #27ae60; font-weight: 700; }
        .score-medium { color: #f39c12; font-weight: 700; }
        .score-low { color: #e74c3c; font-weight: 700; }
        .score-none { color: #95a5a6; }
        
        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
        }
        
        .btn {
            padding: 10px 20px;
            border-radius: 6px;
            font-weight: 500;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
            text-decoration: none;
            border: none;
            font-size: 0.95rem;
        }
        
        .btn-primary {
            background: #3498db;
            color: white;
        }
        
        .btn-primary:hover {
            background: #2980b9;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(52, 152, 219, 0.3);
        }
        
        .btn-success {
            background: #27ae60;
            color: white;
        }
        
        .btn-success:hover {
            background: #219653;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(39, 174, 96, 0.3);
        }
        
        .btn-danger {
            background: #e74c3c;
            color: white;
        }
        
        .btn-danger:hover {
            background: #c0392b;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(231, 76, 60, 0.3);
        }
        
        .btn-warning {
            background: #f39c12;
            color: white;
        }
        
        .btn-warning:hover {
            background: #e67e22;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(243, 156, 18, 0.3);
        }
        
        .btn-secondary {
            background: #95a5a6;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #7f8c8d;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(149, 165, 166, 0.3);
        }
        
        /* Thesis Table */
        .thesis-table {
            margin-top: 1rem;
        }
        
        .thesis-table table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .thesis-table th {
            background: #f8f9fa;
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            color: #2c3e50;
            border-bottom: 2px solid #e0e0e0;
            font-size: 0.9rem;
        }
        
        .thesis-table td {
            padding: 1rem;
            border-bottom: 1px solid #f0f0f0;
            font-size: 0.9rem;
        }
        
        .thesis-table tr:hover {
            background: #f8f9fa;
        }
        
        /* Quick Actions */
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-top: 2rem;
        }
        
        .action-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            text-decoration: none;
            color: inherit;
            transition: all 0.3s;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            border: 2px solid transparent;
        }
        
        .action-card:hover {
            transform: translateY(-5px);
            border-color: #3498db;
            box-shadow: 0 10px 20px rgba(52, 152, 219, 0.15);
        }
        
        .action-card h3 {
            color: #3498db;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.2rem;
        }
        
        .action-card p {
            color: #666;
            font-size: 0.9rem;
            line-height: 1.5;
        }
        
        /* Empty States */
        .empty-state {
            text-align: center;
            padding: 2rem;
            color: #95a5a6;
        }
        
        .empty-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }
        
        /* Alerts */
        .alert {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .header {
                padding: 1rem;
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }
            
            .header-user {
                flex-direction: column;
            }
            
            .container {
                padding: 0 1rem;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .thesis-table {
                overflow-x: auto;
            }
            
            .thesis-table table {
                min-width: 600px;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="header-logo">
            <i class="fas fa-graduation-cap"></i>
            <span>Sistema de Evaluación de Tesis</span>
        </div>
        <div class="header-user">
            <div class="user-info">
                <div class="user-name"><%= usuario.getNombreCompleto() %></div>
                <div class="user-details">
                    <%= usuario.getCodigoUpla() %> | <%= usuario.getDepartamento() %>
                </div>
            </div>
            <div class="header-actions">
                <a href="<%= request.getContextPath() %>/logout" class="header-btn">
                    <i class="fas fa-sign-out-alt"></i> Cerrar Sesión
                </a>
            </div>
        </div>
    </div>
    
    <div class="container">
        <!-- Alerts -->
        <%
            String success = request.getParameter("success");
            if (success != null) {
        %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <div>
                    <strong>¡Éxito!</strong><br>
                    <%= 
                        success.equals("tesis_subida") ? "Tesis subida correctamente" :
                        success.equals("tesis_editada") ? "Tesis actualizada correctamente" :
                        success.equals("tesis_eliminada") ? "Tesis eliminada correctamente" :
                        "Operación realizada con éxito"
                    %>
                </div>
            </div>
        <%
            }
            
            String error = request.getParameter("error");
            if (error != null) {
        %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-triangle"></i>
                <div>
                    <strong>¡Atención!</strong><br>
                    <%= 
                        error.equals("acceso_denegado") ? "No tienes permiso para realizar esta acción" :
                        error.equals("tesis_no_borrador") ? "Solo puedes modificar tesis en estado 'borrador'" :
                        "Ocurrió un error inesperado"
                    %>
                </div>
            </div>
        <%
            }
        %>
        
        <!-- Welcome Banner -->
        <div class="welcome-banner">
            <h1 class="welcome-title">
                <i class="fas fa-user-graduate"></i> ¡Bienvenido, <%= usuario.getNombreCompleto() %>!
            </h1>
            <p class="welcome-subtitle">Gestión de tu proceso de evaluación de tesis</p>
            
            <div class="welcome-info">
                <p><strong><i class="fas fa-info-circle"></i> Regla Importante:</strong> Solo puedes modificar tesis en estado "borrador". Una vez enviada, no podrás editarla.</p>
                
                <div class="info-grid">
                    <div class="info-item">
                        <i class="fas fa-id-card"></i>
                        <span><strong>Código:</strong> <%= usuario.getCodigoUpla() %></span>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-university"></i>
                        <span><strong>Departamento:</strong> <%= usuario.getDepartamento() %></span>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-envelope"></i>
                        <span><strong>Email:</strong> <%= usuario.getEmail() %></span>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Main Content Grid -->
        <div class="content-grid">
            <!-- Left Column: Current Thesis -->
            <div class="card current-thesis">
                <div class="card-header">
                    <h2 class="card-title">
                        <i class="fas fa-file-alt"></i> Mi Tesis Actual
                    </h2>
                    <%
                        if (tesisActual != null) {
                            String estado = (String) tesisActual[1];
                    %>
                        <span class="card-badge">
                            <%= listaTesis.size() %> tesis registradas
                        </span>
                    <%
                        }
                    %>
                </div>
                
                <%
                    if (tesisActual == null) {
                %>
                    <div class="empty-state">
                        <div class="empty-icon">
                            <i class="fas fa-file-alt"></i>
                        </div>
                        <h3>No tienes tesis registrada</h3>
                        <p>Comienza subiendo tu primera tesis para evaluación</p>
                        <a href="subir-tesis.jsp" class="btn btn-success" style="margin-top: 1rem;">
                            <i class="fas fa-upload"></i> Subir Primera Tesis
                        </a>
                    </div>
                <%
                    } else {
                        String titulo = (String) tesisActual[0];
                        String estado = (String) tesisActual[1];
                        Double promedio = (Double) tesisActual[2];
                %>
                    <div class="thesis-details">
                        <div class="detail-item">
                            <div class="detail-label">
                                <i class="fas fa-heading"></i> Título
                            </div>
                            <div class="detail-value"><%= titulo %></div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-label">
                                <i class="fas fa-tag"></i> Estado Actual
                            </div>
                            <div class="detail-value">
                                <span class="status-badge status-<%= estado.toLowerCase().replace("á", "a") %>">
                                    <%= estado %>
                                </span>
                            </div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-label">
                                <i class="fas fa-chart-line"></i> Promedio Final
                            </div>
                            <div class="detail-value">
                                <%
                                    if (promedio != null && promedio > 0) {
                                        String scoreClass = "score-none";
                                        if (promedio >= 16.0) scoreClass = "score-high";
                                        else if (promedio >= 13.0) scoreClass = "score-medium";
                                        else if (promedio > 0) scoreClass = "score-low";
                                %>
                                    <span class="<%= scoreClass %>">
                                        <%= String.format("%.2f", promedio) %> / 20
                                    </span>
                                <%
                                    } else {
                                %>
                                    <span class="score-none">Sin calificar</span>
                                <%
                                    }
                                %>
                            </div>
                        </div>
                        
                        <%
                            // Mostrar datos adicionales de la primera tesis si existe
                            if (!listaTesis.isEmpty()) {
                                Tesis primeraTesis = listaTesis.get(0);
                        %>
                            <div class="detail-item">
                                <div class="detail-label">
                                    <i class="fas fa-user-tie"></i> Asesor Asignado
                                </div>
                                <div class="detail-value"><%= primeraTesis.getAsesorNombre() %></div>
                            </div>
                            
                            <div class="detail-item">
                                <div class="detail-label">
                                    <i class="fas fa-calendar-alt"></i> Fecha de Envío
                                </div>
                                <div class="detail-value">
                                    <%= primeraTesis.getFechaCreacion() != null ? 
                                        sdf.format(primeraTesis.getFechaCreacion()) : "No disponible" %>
                                </div>
                            </div>
                        <%
                            }
                        %>
                    </div>
                    
                    <!-- Action Buttons -->
                    <div class="action-buttons">
                        <%
                            if ("borrador".equals(estado)) {
                        %>
                            <a href="subir-tesis.jsp" class="btn btn-primary">
                                <i class="fas fa-edit"></i> Editar Tesis
                            </a>
                            <a href="#" class="btn btn-danger" onclick="confirmarEliminacion()">
                                <i class="fas fa-trash-alt"></i> Eliminar
                            </a>
                        <%
                            } else {
                        %>
                            <a href="mis-tesis.jsp" class="btn btn-primary">
                                <i class="fas fa-eye"></i> Ver Detalles
                            </a>
                            <a href="<%= request.getContextPath() %>/ver-tesis?file=<%= !listaTesis.isEmpty() ? listaTesis.get(0).getArchivoUrl() : "" %>" 
                               target="_blank" class="btn btn-success">
                                <i class="fas fa-file-pdf"></i> Ver PDF
                            </a>
                        <%
                            }
                        %>
                    </div>
                <%
                    }
                %>
            </div>
            
            <!-- Right Column: Quick Stats -->
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">
                        <i class="fas fa-chart-bar"></i> Resumen
                    </h2>
                </div>
                
                <div class="thesis-details">
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-folder-open"></i> Total de Tesis
                        </div>
                        <div class="detail-value" style="font-size: 1.5rem;">
                            <%= listaTesis.size() %>
                        </div>
                    </div>
                    
                    <%
                        int borrador = 0, enviada = 0, evaluacion = 0, aprobada = 0, rechazada = 0;
                        for (Tesis t : listaTesis) {
                            switch(t.getEstado().toLowerCase()) {
                                case "borrador": borrador++; break;
                                case "enviada": enviada++; break;
                                case "en_evaluacion": evaluacion++; break;
                                case "aprobada": aprobada++; break;
                                case "rechazada": rechazada++; break;
                            }
                        }
                    %>
                    
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-clock"></i> En Borrador
                        </div>
                        <div class="detail-value">
                            <span class="status-badge status-borrador"><%= borrador %></span>
                        </div>
                    </div>
                    
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-paper-plane"></i> Enviadas
                        </div>
                        <div class="detail-value">
                            <span class="status-badge status-enviada"><%= enviada %></span>
                        </div>
                    </div>
                    
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-search"></i> En Evaluación
                        </div>
                        <div class="detail-value">
                            <span class="status-badge status-en_evaluacion"><%= evaluacion %></span>
                        </div>
                    </div>
                    
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-check-circle"></i> Aprobadas
                        </div>
                        <div class="detail-value">
                            <span class="status-badge status-aprobada"><%= aprobada %></span>
                        </div>
                    </div>
                    
                    <div class="detail-item">
                        <div class="detail-label">
                            <i class="fas fa-times-circle"></i> Rechazadas
                        </div>
                        <div class="detail-value">
                            <span class="status-badge status-rechazada"><%= rechazada %></span>
                        </div>
                    </div>
                </div>
                
                <div style="margin-top: 1.5rem;">
                    <a href="mis-tesis.jsp" class="btn btn-secondary" style="width: 100%;">
                        <i class="fas fa-list"></i> Ver Todas Mis Tesis
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Recent History -->
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">
                    <i class="fas fa-history"></i> Historial Reciente
                </h2>
                <span class="card-badge">
                    <%= historial != null ? historial.size() : 0 %> registros
                </span>
            </div>
            
            <%
                if (historial == null || historial.isEmpty()) {
            %>
                <div class="empty-state">
                    <div class="empty-icon">
                        <i class="fas fa-history"></i>
                    </div>
                    <h3>No hay historial disponible</h3>
                    <p>Tu historial aparecerá aquí cuando tengas tesis registradas</p>
                </div>
            <%
                } else {
                    // Mostrar solo los últimos 5 registros
                    int limit = Math.min(5, historial.size());
            %>
                <div class="thesis-table">
                    <table>
                        <thead>
                            <tr>
                                <th>Título</th>
                                <th>Estado</th>
                                <th>Promedio</th>
                                <th>Fecha</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (int i = 0; i < limit; i++) {
                                    Object[] row = historial.get(i);
                                    Integer idTesis = (Integer) row[0];
                                    String titulo = (String) row[1];
                                    String estado = (String) row[2];
                                    Double promedio = (Double) row[3];
                                    java.sql.Timestamp fecha = (java.sql.Timestamp) row[4];
                            %>
                                <tr>
                                    <td style="font-weight: 500;">
                                        <%= titulo.length() > 40 ? titulo.substring(0, 40) + "..." : titulo %>
                                    </td>
                                    <td>
                                        <span class="status-badge status-<%= estado.toLowerCase().replace("á", "a") %>">
                                            <%= estado %>
                                        </span>
                                    </td>
                                    <td>
                                        <%
                                            if (promedio != null && promedio > 0) {
                                                String scoreClass = "score-none";
                                                if (promedio >= 16.0) scoreClass = "score-high";
                                                else if (promedio >= 13.0) scoreClass = "score-medium";
                                                else if (promedio > 0) scoreClass = "score-low";
                                        %>
                                            <span class="<%= scoreClass %>">
                                                <%= String.format("%.2f", promedio) %>
                                            </span>
                                        <%
                                            } else {
                                        %>
                                            <span class="score-none">-</span>
                                        <%
                                            }
                                        %>
                                    </td>
                                    <td><%= fecha != null ? sdfCompleto.format(fecha) : "-" %></td>
                                    <td>
                                        <%
                                            if ("borrador".equals(estado)) {
                                        %>
                                            <a href="subir-tesis.jsp?id=<%= idTesis %>" class="btn btn-primary" style="padding: 5px 10px; font-size: 0.85rem;">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                        <%
                                            } else {
                                        %>
                                            <a href="mis-tesis.jsp" class="btn btn-secondary" style="padding: 5px 10px; font-size: 0.85rem;">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                        <%
                                            }
                                        %>
                                    </td>
                                </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                
                <%
                    if (historial.size() > 5) {
                %>
                    <div style="text-align: center; margin-top: 1.5rem;">
                        <a href="mis-tesis.jsp" class="btn btn-secondary">
                            <i class="fas fa-arrow-right"></i> Ver Historial Completo
                        </a>
                    </div>
                <%
                    }
                %>
            <%
                }
            %>
        </div>
        
        <!-- Quick Actions -->
        <div class="quick-actions">
            <a href="subir-tesis.jsp" class="action-card">
                <h3><i class="fas fa-cloud-upload-alt"></i> Subir Nueva Tesis</h3>
                <p>Envía tu trabajo de tesis para revisión y evaluación por el asesor designado</p>
            </a>
            
            <a href="mis-tesis.jsp" class="action-card">
                <h3><i class="fas fa-folder-open"></i> Mis Tesis</h3>
                <p>Consulta el estado y detalles de todas las tesis que has enviado</p>
            </a>
            
            <a href="ver-perfil.jsp" class="action-card">
                <h3><i class="fas fa-user-circle"></i> Mi Perfil</h3>
                <p>Ver y actualizar tu información personal</p>
            </a>
        </div>
    </div>
    
    <script>
        // Confirmar eliminación
        function confirmarEliminacion() {
            if (confirm('¿Estás seguro de eliminar esta tesis?\n⚠️ Esta acción no se puede deshacer.')) {
                // En producción, esto llamaría al servlet de eliminación
                alert('Funcionalidad de eliminación en desarrollo.\nEn producción, esto eliminaría la tesis.');
                // window.location.href = '<%= request.getContextPath() %>/eliminar-tesis?id=XXX';
            }
        }
        
        // Auto-ocultar alertas
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                alert.style.transition = 'opacity 0.5s ease';
                alert.style.opacity = '0';
                setTimeout(() => {
                    if (alert.parentNode) {
                        alert.parentNode.removeChild(alert);
                    }
                }, 500);
            });
        }, 5000);
        
        // Resaltar filas de la tabla
        document.addEventListener('DOMContentLoaded', function() {
            const rows = document.querySelectorAll('.thesis-table tbody tr');
            rows.forEach(row => {
                row.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateX(5px)';
                    this.style.transition = 'transform 0.3s ease';
                });
                
                row.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateX(0)';
                });
            });
        });
    </script>
</body>
</html>