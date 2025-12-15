<%@ page import="com.zonajava.sistemaevaluaciontesis.model.Usuario" %>
<%
    Usuario admin = (Usuario) session.getAttribute("usuario");
    if (admin == null || !"admin".equals(admin.getRol())) {
        response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Mi Perfil - Admin</title>
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
            max-width: 900px;
            margin: 40px auto;
            background: white;
            border-radius: 16px;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
            overflow: hidden;
        }
        
        .profile-header {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: white;
            padding: 30px 40px;
            text-align: center;
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
            margin-bottom: 20px;
        }
        
        .profile-badge {
            display: inline-block;
            background: #e74c3c;
            color: white;
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
            margin-top: 10px;
        }
        
        .profile-body {
            padding: 40px;
        }
        
        .info-section {
            margin-bottom: 35px;
        }
        
        .section-title {
            font-size: 20px;
            color: #2c3e50;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #ecf0f1;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .section-title i {
            color: #3498db;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
        }
        
        .info-item {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            border-left: 4px solid #3498db;
            transition: transform 0.3s;
        }
        
        .info-item:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .info-label {
            font-weight: 600;
            color: #7f8c8d;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }
        
        .info-value {
            color: #2c3e50;
            font-size: 18px;
            font-weight: 500;
        }
        
        .profile-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid #ecf0f1;
        }
        
        .btn {
            padding: 12px 28px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: none;
            cursor: pointer;
            font-size: 15px;
        }
        
        .btn-back {
            background: #7f8c8d;
            color: white;
        }
        
        .btn-back:hover {
            background: #5d6d7e;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .btn-edit {
            background: #3498db;
            color: white;
        }
        
        .btn-edit:hover {
            background: #2980b9;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }
        
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
        }
        
        .stat-value {
            font-size: 36px;
            font-weight: bold;
            margin-bottom: 8px;
        }
        
        .stat-label {
            font-size: 14px;
            opacity: 0.9;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        @media (max-width: 768px) {
            .profile-container {
                margin: 20px;
            }
            
            .profile-header,
            .profile-body {
                padding: 25px;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
            }
            
            .profile-actions {
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
                <%= admin.getNombreCompleto().charAt(0) %>
            </div>
            <h1 class="profile-title"><%= admin.getNombreCompleto() %></h1>
            <p class="profile-subtitle"><%= admin.getEmail() %></p>
            <span class="profile-badge">ADMINISTRADOR</span>
        </div>
        
        <div class="profile-body">
            <div class="info-section">
                <h2 class="section-title">
                    <i>?</i> Información Personal
                </h2>
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">Código UPLA</div>
                        <div class="info-value"><%= admin.getCodigoUpla() %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Nombre Completo</div>
                        <div class="info-value"><%= admin.getNombreCompleto() %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Correo Electrónico</div>
                        <div class="info-value"><%= admin.getEmail() %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Departamento</div>
                        <div class="info-value"><%= admin.getDepartamento() %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Rol del Sistema</div>
                        <div class="info-value" style="color: #e74c3c; font-weight: bold;">
                            <%= admin.getRol().toUpperCase() %>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Estado de Cuenta</div>
                        <div class="info-value" style="color: #27ae60; font-weight: bold;">
                            <%= admin.getEstado().toUpperCase() %>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="info-section">
                <h2 class="section-title">
                    <i>?</i> Acceso Administrativo
                </h2>
                <div class="stats-grid">
                    <div class="stat-card" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                        <div class="stat-value">Dashboard</div>
                        <div class="stat-label">Panel Principal</div>
                    </div>
                    <div class="stat-card" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                        <div class="stat-value">Jurados</div>
                        <div class="stat-label">Asignación</div>
                    </div>
                    <div class="stat-card" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                        <div class="stat-value">Resultados</div>
                        <div class="stat-label">Generación</div>
                    </div>
                </div>
            </div>
            
            <div class="profile-actions">
                <a href="<%= request.getContextPath() %>/admin/dashboard.jsp" class="btn btn-back">
                    ? Volver al Dashboard
                </a>
                <button class="btn btn-edit" onclick="alert('Función de edición disponible próximamente')">
                    ?? Editar Perfil
                </button>
            </div>
        </div>
    </div>
</body>
</html>