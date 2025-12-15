<%@ page import="java.util.List" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.model.Usuario" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.model.Tesis" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.dao.AsesorDAO" %>
<%@ page import="java.util.Map" %>
<%
    Usuario asesor = (Usuario) session.getAttribute("usuario");
    if (asesor == null || !"asesor".equals(asesor.getRol())) {
        response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
        return;
    }
    
    AsesorDAO asesorDao = new AsesorDAO();
    Map<String, Integer> estadisticas = asesorDao.obtenerEstadisticasAsesor(asesor.getIdUsuario());
    List<Map<String, Object>> historial = asesorDao.obtenerHistorialEvaluaciones(asesor.getIdUsuario());
    
    List<Tesis> tesis = (List<Tesis>) request.getAttribute("tesis");
    Integer cantidadTesis = (Integer) request.getAttribute("cantidadTesis");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard Asesor</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/global.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* ESTILOS ORIGINALES DEL PRIMER DASHBOARD */
        .navbar {
            background: linear-gradient(to right, #2980b9, #2c3e50);
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
        }
        
        /* NAVEGACIÓN SUPERIOR */
        .nav-top {
            display: flex;
            gap: 20px;
            align-items: center;
        }
        
        .nav-link {
            color: white;
            text-decoration: none;
            padding: 8px 15px;
            border-radius: 4px;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: background 0.3s;
        }
        
        .nav-link:hover {
            background: rgba(255,255,255,0.1);
        }
        
        .nav-link.active {
            background: rgba(255,255,255,0.2);
        }
        
        .nav-badge {
            background: #e74c3c;
            color: white;
            font-size: 11px;
            padding: 2px 6px;
            border-radius: 10px;
            min-width: 18px;
            text-align: center;
        }
        
        .logout-btn {
            background: #c0392b;
            color: white;
            text-decoration: none;
            padding: 8px 15px;
            border-radius: 4px;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: background 0.3s;
        }
        
        .logout-btn:hover {
            background: #a93226;
        }
        
        .profile-btn {
            background: #2ecc71;
            color: white;
            text-decoration: none;
            padding: 8px 15px;
            border-radius: 4px;
            margin-right: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: background 0.3s;
        }
        
        .profile-btn:hover {
            background: #27ae60;
        }
        
        /* QUICK STATS BAR */
        .stats-bar {
            display: flex;
            justify-content: space-around;
            margin: 20px 0;
            padding: 15px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .stat-item {
            text-align: center;
            padding: 10px;
            flex: 1;
        }
        
        .stat-number {
            font-size: 24px;
            font-weight: bold;
            color: #2980b9;
            display: block;
        }
        
        .stat-label {
            font-size: 14px;
            color: #7f8c8d;
            margin-top: 5px;
        }
        
        /* RESTANTE DE ESTILOS ORIGINALES */
        .cards-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .tesis-card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-left: 5px solid #3498db;
            transition: transform 0.3s;
        }
        
        .tesis-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .tesis-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 15px;
        }
        
        .tesis-title {
            font-size: 18px;
            font-weight: bold;
            color: #2c3e50;
            margin: 0;
            flex: 1;
        }
        
        .tesis-status {
            background: #ecf0f1;
            color: #7f8c8d;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            margin-left: 10px;
        }
        
        .tesis-info {
            margin-bottom: 15px;
        }
        
        .info-row {
            display: flex;
            margin-bottom: 8px;
        }
        
        .info-label {
            font-weight: bold;
            color: #34495e;
            min-width: 80px;
        }
        
        .info-value {
            color: #2c3e50;
            flex: 1;
        }
        
        .tesis-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        
        .btn-evaluar {
            background: #27ae60;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            text-decoration: none;
            flex: 1;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: background 0.3s;
        }
        
        .btn-evaluar:hover {
            background: #219955;
        }
        
        .btn-pdf {
            background: #e74c3c;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            text-decoration: none;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: background 0.3s;
        }
        
        .btn-pdf:hover {
            background: #c0392b;
        }
        
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #7f8c8d;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .empty-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }
        
        .regla-oro {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-left: 5px solid #f1c40f;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
            color: #856404;
        }
        
        .regla-oro strong {
            display: block;
            margin-bottom: 5px;
            color: #856404;
        }
        
        /* HISTORIAL SECTION */
        .history-section {
            margin-top: 30px;
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .section-title {
            color: #2c3e50;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #ecf0f1;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .history-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .history-table th {
            background: #f8f9fa;
            padding: 12px;
            text-align: left;
            color: #34495e;
            border-bottom: 2px solid #dee2e6;
        }
        
        .history-table td {
            padding: 12px;
            border-bottom: 1px solid #ecf0f1;
        }
        
        .history-table tr:hover {
            background: #f8f9fa;
        }
        
        .btn-ver {
            color: #2980b9;
            text-decoration: none;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .btn-ver:hover {
            background: #e3f2fd;
        }
        
        /* QUICK ACTIONS */
        .quick-actions {
            display: flex;
            gap: 15px;
            margin: 20px 0;
            flex-wrap: wrap;
        }
        
        .quick-action {
            flex: 1;
            min-width: 200px;
            background: white;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            text-decoration: none;
            color: #2c3e50;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s;
            border: 2px solid transparent;
        }
        
        .quick-action:hover {
            transform: translateY(-3px);
            border-color: #2980b9;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
        }
        
        .quick-icon {
            font-size: 32px;
            color: #2980b9;
            margin-bottom: 10px;
        }
        
        .quick-title {
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .quick-desc {
            font-size: 14px;
            color: #7f8c8d;
        }
        
        /* RESPONSIVE */
        @media (max-width: 768px) {
            .navbar {
                flex-direction: column;
                gap: 15px;
                padding: 15px;
            }
            
            .nav-top {
                flex-wrap: wrap;
                justify-content: center;
            }
            
            .quick-actions {
                flex-direction: column;
            }
            
            .cards-container {
                grid-template-columns: 1fr;
            }
            
            .stats-bar {
                flex-direction: column;
                gap: 15px;
            }
        }
    </style>
</head>
<body>
    <!-- BARRA DE NAVEGACIÓN SUPERIOR -->
    <div class="navbar">
        <div>
            <h2>? Dashboard Asesor</h2>
            <div style="margin-top: 5px; font-size: 14px; opacity: 0.9;">
                <i class="fas fa-user"></i> <%= asesor.getNombreCompleto() %>
            </div>
        </div>
        
        <!-- MENÚ DE NAVEGACIÓN -->
        <div class="nav-top">
            <a href="<%= request.getContextPath() %>/asesor" class="nav-link active">
                <i class="fas fa-home"></i> Inicio
            </a>
            
            <a href="<%= request.getContextPath() %>/asesor/evaluaciones.jsp" class="nav-link">
                <i class="fas fa-clipboard-check"></i> Evaluar
                <% if (estadisticas.getOrDefault("pendientes", 0) > 0) { %>
                    <span class="nav-badge"><%= estadisticas.getOrDefault("pendientes", 0) %></span>
                <% } %>
            </a>
            
            <a href="<%= request.getContextPath() %>/asesor/historial.jsp" class="nav-link">
                <i class="fas fa-history"></i> Historial
            </a>
            
            <a href="<%= request.getContextPath() %>/asesor/ver-perfil.jsp" class="profile-btn">
                <i class="fas fa-user-circle"></i> Mi Perfil
            </a>
            
            <a href="<%= request.getContextPath() %>/logout" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> Cerrar sesión
            </a>
        </div>
    </div>
    
    <!-- BARRA DE ESTADÍSTICAS RÁPIDAS -->
    <div class="stats-bar">
        <div class="stat-item">
            <span class="stat-number"><%= estadisticas.getOrDefault("pendientes", 0) %></span>
            <span class="stat-label">Tesis Pendientes</span>
        </div>
        <div class="stat-item">
            <span class="stat-number"><%= estadisticas.getOrDefault("en_evaluacion", 0) %></span>
            <span class="stat-label">En Evaluación</span>
        </div>
        <div class="stat-item">
            <span class="stat-number"><%= estadisticas.getOrDefault("observadas", 0) %></span>
            <span class="stat-label">Observadas</span>
        </div>
        <div class="stat-item">
            <span class="stat-number"><%= cantidadTesis != null ? cantidadTesis : 0 %></span>
            <span class="stat-label">Total Asignadas</span>
        </div>
    </div>
    
    <!-- ACCIONES RÁPIDAS -->
    <div class="quick-actions">
        <a href="<%= request.getContextPath() %>/asesor/evaluaciones.jsp" class="quick-action">
            <div class="quick-icon">
                <i class="fas fa-clipboard-check"></i>
            </div>
            <div class="quick-title">Evaluar Tesis</div>
            <div class="quick-desc">
                <%= estadisticas.getOrDefault("pendientes", 0) %> pendientes
            </div>
        </a>
        
        <a href="<%= request.getContextPath() %>/asesor/historial.jsp" class="quick-action">
            <div class="quick-icon">
                <i class="fas fa-chart-line"></i>
            </div>
            <div class="quick-title">Ver Historial</div>
            <div class="quick-desc">
                Evaluaciones anteriores
            </div>
        </a>
        
        <a href="<%= request.getContextPath() %>/asesor/ver-perfil.jsp" class="quick-action">
            <div class="quick-icon">
                <i class="fas fa-user-cog"></i>
            </div>
            <div class="quick-title">Mi Perfil</div>
            <div class="quick-desc">
                Información personal
            </div>
        </a>
    </div>
    
    <!-- REGLA DE ORO -->
    <div class="regla-oro">
        <strong>? REGLA DE ORO PARA ASESORES:</strong>
        "Evaluación responsable: Tu calificación debe ser objetiva y fundamentada en criterios académicos."
    </div>
    
    <!-- TESIS ASIGNADAS -->
    <h2 class="section-title">
        <i class="fas fa-tasks"></i> Tesis Asignadas para Evaluación
    </h2>
    
    <% if (tesis == null || tesis.isEmpty()) { %>
        <div class="empty-state">
            <div class="empty-icon">?</div>
            <h3>No hay tesis asignadas</h3>
            <p>No tienes tesis asignadas para evaluar en este momento.</p>
        </div>
    <% } else { %>
        <div class="cards-container">
            <% for (Tesis t : tesis) { %>
                <div class="tesis-card">
                    <div class="tesis-header">
                        <h3 class="tesis-title"><%= t.getTitulo() %></h3>
                        <span class="tesis-status"><%= t.getEstado() %></span>
                    </div>
                    
                    <div class="tesis-info">
                        <div class="info-row">
                            <span class="info-label">Estudiante:</span>
                            <span class="info-value"><%= t.getEstudianteNombre() %></span>
                        </div>
                        
                        <div class="info-row">
                            <span class="info-label">Fecha:</span>
                            <span class="info-value">
                                <%= t.getFechaCreacion() != null ? 
                                    new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(t.getFechaCreacion()) 
                                    : "N/A" %>
                            </span>
                        </div>
                        
                        <div class="info-row">
                            <span class="info-label">Estado:</span>
                            <span class="info-value">
                                <% if ("enviada".equals(t.getEstado())) { %>
                                    <span style="color: #f39c12;">
                                        <i class="fas fa-clock"></i> Pendiente
                                    </span>
                                <% } else if ("en_evaluacion".equals(t.getEstado())) { %>
                                    <span style="color: #3498db;">
                                        <i class="fas fa-spinner"></i> En evaluación
                                    </span>
                                <% } else { %>
                                    <span style="color: #7f8c8d;">
                                        <i class="fas fa-file-alt"></i> <%= t.getEstado() %>
                                    </span>
                                <% } %>
                            </span>
                        </div>
                    </div>
                    
                    <div class="tesis-actions">
                        <a href="<%= request.getContextPath() %>/ver-tesis?file=<%= t.getArchivoUrl() %>" 
                           target="_blank" class="btn-pdf">
                            <i class="fas fa-file-pdf"></i> Ver PDF
                        </a>
                        <a href="<%= request.getContextPath() %>/asesor/evaluar.jsp?id_tesis=<%= t.getIdTesis() %>" 
                           class="btn-evaluar">
                            <i class="fas fa-clipboard-check"></i> Evaluar
                        </a>
                    </div>
                    
                    <div style="margin-top: 10px; font-size: 12px; color: #7f8c8d; text-align: center;">
                        <strong>?? Acciones no permitidas:</strong> Editar ?? Eliminar ?? Re-evaluar ?
                    </div>
                </div>
            <% } %>
        </div>
    <% } %>
    
    <!-- HISTORIAL RECIENTE -->
    <% if (historial != null && !historial.isEmpty()) { %>
        <div class="history-section">
            <h2 class="section-title">
                <i class="fas fa-history"></i> Historial Reciente
                <a href="<%= request.getContextPath() %>/asesor/historial.jsp" 
                   style="font-size: 14px; margin-left: auto; color: #2980b9; text-decoration: none;">
                    Ver completo <i class="fas fa-arrow-right"></i>
                </a>
            </h2>
            
            <table class="history-table">
                <thead>
                    <tr>
                        <th>Tesis</th>
                        <th>Estudiante</th>
                        <th>Estado</th>
                        <th>Fecha</th>
                        <th>Acción</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        int count = 0;
                        for (Map<String, Object> item : historial) { 
                            if (count >= 5) break;
                            count++;
                    %>
                        <tr>
                            <td><strong><%= item.get("titulo") %></strong></td>
                            <td><%= item.get("estudiante") %></td>
                            <td>
                                <span style="padding: 3px 8px; border-radius: 4px; font-size: 12px;
                                    background: 
                                        <% if ("enviada".equals(item.get("estado"))) { %>#f39c12
                                        <% } else if ("en_evaluacion".equals(item.get("estado"))) { %>#3498db
                                        <% } else if ("borrador".equals(item.get("estado"))) { %>#e74c3c
                                        <% } else { %>#95a5a6<% } %>;
                                    color: white;">
                                    <%= item.get("estado") %>
                                </span>
                            </td>
                            <td>
                                <%= item.get("fecha_creacion") != null ? 
                                    new java.text.SimpleDateFormat("dd/MM/yyyy").format(item.get("fecha_creacion")) 
                                    : "" %>
                            </td>
                            <td>
                                <a href="<%= request.getContextPath() %>/asesor/historial-detalle.jsp?id=<%= item.get("id_tesis") %>" 
                                   class="btn-ver">
                                    <i class="fas fa-eye"></i> Ver
                                </a>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    <% } %>
    
    <!-- PIE DE PÁGINA -->
    <div style="text-align: center; margin-top: 40px; padding: 20px; color: #7f8c8d; font-size: 14px;">
        <p>Sistema de Evaluación de Tesis - Universidad UPLA</p>
        <p>© 2024 Área de Asesoría Académica</p>
        <p style="margin-top: 10px; font-size: 12px;">
            <i class="fas fa-user-clock"></i> Sesión iniciada: 
            <span id="session-time">
                <%= session.getAttribute("loginTime") != null ? 
                    new java.util.Date((Long)session.getAttribute("loginTime")).toString() 
                    : "Ahora" %>
            </span>
        </p>
    </div>

    <script>
        // Navegación activa
        document.addEventListener('DOMContentLoaded', function() {
            const currentPage = window.location.pathname;
            const navLinks = document.querySelectorAll('.nav-link');
            
            navLinks.forEach(link => {
                link.classList.remove('active');
                
                // Para la página principal (/asesor)
                if (currentPage.endsWith('/asesor') && link.href.endsWith('/asesor')) {
                    link.classList.add('active');
                }
                
                // Para otras páginas
                if (currentPage.includes('evaluaciones') && link.href.includes('evaluaciones')) {
                    link.classList.add('active');
                }
                if (currentPage.includes('historial') && link.href.includes('historial')) {
                    link.classList.add('active');
                }
            });
        });
        
        // Actualizar tiempo de sesión
        function updateSessionTime() {
            const loginTime = <%= session.getAttribute("loginTime") != null ? 
                session.getAttribute("loginTime") : System.currentTimeMillis() %>;
            const now = Date.now();
            const diffMs = now - loginTime;
            const diffHours = Math.floor(diffMs / (1000 * 60 * 60));
            const diffMinutes = Math.floor((diffMs % (1000 * 60 * 60)) / (1000 * 60));
            
            const timeElement = document.getElementById('session-time');
            if (timeElement) {
                timeElement.textContent = `${diffHours}h ${diffMinutes}m`;
            }
        }
        
        // Actualizar cada minuto
        updateSessionTime();
        setInterval(updateSessionTime, 60000);
        
        // Efecto hover para tarjetas
        document.querySelectorAll('.tesis-card').forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-5px)';
            });
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });
    </script>
</body>
</html>