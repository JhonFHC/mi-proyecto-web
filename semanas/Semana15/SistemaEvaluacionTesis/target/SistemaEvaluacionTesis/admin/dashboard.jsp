<%@ page import="java.util.List" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.model.Usuario" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.model.Tesis" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.dao.TesisDAO" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.dao.AdminDAO" %>
<%
    Usuario admin = (Usuario) session.getAttribute("usuario");
    if (admin == null || !"admin".equals(admin.getRol())) {
        response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
        return;
    }
    
    TesisDAO dao = new TesisDAO();
    List<Tesis> tesis = dao.listarParaJurados();
    AdminDAO adminDAO = new AdminDAO();
    List<Object[]> listaResultado = adminDAO.listarTesisListasParaResultado();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard Admin</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/global.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f7fa;
            color: #333;
        }
        
        /* Header */
        .admin-header {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: white;
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        
        .header-left h1 {
            font-size: 24px;
            margin-bottom: 5px;
            font-weight: 600;
        }
        
        .header-left p {
            opacity: 0.9;
            font-size: 14px;
        }
        
        .admin-actions {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .admin-info {
            text-align: right;
            margin-right: 20px;
        }
        
        .admin-name {
            font-weight: 600;
            font-size: 16px;
        }
        
        .admin-role {
            font-size: 12px;
            opacity: 0.8;
        }
        
        .header-btn {
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
        }
        
        .btn-profile {
            background: #3498db;
        }
        
        .btn-profile:hover {
            background: #2980b9;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.3);
        }
        
        .btn-logout {
            background: #e74c3c;
        }
        
        .btn-logout:hover {
            background: #c0392b;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(231, 76, 60, 0.3);
        }
        
        /* Container */
        .admin-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 30px 20px;
        }
        
        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        
        .stat-card {
            background: white;
            padding: 30px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
            transition: transform 0.3s;
            border: 1px solid #eef1f5;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 25px rgba(0, 0, 0, 0.12);
        }
        
        .stat-icon {
            font-size: 36px;
            margin-bottom: 15px;
        }
        
        .stat-value {
            font-size: 42px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 8px;
        }
        
        .stat-label {
            color: #7f8c8d;
            font-size: 16px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        /* Section */
        .admin-section {
            background: white;
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 40px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
            border: 1px solid #eef1f5;
        }
        
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f1f3f5;
        }
        
        .section-title {
            font-size: 22px;
            color: #2c3e50;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .section-title i {
            color: #3498db;
        }
        
        .section-badge {
            background: #3498db;
            color: white;
            padding: 8px 18px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
        }
        
        /* Cards Grid */
        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: 25px;
        }
        
        .tesis-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.07);
            border-left: 4px solid #3498db;
            transition: all 0.3s;
            border: 1px solid #eef1f5;
        }
        
        .tesis-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
            border-left-color: #2980b9;
        }
        
        .card-title {
            font-size: 18px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 15px;
            line-height: 1.4;
        }
        
        .card-subtitle {
            color: #7f8c8d;
            font-size: 14px;
            margin-bottom: 20px;
        }
        
        .card-info {
            margin-bottom: 25px;
        }
        
        .info-row {
            display: flex;
            margin-bottom: 10px;
            align-items: center;
        }
        
        .info-label {
            font-weight: 600;
            color: #34495e;
            min-width: 100px;
            font-size: 14px;
        }
        
        .info-value {
            color: #2c3e50;
            flex: 1;
            font-size: 14px;
        }
        
        .card-actions {
            display: flex;
            gap: 12px;
        }
        
        .btn {
            padding: 10px 20px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-assign {
            background: #3498db;
            color: white;
            flex: 1;
            justify-content: center;
        }
        
        .btn-assign:hover {
            background: #2980b9;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.3);
        }
        
        .btn-result {
            background: #2ecc71;
            color: white;
            flex: 1;
            justify-content: center;
        }
        
        .btn-result:hover {
            background: #27ae60;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(46, 204, 113, 0.3);
        }
        
        .btn-view {
            background: #9b59b6;
            color: white;
        }
        
        .btn-view:hover {
            background: #8e44ad;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(155, 89, 182, 0.3);
        }
        
        /* Admin Actions */
        .admin-actions-grid {
            display: flex;
            gap: 20px;
            justify-content: center;
            margin-top: 20px;
            flex-wrap: wrap;
        }
        
        .admin-action-btn {
            background: #9b59b6;
            color: white;
            padding: 15px 30px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            font-size: 16px;
        }
        
        .admin-action-btn:hover {
            background: #8e44ad;
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(155, 89, 182, 0.3);
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #95a5a6;
        }
        
        .empty-icon {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        
        .empty-state h3 {
            font-size: 20px;
            margin-bottom: 10px;
            color: #7f8c8d;
        }
        
        .empty-state p {
            font-size: 15px;
            max-width: 400px;
            margin: 0 auto;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .admin-header {
                flex-direction: column;
                text-align: center;
                padding: 20px;
                gap: 15px;
            }
            
            .header-left {
                text-align: center;
            }
            
            .admin-actions {
                flex-direction: column;
                width: 100%;
            }
            
            .header-btn {
                width: 100%;
                justify-content: center;
            }
            
            .cards-grid {
                grid-template-columns: 1fr;
            }
            
            .admin-container {
                padding: 20px 15px;
            }
            
            .section-header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            
            .card-actions {
                flex-direction: column;
            }
            
            .admin-actions-grid {
                flex-direction: column;
                align-items: center;
            }
            
            .admin-action-btn {
                width: 100%;
                max-width: 300px;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="admin-header">
        <div class="header-left">
            <h1>? Panel de Administración</h1>
            <p>Sistema de Evaluación de Tesis - Universidad de Playa Ancha</p>
        </div>
        <div class="admin-actions">
            <div class="admin-info">
                <div class="admin-name"><%= admin.getNombreCompleto() %></div>
                <div class="admin-role">Administrador</div>
            </div>
            <a href="<%= request.getContextPath() %>/admin/ver-perfil.jsp" class="header-btn btn-profile">
                ? Ver Perfil
            </a>
            <a href="<%= request.getContextPath() %>/logout" class="header-btn btn-logout">
                ? Cerrar Sesión
            </a>
        </div>
    </div>
    
    <div class="admin-container">
        <!-- Estadísticas -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">?</div>
                <div class="stat-value"><%= tesis != null ? tesis.size() : 0 %></div>
                <div class="stat-label">Tesis Pendientes</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">?</div>
                <div class="stat-value"><%= listaResultado != null ? listaResultado.size() : 0 %></div>
                <div class="stat-label">Para Resultado</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">????</div>
                <div class="stat-value">--</div>
                <div class="stat-label">Jurados Activos</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">?</div>
                <div class="stat-value">--</div>
                <div class="stat-label">Evaluaciones</div>
            </div>
        </div>
        
        <!-- Funciones del Administrador -->
        <div class="admin-section" style="text-align: center;">
            <h2 class="section-title" style="justify-content: center;">?? Funciones del Administrador</h2>
            <div class="admin-actions-grid">
                <a href="<%= request.getContextPath() %>/admin/usuarios" 
                   class="admin-action-btn">
                    ? Gestión de Usuarios
                </a>
            </div>
            <p style="color: #7f8c8d; margin-top: 15px; font-size: 15px;">
                Solo el administrador puede: Gestionar usuarios, Asignar jurados, Generar resultados
            </p>
        </div>
        
        <!-- Tesis para Asignar Jurados -->
        <div class="admin-section">
            <div class="section-header">
                <h2 class="section-title">???? Tesis para Asignar Jurados</h2>
                <span class="section-badge"><%= tesis != null ? tesis.size() : 0 %> tesis</span>
            </div>
            
            <% if (tesis == null || tesis.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-icon">?</div>
                    <h3>No hay tesis pendientes</h3>
                    <p>Todas las tesis tienen jurados asignados o están en proceso de evaluación.</p>
                </div>
            <% } else { %>
                <div class="cards-grid">
                    <% for (Tesis t : tesis) { %>
                        <div class="tesis-card">
                            <h3 class="card-title"><%= t.getTitulo() %></h3>
                            <p class="card-subtitle">ID: #<%= t.getIdTesis() %></p>
                            
                            <div class="card-info">
                                <div class="info-row">
                                    <span class="info-label">Estudiante:</span>
                                    <span class="info-value"><strong><%= t.getEstudianteNombre() %></strong></span>
                                </div>
                                
                                <div class="info-row">
                                    <span class="info-label">Estado:</span>
                                    <span class="info-value" style="color:#f39c12; font-weight:bold;">? <%= t.getEstado() %></span>
                                </div>
                            </div>
                            
                            <div class="card-actions">
                                <a href="asignar.jsp?id_tesis=<%= t.getIdTesis() %>" class="btn btn-assign">
                                    ? Asignar Jurados
                                </a>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
        
        <!-- Tesis Listas para Resultado Final -->
        <div class="admin-section">
            <div class="section-header">
                <h2 class="section-title">? Tesis Listas para Resultado Final</h2>
                <span class="section-badge" style="background:#27ae60;"><%= listaResultado != null ? listaResultado.size() : 0 %> listas</span>
            </div>
            
            <% if (listaResultado == null || listaResultado.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-icon">?</div>
                    <h3>No hay tesis listas</h3>
                    <p>No hay tesis completadas para generar resultado final.</p>
                </div>
            <% } else { %>
                <div class="cards-grid">
                    <% for (Object[] row : listaResultado) { %>
                        <div class="tesis-card" style="border-left-color: #27ae60;">
                            <h3 class="card-title"><%= row[1] %></h3>
                            <p class="card-subtitle">ID: #<%= row[0] %></p>
                            
                            <div class="card-info">
                                <div class="info-row">
                                    <span class="info-label">Evaluaciones:</span>
                                    <span class="info-value" style="color:#27ae60; font-weight:bold;">? Completadas</span>
                                </div>
                                
                                <div class="info-row">
                                    <span class="info-label">Estado:</span>
                                    <span class="info-value">Esperando resultado final</span>
                                </div>
                            </div>
                            
                            <div class="card-actions">
                                <a href="<%=request.getContextPath()%>/admin/generar-resultado?id_tesis=<%= row[0] %>" 
                                   class="btn btn-result">
                                    ? Generar Resultado
                                </a>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>