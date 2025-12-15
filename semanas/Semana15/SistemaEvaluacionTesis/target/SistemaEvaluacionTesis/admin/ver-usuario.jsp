<%@ page import="com.zonajava.sistemaevaluaciontesis.model.Usuario" %>
<%
    Usuario admin = (Usuario) session.getAttribute("usuario");
    if (admin == null || !"admin".equals(admin.getRol())) {
        response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
        return;
    }
    
    Usuario usuario = (Usuario) request.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/admin/usuarios?error=usuarioNoEncontrado");
        return;
    }
    
    boolean isCurrentUser = admin.getIdUsuario() == usuario.getIdUsuario();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Ver Usuario - Admin</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/global.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .profile-container {
            max-width: 1000px;
            margin: 40px auto;
            background: white;
            border-radius: 16px;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
            overflow: hidden;
        }
        
        .profile-header {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: white;
            padding: 40px;
            text-align: center;
            position: relative;
        }
        
        .profile-avatar {
            width: 120px;
            height: 120px;
            background: #3498db;
            border-radius: 50%;
            margin: 0 auto 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
            font-weight: bold;
            border: 4px solid white;
            box-shadow: 0 0 0 4px rgba(52, 152, 219, 0.3);
        }
        
        .profile-title {
            font-size: 28px;
            margin-bottom: 8px;
            font-weight: 600;
        }
        
        .profile-subtitle {
            opacity: 0.9;
            font-size: 16px;
            margin-bottom: 15px;
        }
        
        .profile-badge {
            display: inline-block;
            padding: 8px 20px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
            margin-top: 10px;
        }
        
        .profile-actions {
            position: absolute;
            top: 30px;
            right: 30px;
            display: flex;
            gap: 10px;
        }
        
        .profile-body {
            padding: 40px;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
        }
        
        .info-section {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 12px;
            border-left: 4px solid #3498db;
        }
        
        .section-title {
            font-size: 18px;
            color: #2c3e50;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e9ecef;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .info-item {
            margin-bottom: 18px;
            display: flex;
            flex-direction: column;
        }
        
        .info-label {
            font-weight: 600;
            color: #6c757d;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 5px;
        }
        
        .info-value {
            color: #2c3e50;
            font-size: 16px;
            font-weight: 500;
        }
        
        .badge {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 500;
            margin-top: 5px;
        }
        
        .role-badge {
            background: #e74c3c;
            color: white;
        }
        
        .status-badge {
            background: #28a745;
            color: white;
        }
        
        .status-inactive {
            background: #dc3545;
        }
        
        .timeline {
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid #e9ecef;
        }
        
        .timeline-item {
            display: flex;
            margin-bottom: 25px;
            position: relative;
            padding-left: 40px;
        }
        
        .timeline-icon {
            position: absolute;
            left: 0;
            width: 30px;
            height: 30px;
            background: #3498db;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
        }
        
        .timeline-content {
            flex: 1;
        }
        
        .timeline-title {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
        }
        
        .timeline-date {
            font-size: 13px;
            color: #6c757d;
        }
        
        .timeline-desc {
            font-size: 14px;
            color: #495057;
            margin-top: 5px;
        }
        
        .btn {
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            color: white;
            font-weight: 500;
            font-size: 14px;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: none;
            cursor: pointer;
        }
        
        .btn-back {
            background: #7f8c8d;
        }
        
        .btn-back:hover {
            background: #5d6d7e;
            transform: translateY(-2px);
        }
        
        .btn-edit {
            background: #3498db;
        }
        
        .btn-edit:hover {
            background: #2980b9;
            transform: translateY(-2px);
        }
        
        .btn-delete {
            background: #e74c3c;
        }
        
        .btn-delete:hover {
            background: #c0392b;
            transform: translateY(-2px);
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid #e9ecef;
        }
        
        @media (max-width: 768px) {
            .profile-container {
                margin: 20px;
            }
            
            .profile-header {
                padding: 30px 20px;
            }
            
            .profile-actions {
                position: static;
                justify-content: center;
                margin-top: 20px;
            }
            
            .profile-body {
                padding: 25px;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="profile-container">
        <div class="profile-header">
            <div class="profile-avatar">
                <%= usuario.getNombreCompleto().charAt(0) %>
            </div>
            <h1 class="profile-title"><%= usuario.getNombreCompleto() %></h1>
            <p class="profile-subtitle"><%= usuario.getEmail() %></p>
            
            <% 
                String badgeColor = "";
                String roleText = "";
                switch(usuario.getRol()) {
                    case "admin": 
                        badgeColor = "#e74c3c"; 
                        roleText = "Administrador";
                        break;
                    case "asesor": 
                        badgeColor = "#3498db"; 
                        roleText = "Asesor";
                        break;
                    case "jurado": 
                        badgeColor = "#9b59b6"; 
                        roleText = "Jurado";
                        break;
                    case "estudiante": 
                        badgeColor = "#2ecc71"; 
                        roleText = "Estudiante";
                        break;
                }
            %>
            <div class="profile-badge" style="background: <%= badgeColor %>;">
                <%= roleText %>
            </div>
            
            <div class="profile-actions">
                <a href="<%= request.getContextPath() %>/admin/usuarios" class="btn btn-back">
                    ? Volver
                </a>
                <a href="<%= request.getContextPath() %>/admin/usuarios?action=editar&id=<%= usuario.getIdUsuario() %>" 
                   class="btn btn-edit">
                    ?? Editar
                </a>
                <% if (!isCurrentUser) { %>
                    <a href="<%= request.getContextPath() %>/admin/usuarios?action=eliminar&id=<%= usuario.getIdUsuario() %>" 
                       class="btn btn-delete"
                       onclick="return confirm('¿Está seguro de eliminar a <%= usuario.getNombreCompleto() %>?')">
                        ?? Eliminar
                    </a>
                <% } %>
            </div>
        </div>
        
        <div class="profile-body">
            <div class="info-grid">
                <!-- Información Personal -->
                <div class="info-section">
                    <h2 class="section-title">? Información Personal</h2>
                    
                    <div class="info-item">
                        <span class="info-label">ID de Usuario</span>
                        <span class="info-value">#<%= usuario.getIdUsuario() %></span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Código UPLA</span>
                        <span class="info-value"><%= usuario.getCodigoUpla() %></span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Nombre Completo</span>
                        <span class="info-value"><strong><%= usuario.getNombreCompleto() %></strong></span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Correo Electrónico</span>
                        <span class="info-value"><%= usuario.getEmail() %></span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Departamento</span>
                        <span class="info-value"><%= usuario.getDepartamento() %></span>
                    </div>
                </div>
                
                <!-- Información de Cuenta -->
                <div class="info-section">
                    <h2 class="section-title">? Información de Cuenta</h2>
                    
                    <div class="info-item">
                        <span class="info-label">Rol en el Sistema</span>
                        <span class="badge role-badge"><%= roleText %></span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Estado de la Cuenta</span>
                        <span class="badge status-badge <%= "inactivo".equals(usuario.getEstado()) ? "status-inactive" : "" %>">
                            <%= "activo".equals(usuario.getEstado()) ? "Activo" : "Inactivo" %>
                        </span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Fecha de Creación</span>
                        <span class="info-value">
                            <%= usuario.getFechaCreacion() != null ? 
                                usuario.getFechaCreacion().toString() : "No disponible" %>
                        </span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Último Acceso</span>
                        <span class="info-value">Hoy, 10:30 AM</span>
                    </div>
                </div>
            </div>
            
            <!-- Información Adicional -->
            <div class="timeline">
                <h2 class="section-title">? Información Adicional</h2>
                
                <div class="timeline-item">
                    <div class="timeline-icon">?</div>
                    <div class="timeline-content">
                        <div class="timeline-title">Permisos del Rol</div>
                        <div class="timeline-date">Nivel de acceso</div>
                        <div class="timeline-desc">
                            <% 
                                String permissions = "";
                                switch(usuario.getRol()) {
                                    case "admin": 
                                        permissions = "Acceso completo a todos los módulos del sistema. Puede gestionar usuarios, asignar jurados y generar resultados.";
                                        break;
                                    case "asesor": 
                                        permissions = "Puede revisar tesis enviadas por estudiantes y dar recomendaciones.";
                                        break;
                                    case "jurado": 
                                        permissions = "Puede evaluar tesis asignadas y calificarlas.";
                                        break;
                                    case "estudiante": 
                                        permissions = "Puede enviar tesis y consultar resultados de evaluación.";
                                        break;
                                }
                            %>
                            <%= permissions %>
                        </div>
                    </div>
                </div>
                
                <div class="timeline-item">
                    <div class="timeline-icon">?</div>
                    <div class="timeline-content">
                        <div class="timeline-title">Actividad en el Sistema</div>
                        <div class="timeline-date">Registro de actividad</div>
                        <div class="timeline-desc">
                            <% if ("activo".equals(usuario.getEstado())) { %>
                                Usuario activo con acceso completo al sistema.
                            <% } else { %>
                                Usuario inactivo. No puede acceder al sistema hasta que sea reactivado.
                            <% } %>
                        </div>
                    </div>
                </div>
                
                <% if (isCurrentUser) { %>
                <div class="timeline-item">
                    <div class="timeline-icon">??</div>
                    <div class="timeline-content">
                        <div class="timeline-title">Nota Importante</div>
                        <div class="timeline-date">Información del administrador</div>
                        <div class="timeline-desc">
                            <strong>Este es tu propio perfil.</strong> No puedes eliminarte a ti mismo del sistema.
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
            
            <div class="action-buttons">
                <a href="<%= request.getContextPath() %>/admin/usuarios" class="btn btn-back">
                    ? Volver a la Lista
                </a>
                <a href="<%= request.getContextPath() %>/admin/usuarios?action=editar&id=<%= usuario.getIdUsuario() %>" 
                   class="btn btn-edit">
                    ?? Editar Usuario
                </a>
            </div>
        </div>
    </div>
</body>
</html>