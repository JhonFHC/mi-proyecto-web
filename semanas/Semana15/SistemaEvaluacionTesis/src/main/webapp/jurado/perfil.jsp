<%@ page import="com.zonajava.sistemaevaluaciontesis.model.Usuario" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    
    if (usuario == null || !"jurado".equals(usuario.getRol())) {
        response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
        return;
    }
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Mi Perfil - Jurado</title>
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
        .header-title h1 {
            margin: 0;
            font-size: 22px;
            font-weight: 600;
        }
        .header-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .btn-secondary {
            background: rgba(255, 255, 255, 0.15);
            color: white;
            text-decoration: none;
            padding: 8px 15px;
            border-radius: 5px;
            font-weight: 500;
            transition: all 0.3s;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.25);
        }
        .container {
            max-width: 800px;
            margin: 30px auto;
            padding: 0 15px;
        }
        .profile-card {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.08);
        }
        .profile-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #ecf0f1;
        }
        .profile-icon {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            color: white;
            font-size: 40px;
        }
        .profile-header h2 {
            color: #2c3e50;
            margin: 0 0 5px 0;
        }
        .profile-header .role {
            background: #2ecc71;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
            display: inline-block;
        }
        .profile-details {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        .detail-group {
            margin-bottom: 15px;
        }
        .detail-label {
            font-weight: 600;
            color: #7f8c8d;
            font-size: 14px;
            margin-bottom: 5px;
            display: block;
        }
        .detail-value {
            padding: 10px 15px;
            background: #f8f9fa;
            border-radius: 5px;
            border: 1px solid #ecf0f1;
            color: #2c3e50;
            font-size: 15px;
        }
        .stats-section {
            margin-top: 30px;
            padding: 20px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 8px;
            border-left: 4px solid #3498db;
        }
        .stats-title {
            color: #2c3e50;
            margin: 0 0 15px 0;
            font-size: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        .stat-item {
            background: white;
            padding: 15px;
            border-radius: 6px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        .stat-value {
            font-size: 28px;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 5px;
        }
        .stat-label {
            font-size: 14px;
            color: #7f8c8d;
        }
        .profile-actions {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #ecf0f1;
        }
        .btn-action {
            padding: 10px 25px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-back {
            background: #95a5a6;
            color: white;
        }
        .btn-back:hover {
            background: #7f8c8d;
        }
        .btn-edit {
            background: #3498db;
            color: white;
        }
        .btn-edit:hover {
            background: #2980b9;
        }
        @media (max-width: 768px) {
            .profile-details {
                grid-template-columns: 1fr;
            }
            .header {
                flex-direction: column;
                gap: 10px;
                text-align: center;
            }
            .profile-actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-title">
            <h1><i class="fas fa-user-circle"></i> Mi Perfil</h1>
        </div>
        <div class="header-info">
            <span style="font-weight: 500;"><i class="fas fa-user"></i> <%= usuario.getNombreCompleto() %></span>
            <a href="<%= request.getContextPath() %>/jurado" class="btn-secondary">
                <i class="fas fa-home"></i> Dashboard
            </a>
        </div>
    </div>
    
    <div class="container">
        <div class="profile-card">
            <div class="profile-header">
                <div class="profile-icon">
                    <i class="fas fa-user-tie"></i>
                </div>
                <h2><%= usuario.getNombreCompleto() %></h2>
                <div class="role">JURADO EVALUADOR</div>
            </div>
            
            <div class="profile-details">
                <div class="detail-group">
                    <span class="detail-label"><i class="fas fa-id-card"></i> Código UPLA</span>
                    <div class="detail-value"><%= usuario.getCodigoUpla() != null ? usuario.getCodigoUpla() : "No asignado" %></div>
                </div>
                
                <div class="detail-group">
                    <span class="detail-label"><i class="fas fa-envelope"></i> Correo Electrónico</span>
                    <div class="detail-value"><%= usuario.getEmail() %></div>
                </div>
                
                <div class="detail-group">
                    <span class="detail-label"><i class="fas fa-building"></i> Departamento</span>
                    <div class="detail-value"><%= usuario.getDepartamento() != null ? usuario.getDepartamento() : "No asignado" %></div>
                </div>
                
                <div class="detail-group">
                    <span class="detail-label"><i class="fas fa-user-shield"></i> Rol en el Sistema</span>
                    <div class="detail-value" style="background: #d4edda; color: #155724; border-color: #c3e6cb;">
                        <strong><%= usuario.getRol().toUpperCase() %></strong>
                    </div>
                </div>
                
                <div class="detail-group">
                    <span class="detail-label"><i class="fas fa-info-circle"></i> Estado de la Cuenta</span>
                    <div class="detail-value" style="<%= "activo".equals(usuario.getEstado()) ? "background: #d4edda; color: #155724; border-color: #c3e6cb;" : "background: #f8d7da; color: #721c24; border-color: #f5c6cb;" %>">
                        <%= usuario.getEstado() != null ? usuario.getEstado().toUpperCase() : "DESCONOCIDO" %>
                    </div>
                </div>
                
                <div class="detail-group">
                    <span class="detail-label"><i class="fas fa-calendar-alt"></i> Fecha de Creación</span>
                    <div class="detail-value">
                        <%= usuario.getFechaCreacion() != null ? sdf.format(usuario.getFechaCreacion()) : "No disponible" %>
                    </div>
                </div>
            </div>
            
            <div class="stats-section">
                <h3 class="stats-title"><i class="fas fa-chart-line"></i> Estadísticas de Evaluación</h3>
                <div class="stats-grid">
                    <div class="stat-item">
                        <div class="stat-value" id="evaluacionesTotal">0</div>
                        <div class="stat-label">Evaluaciones Totales</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value" id="evaluacionesCompletadas">0</div>
                        <div class="stat-label">Completadas</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value" id="evaluacionesPendientes">0</div>
                        <div class="stat-label">Pendientes</div>
                    </div>
                </div>
            </div>
            
            <div class="profile-actions">
                <a href="<%= request.getContextPath() %>/jurado" class="btn-action btn-back">
                    <i class="fas fa-arrow-left"></i> Volver al Dashboard
                </a>
                <a href="#" class="btn-action btn-edit" onclick="alert('La edición del perfil debe ser solicitada al administrador del sistema.');">
                    <i class="fas fa-edit"></i> Solicitar Edición
                </a>
            </div>
        </div>
    </div>
    
    <script>
        // En un sistema real, estos datos vendrían del servidor
        // Aquí mostramos datos de ejemplo
        document.addEventListener('DOMContentLoaded', function() {
            // Simulamos estadísticas del jurado
            document.getElementById('evaluacionesTotal').textContent = '12';
            document.getElementById('evaluacionesCompletadas').textContent = '8';
            document.getElementById('evaluacionesPendientes').textContent = '4';
        });
    </script>
</body>
</html>