<%@ page import="com.zonajava.sistemaevaluaciontesis.model.Usuario" %>
<%
    Usuario asesor = (Usuario) session.getAttribute("usuario");
    if (asesor == null || !"asesor".equals(asesor.getRol())) {
        response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Perfil - Asesor</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/global.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #2980b9;
            --secondary: #2c3e50;
            --light: #ecf0f1;
            --dark: #34495e;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        
        .profile-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        
        .profile-header {
            background: linear-gradient(to right, var(--primary), var(--secondary));
            color: white;
            padding: 2rem;
            border-radius: 12px 12px 0 0;
            display: flex;
            align-items: center;
            gap: 1.5rem;
            position: relative;
        }
        
        .back-button {
            position: absolute;
            top: 1rem;
            left: 1rem;
            color: white;
            text-decoration: none;
            font-size: 1.2rem;
            padding: 0.5rem;
            border-radius: 50%;
            transition: background 0.3s;
        }
        
        .back-button:hover {
            background: rgba(255,255,255,0.2);
        }
        
        .profile-avatar {
            width: 100px;
            height: 100px;
            background: var(--light);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary);
            font-size: 2.5rem;
            font-weight: bold;
            border: 4px solid white;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        
        .profile-info h1 {
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
        }
        
        .profile-info .role {
            background: rgba(255,255,255,0.2);
            padding: 0.3rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
            display: inline-block;
        }
        
        .profile-content {
            background: white;
            border-radius: 0 0 12px 12px;
            padding: 2rem;
            box-shadow: 0 6px 15px rgba(0,0,0,0.1);
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .info-card {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 8px;
            border-left: 4px solid var(--primary);
        }
        
        .info-card h3 {
            color: var(--secondary);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .info-row {
            display: flex;
            margin-bottom: 0.8rem;
            padding-bottom: 0.8rem;
            border-bottom: 1px solid #eee;
        }
        
        .info-label {
            font-weight: 600;
            color: var(--dark);
            min-width: 120px;
        }
        
        .info-value {
            color: #555;
            flex: 1;
        }
        
        .stats-section {
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 2px solid #eee;
        }
        
        .stats-title {
            color: var(--secondary);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1rem;
        }
        
        .stat-item {
            text-align: center;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 8px;
            transition: transform 0.3s;
        }
        
        .stat-item:hover {
            transform: translateY(-3px);
            background: #e9ecef;
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: var(--primary);
            margin-bottom: 0.5rem;
        }
        
        .stat-label {
            color: var(--dark);
            font-size: 0.9rem;
        }
        
        @media (max-width: 768px) {
            .profile-header {
                flex-direction: column;
                text-align: center;
                padding-top: 3rem;
            }
            
            .back-button {
                top: 0.5rem;
                left: 0.5rem;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="profile-container">
        <!-- Header -->
        <div class="profile-header">
            <a href="<%= request.getContextPath() %>/asesor" class="back-button">
                <i class="fas fa-arrow-left"></i>
            </a>
            <div class="profile-avatar">
                <%= asesor.getNombreCompleto().charAt(0) %>
            </div>
            <div class="profile-info">
                <h1><%= asesor.getNombreCompleto() %></h1>
                <span class="role"><i class="fas fa-user-tie"></i> Asesor Académico</span>
            </div>
        </div>
        
        <!-- Content -->
        <div class="profile-content">
            <div class="info-grid">
                <div class="info-card">
                    <h3><i class="fas fa-id-card"></i> Información Personal</h3>
                    <div class="info-row">
                        <span class="info-label">Código UPLA:</span>
                        <span class="info-value"><%= asesor.getCodigoUpla() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Email:</span>
                        <span class="info-value"><%= asesor.getEmail() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Departamento:</span>
                        <span class="info-value"><%= asesor.getDepartamento() %></span>
                    </div>
                </div>
                
                <div class="info-card">
                    <h3><i class="fas fa-info-circle"></i> Información de Cuenta</h3>
                    <div class="info-row">
                        <span class="info-label">Rol:</span>
                        <span class="info-value" style="color: var(--primary); font-weight: 600;">
                            <%= asesor.getRol().toUpperCase() %>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Estado:</span>
                        <span class="info-value" style="color: #27ae60; font-weight: 600;">
                            <i class="fas fa-check-circle"></i> <%= asesor.getEstado() %>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Fecha Registro:</span>
                        <span class="info-value">
                            <%= asesor.getFechaCreacion() != null ? 
                                new java.text.SimpleDateFormat("dd/MM/yyyy").format(asesor.getFechaCreacion()) 
                                : "No disponible" %>
                        </span>
                    </div>
                </div>
            </div>
            
            <!-- Statistics Section -->
            <div class="stats-section">
                <h3 class="stats-title"><i class="fas fa-chart-bar"></i> Mi Actividad</h3>
                <div class="stats-grid">
                    <div class="stat-item">
                        <div class="stat-number" id="evaluacionesCount">0</div>
                        <div class="stat-label">Evaluaciones Realizadas</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number" id="estudiantesCount">0</div>
                        <div class="stat-label">Estudiantes Asesorados</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number" id="promedioNota">0.0</div>
                        <div class="stat-label">Promedio Calificación</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number" id="diasActivo">1</div>
                        <div class="stat-label">Días como Asesor</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Simular estadísticas (en un sistema real, estos datos vendrían del servidor)
        document.addEventListener('DOMContentLoaded', function() {
            // Datos simulados
            document.getElementById('evaluacionesCount').textContent = Math.floor(Math.random() * 50) + 10;
            document.getElementById('estudiantesCount').textContent = Math.floor(Math.random() * 30) + 5;
            document.getElementById('promedioNota').textContent = (Math.random() * 2 + 16).toFixed(1);
            
            // Calcular días desde la fecha de registro
            <% if (asesor.getFechaCreacion() != null) { %>
                const fechaRegistro = new Date(<%= asesor.getFechaCreacion().getTime() %>);
                const hoy = new Date();
                const diffTime = Math.abs(hoy - fechaRegistro);
                const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                document.getElementById('diasActivo').textContent = diffDays;
            <% } else { %>
                document.getElementById('diasActivo').textContent = "N/A";
            <% } %>
        });
        
        // Efecto de carga para números
        const statsNumbers = document.querySelectorAll('.stat-number');
        statsNumbers.forEach(stat => {
            const finalValue = parseInt(stat.textContent) || parseFloat(stat.textContent);
            if (!isNaN(finalValue)) {
                let current = 0;
                const increment = finalValue / 50;
                const timer = setInterval(() => {
                    current += increment;
                    if (current >= finalValue) {
                        stat.textContent = stat.textContent.includes('.') ? finalValue.toFixed(1) : finalValue;
                        clearInterval(timer);
                    } else {
                        stat.textContent = stat.textContent.includes('.') ? current.toFixed(1) : Math.floor(current);
                    }
                }, 30);
            }
        });
    </script>
</body>
</html>