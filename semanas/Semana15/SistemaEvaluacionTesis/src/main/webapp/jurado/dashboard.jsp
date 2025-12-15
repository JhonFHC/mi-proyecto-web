<%@ page import="java.util.List" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.model.Usuario" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.dao.EvaluacionDAO" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.model.Evaluacion" %>

<%
    List<Object[]> lista = (List<Object[]>) request.getAttribute("lista");
    Usuario jurado = (Usuario) session.getAttribute("usuario");
    
    if (jurado == null || !"jurado".equals(jurado.getRol())) {
        response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
        return;
    }
    
    String mensaje = request.getParameter("msg");
    String error = request.getParameter("error");
    
    // Obtener estadísticas del jurado
    EvaluacionDAO evaluacionDAO = new EvaluacionDAO();
    List<Evaluacion> evaluacionesCompletadas = evaluacionDAO.obtenerPorJurado(jurado.getIdUsuario());
    int completadas = 0;
    int pendientes = 0;
    double promedio = 0;
    
    for (Evaluacion eval : evaluacionesCompletadas) {
        if ("completada".equals(eval.getEstado())) {
            completadas++;
            promedio += eval.getCalificacionFinal();
        } else if ("pendiente".equals(eval.getEstado())) {
            pendientes++;
        }
    }
    
    if (completadas > 0) {
        promedio = promedio / completadas;
    }
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard Jurado</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }
        .header {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .header-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .user-name {
            font-weight: 600;
            font-size: 15px;
            background: rgba(255,255,255,0.15);
            padding: 5px 12px;
            border-radius: 20px;
        }
        .btn-logout {
            background: #e74c3c;
            color: white;
            text-decoration: none;
            padding: 8px 18px;
            border-radius: 5px;
            font-weight: 500;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
        }
        .btn-logout:hover {
            background: #c0392b;
            transform: translateY(-2px);
        }
        .btn-profile {
            background: #3498db;
            color: white;
            text-decoration: none;
            padding: 8px 18px;
            border-radius: 5px;
            font-weight: 500;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
        }
        .btn-profile:hover {
            background: #2980b9;
            transform: translateY(-2px);
        }
        .container {
            max-width: 1200px;
            margin: 25px auto;
            padding: 0 15px;
        }
        .welcome-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.08);
            border-left: 6px solid #3498db;
        }
        .welcome-card h2 {
            color: #2c3e50;
            margin: 0 0 10px 0;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 24px;
        }
        .welcome-card p {
            color: #7f8c8d;
            margin: 5px 0;
            line-height: 1.6;
            font-size: 15px;
        }
        .role-badge {
            background: #2ecc71;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            display: inline-block;
            margin-top: 10px;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
            text-align: center;
            border-top: 4px solid #3498db;
        }
        .stat-card.pendientes {
            border-top-color: #f39c12;
        }
        .stat-card.completadas {
            border-top-color: #2ecc71;
        }
        .stat-card.promedio {
            border-top-color: #9b59b6;
        }
        .stat-value {
            font-size: 32px;
            font-weight: bold;
            color: #2c3e50;
            margin: 10px 0;
        }
        .stat-label {
            font-size: 14px;
            color: #7f8c8d;
            margin-bottom: 5px;
        }
        .stat-icon {
            font-size: 24px;
            color: #3498db;
        }
        .stat-card.pendientes .stat-icon {
            color: #f39c12;
        }
        .stat-card.completadas .stat-icon {
            color: #2ecc71;
        }
        .stat-card.promedio .stat-icon {
            color: #9b59b6;
        }
        .evaluaciones-container {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.08);
        }
        .section-title {
            color: #2c3e50;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            padding-bottom: 15px;
            border-bottom: 2px solid #ecf0f1;
        }
        .section-title h3 {
            margin: 0;
            font-size: 20px;
        }
        .badge-count {
            background: #3498db;
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }
        .badge-asignada {
            background: #fff3cd;
            color: #856404;
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 12px;
            font-weight: bold;
            border: 1px solid #ffeaa7;
            margin-left: 10px;
        }
        .evaluaciones-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        .evaluaciones-table th {
            background: #2c3e50;
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            border: none;
            font-size: 14px;
        }
        .evaluaciones-table td {
            padding: 18px 15px;
            border-bottom: 1px solid #ecf0f1;
            vertical-align: middle;
        }
        .evaluaciones-table tr:hover {
            background-color: #f8f9fa;
        }
        .evaluaciones-table tr:last-child td {
            border-bottom: none;
        }
        .tesis-title {
            font-weight: 500;
            color: #2c3e50;
            font-size: 15px;
        }
        .btn-evaluar {
            background: #27ae60;
            color: white;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: 500;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }
        .btn-evaluar:hover {
            background: #229954;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #b2bec3;
        }
        .empty-icon {
            font-size: 48px;
            margin-bottom: 15px;
            opacity: 0.5;
        }
        .empty-state h3 {
            color: #636e72;
            margin: 0 0 10px 0;
        }
        .empty-state p {
            color: #b2bec3;
            margin: 0;
        }
        .restricciones-box {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 20px;
            margin-top: 30px;
        }
        .restricciones-title {
            color: #e74c3c;
            margin: 0 0 10px 0;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 16px;
        }
        .restricciones-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .restricciones-list li {
            padding: 8px 0;
            color: #6c757d;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
        }
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 6px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .alert-info {
            background: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }
        .user-avatar {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 18px;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
                padding: 15px;
            }
            .header-info {
                flex-direction: column;
                gap: 10px;
            }
            .evaluaciones-table {
                display: block;
                overflow-x: auto;
            }
            .stats-grid {
                grid-template-columns: 1fr;
            }
            .user-info {
                flex-direction: column;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="user-info">
            <div class="user-avatar">
                <%= jurado.getNombreCompleto().charAt(0) %>
            </div>
            <div>
                <h1 style="margin: 0; font-size: 22px; font-weight: 600;"><i class="fas fa-tachometer-alt"></i> Dashboard Jurado</h1>
                <p style="margin: 5px 0 0 0; font-size: 14px; opacity: 0.9;">Sistema de Evaluación de Tesis</p>
            </div>
        </div>
        <div class="header-info">
            <span class="user-name"><i class="fas fa-user"></i> <%= jurado.getNombreCompleto() %></span>
            <a href="<%= request.getContextPath() %>/ver-perfil" class="btn-profile">
                <i class="fas fa-user-circle"></i> Mi Perfil
            </a>
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout">
                <i class="fas fa-sign-out-alt"></i> Cerrar Sesión
            </a>
        </div>
    </div>
    
    <div class="container">
        <% if ("exito".equals(mensaje)) { %>
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i> ¡Evaluación guardada exitosamente!
        </div>
        <% } else if ("guardar".equals(error)) { %>
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i> Error al guardar la evaluación. Intente nuevamente.
        </div>
        <% } else if ("criterios".equals(error)) { %>
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i> Debe asignar puntaje a todos los criterios.
        </div>
        <% } %>
        
        <div class="welcome-card">
            <h2><i class="fas fa-graduation-cap"></i> Bienvenido, <%= jurado.getNombreCompleto().split(" ")[0] %></h2>
            <p>Desde aquí puede gestionar las evaluaciones de tesis asignadas a usted. Recuerde que su evaluación debe ser objetiva, fundamentada e imparcial.</p>
            <div class="role-badge">
                <i class="fas fa-user-tie"></i> JURADO EVALUADOR
            </div>
            <p style="margin-top: 15px; color: #3498db; font-weight: 500; font-size: 14px;">
                <i class="fas fa-shield-alt"></i> <strong>Responsabilidad:</strong> 
                Su evaluación determina la aprobación final de las tesis.
            </p>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card pendientes">
                <div class="stat-label"><i class="fas fa-clock stat-icon"></i> Evaluaciones Pendientes</div>
                <div class="stat-value"><%= lista != null ? lista.size() : 0 %></div>
                <div style="font-size: 13px; color: #7f8c8d;">Asignadas para evaluar</div>
            </div>
            
            <div class="stat-card completadas">
                <div class="stat-label"><i class="fas fa-check-circle stat-icon"></i> Evaluaciones Completadas</div>
                <div class="stat-value"><%= completadas %></div>
                <div style="font-size: 13px; color: #7f8c8d;">Total finalizadas</div>
            </div>
            
            <div class="stat-card promedio">
                <div class="stat-label"><i class="fas fa-chart-line stat-icon"></i> Promedio General</div>
                <div class="stat-value"><%= String.format("%.1f", promedio) %>%</div>
                <div style="font-size: 13px; color: #7f8c8d;">Calificación promedio</div>
            </div>
        </div>
        
        <div class="evaluaciones-container">
            <div class="section-title">
                <h3><i class="fas fa-tasks"></i> Evaluaciones Pendientes</h3>
                <span class="badge-count"><%= lista != null ? lista.size() : 0 %></span>
            </div>
            
            <% if (lista == null || lista.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon">?</div>
                <h3>No tiene evaluaciones pendientes</h3>
                <p>No hay tesis asignadas para evaluar en este momento.</p>
                <p style="margin-top: 10px; color: #3498db; font-size: 14px;">
                    <i class="fas fa-info-circle"></i> Las evaluaciones se asignan automáticamente por el sistema.
                </p>
            </div>
            <% } else { %>
            <table class="evaluaciones-table">
                <thead>
                    <tr>
                        <th style="width: 5%;">ID</th>
                        <th style="width: 50%;">Tesis Asignada</th>
                        <th style="width: 25%;">Información</th>
                        <th style="width: 20%;">Acción</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Object[] row : lista) { 
                        Integer idEvaluacion = (Integer) row[0];
                        String tituloTesis = (String) row[2];
                        String estudiante = row.length > 3 ? (String) row[3] : "No disponible";
                        java.sql.Timestamp fechaAsignacion = row.length > 4 ? (java.sql.Timestamp) row[4] : null;
                    %>
                    <tr>
                        <td>
                            <div style="font-weight: bold; color: #2c3e50; text-align: center;">
                                #<%= idEvaluacion %>
                            </div>
                        </td>
                        <td>
                            <div class="tesis-title">
                                <strong><i class="fas fa-file-alt"></i> <%= tituloTesis %></strong>
                                <span class="badge-asignada"><i class="fas fa-clock"></i> Pendiente</span>
                            </div>
                            <div style="margin-top: 8px; font-size: 14px; color: #7f8c8d;">
                                <i class="fas fa-user-graduate"></i> Estudiante: <%= estudiante %>
                            </div>
                        </td>
                        <td>
                            <div style="font-size: 13px; color: #7f8c8d;">
                                <% if (fechaAsignacion != null) { %>
                                <div><i class="fas fa-calendar"></i> Asignada: <%= sdf.format(fechaAsignacion) %></div>
                                <% } %>
                                <div><i class="fas fa-hashtag"></i> ID Evaluación: <%= idEvaluacion %></div>
                                <div><i class="fas fa-list-ol"></i> 38 criterios por evaluar</div>
                            </div>
                        </td>
<td>
    <a href="<%= request.getContextPath() %>/jurado/evaluar?id=<%= idEvaluacion %>" 
       class="btn-evaluar">
        <i class="fas fa-edit"></i> Evaluar Tesis
    </a>
</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } %>
            
            <div class="restricciones-box">
                <h4 class="restricciones-title"><i class="fas fa-ban"></i> Acciones no permitidas para Jurados:</h4>
                <ul class="restricciones-list">
                    <li><i class="fas fa-times-circle" style="color: #e74c3c;"></i> Editar tesis de estudiantes</li>
                    <li><i class="fas fa-times-circle" style="color: #e74c3c;"></i> Eliminar evaluaciones realizadas</li>
                    <li><i class="fas fa-times-circle" style="color: #e74c3c;"></i> Re-evaluar tesis ya calificadas</li>
                    <li><i class="fas fa-times-circle" style="color: #e74c3c;"></i> Modificar criterios de evaluación</li>
                </ul>
                <p style="margin-top: 15px; color: #3498db; font-size: 13px;">
                    <i class="fas fa-info-circle"></i> Para cualquier modificación, contacte al administrador del sistema.
                </p>
            </div>
        </div>
    </div>
    
    <script>
        // Función para actualizar la hora actual
        function actualizarHora() {
            const ahora = new Date();
            const opciones = { 
                weekday: 'long', 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit'
            };
            document.getElementById('hora-actual').textContent = 
                ahora.toLocaleDateString('es-ES', opciones);
        }
        
        // Actualizar la hora cada segundo
        setInterval(actualizarHora, 1000);
        actualizarHora();
        
        // Mostrar notificación si hay mensaje
        <% if (mensaje != null || error != null) { %>
        setTimeout(() => {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                alert.style.transition = 'opacity 0.5s';
                alert.style.opacity = '0.7';
            });
        }, 5000);
        <% } %>
    </script>
</body>
</html>