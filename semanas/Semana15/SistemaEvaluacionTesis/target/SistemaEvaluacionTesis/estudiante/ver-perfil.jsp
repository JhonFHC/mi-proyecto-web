<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Object usuarioObj = session.getAttribute("usuario");
    if (usuarioObj == null) {
        response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
        return;
    }
    
    com.zonajava.sistemaevaluaciontesis.model.Usuario usuario = (com.zonajava.sistemaevaluaciontesis.model.Usuario) usuarioObj;
    if (!"estudiante".equals(usuario.getRol())) {
        response.sendRedirect(request.getContextPath() + "/vistas/login.jsp?error=acceso_denegado");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Perfil - Estudiante</title>
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .profile-container {
            background: white;
            border-radius: 20px;
            width: 100%;
            max-width: 800px;
            overflow: hidden;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
        }
        
        .profile-header {
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
            color: white;
            padding: 2rem;
            text-align: center;
            position: relative;
        }
        
        .avatar {
            width: 120px;
            height: 120px;
            background: white;
            border-radius: 50%;
            margin: 0 auto 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            color: #3498db;
            font-weight: bold;
            border: 5px solid rgba(255,255,255,0.3);
        }
        
        .back-btn {
            position: absolute;
            top: 20px;
            left: 20px;
            background: rgba(255,255,255,0.2);
            border: none;
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s;
        }
        
        .back-btn:hover {
            background: rgba(255,255,255,0.3);
            transform: scale(1.1);
        }
        
        .profile-body {
            padding: 2rem;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .info-card {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 1.5rem;
            border-left: 4px solid #3498db;
        }
        
        .info-card h3 {
            color: #3498db;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .info-item {
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .info-item:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }
        
        .info-label {
            font-size: 0.9rem;
            color: #666;
            display: block;
            margin-bottom: 5px;
        }
        
        .info-value {
            font-size: 1.1rem;
            font-weight: 500;
            color: #333;
        }
        
        .actions {
            display: flex;
            justify-content: center;
            gap: 1rem;
            margin-top: 2rem;
        }
        
        .btn {
            padding: 10px 25px;
            border-radius: 30px;
            border: none;
            font-weight: 500;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
            text-decoration: none;
        }
        
        .btn-primary {
            background: #3498db;
            color: white;
        }
        
        .btn-primary:hover {
            background: #2980b9;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.3);
        }
        
        .btn-outline {
            background: transparent;
            color: #3498db;
            border: 2px solid #3498db;
        }
        
        .btn-outline:hover {
            background: #3498db;
            color: white;
        }
        
        @media (max-width: 600px) {
            .profile-body {
                padding: 1.5rem;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
            }
            
            .actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="profile-container">
        <div class="profile-header">
            <button class="back-btn" onclick="window.location.href='dashboard.jsp'">
                <i class="fas fa-arrow-left"></i>
            </button>
            <div class="avatar">
                <%= usuario.getNombreCompleto().charAt(0) %>
            </div>
            <h1><%= usuario.getNombreCompleto() %></h1>
            <p>Estudiante - Sistema de Evaluación de Tesis</p>
        </div>
        
        <div class="profile-body">
            <div class="info-grid">
                <div class="info-card">
                    <h3><i class="fas fa-user-circle"></i> Información Personal</h3>
                    <div class="info-item">
                        <span class="info-label">Código UPLA</span>
                        <span class="info-value"><%= usuario.getCodigoUpla() %></span>
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
                
                <div class="info-card">
                    <h3><i class="fas fa-graduation-cap"></i> Información Académica</h3>
                    <div class="info-item">
                        <span class="info-label">Rol en el Sistema</span>
                        <span class="info-value" style="color: #3498db; font-weight: bold;">
                            <i class="fas fa-user-graduate"></i> Estudiante
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Estado de Cuenta</span>
                        <span class="info-value" style="color: #27ae60;">
                            <i class="fas fa-check-circle"></i> <%= usuario.getEstado() %>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Fecha de Registro</span>
                        <span class="info-value">
                            <% if (usuario.getFechaCreacion() != null) { 
                                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
                            %>
                                <%= sdf.format(usuario.getFechaCreacion()) %>
                            <% } else { %>
                                No disponible
                            <% } %>
                        </span>
                    </div>
                </div>
            </div>
            
            <div class="actions">
                <button class="btn btn-primary" onclick="window.location.href='dashboard.jsp'">
                    <i class="fas fa-home"></i> Volver al Dashboard
                </button>
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline">
                    <i class="fas fa-sign-out-alt"></i> Cerrar Sesión
                </a>
            </div>
        </div>
    </div>
</body>
</html>