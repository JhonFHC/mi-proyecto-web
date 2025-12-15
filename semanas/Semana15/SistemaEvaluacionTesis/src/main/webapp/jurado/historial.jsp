// [file name]: historial.jsp
<%@ page import="java.util.List" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.model.Evaluacion" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.model.Usuario" %>

<%
    List<Evaluacion> evaluaciones = (List<Evaluacion>) request.getAttribute("evaluaciones");
    Usuario jurado = (Usuario) session.getAttribute("usuario");
    
    if (jurado == null || !"jurado".equals(jurado.getRol())) {
        response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Historial de Evaluaciones</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/global.css">
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
            padding: 20px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
        }
        .header-title {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .header-title h1 {
            margin: 0;
            font-size: 24px;
        }
        .header-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .btn-secondary {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            text-decoration: none;
            padding: 8px 18px;
            border-radius: 6px;
            font-weight: 500;
            transition: all 0.3s;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.3);
        }
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            text-align: center;
            transition: transform 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-card.total {
            border-top: 6px solid #3498db;
        }
        .stat-card.aprobadas {
            border-top: 6px solid #2ecc71;
        }
        .stat-card.observadas {
            border-top: 6px solid #f39c12;
        }
        .stat-card.desaprobadas {
            border-top: 6px solid #e74c3c;
        }
        .stat-number {
            font-size: 36px;
            font-weight: 700;
            margin: 10px 0;
        }
        .stat-card.total .stat-number { color: #3498db; }
        .stat-card.aprobadas .stat-number { color: #2ecc71; }
        .stat-card.observadas .stat-number { color: #f39c12; }
        .stat-card.desaprobadas .stat-number { color: #e74c3c; }
        .stat-label {
            color: #7f8c8d;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .evaluaciones-container {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }
        .section-title {
            color: #2c3e50;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
            padding-bottom: 15px;
            border-bottom: 2px solid #ecf0f1;
        }
        .section-title h2 {
            margin: 0;
            font-size: 22px;
        }
        .evaluaciones-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        .evaluaciones-table th {
            background: linear-gradient(135deg, #34495e 0%, #2c3e50 100%);
            color: white;
            padding: 16px 20px;
            text-align: left;
            font-weight: 600;
            border: none;
        }
        .evaluaciones-table td {
            padding: 18px 20px;
            border-bottom: 1px solid #ecf0f1;
            vertical-align: middle;
        }
        .evaluaciones-table tr:hover {
            background-color: #f8f9fa;
        }
        .badge-estado {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .badge-pendiente { background: #fff3cd; color: #856404; }
        .badge-completada { background: #d4edda; color: #155724; }
        .badge-en-progreso { background: #cce5ff; color: #004085; }
        .badge-aprobado { background: #d1ecf1; color: #0c5460; }
        .badge-aprobado-obs { background: #fff3cd; color: #856404; }
        .badge-desaprobado { background: #f8d7da; color: #721c24; }
        .tesis-title {
            font-weight: 500;
            color: #2c3e50;
        }
        .puntaje-display {
            font-size: 24px;
            font-weight: 700;
            color: #2c3e50;
        }
        .porcentaje-display {
            font-size: 14px;
            color: #7f8c8d;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #bdc3c7;
        }
        .empty-icon {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        .empty-state h3 {
            color: #95a5a6;
            margin: 0 0 10px 0;
        }
        .empty-state p {
            color: #bdc3c7;
            margin: 0;
        }
        .btn-ver-detalle {
            background: #3498db;
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 14px;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        .btn-ver-detalle:hover {
            background: #2980b9;
            transform: translateY(-2px);
        }
        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            .header-info {
                flex-direction: column;
                gap: 10px;
            }
            .evaluaciones-table {
                display: block;
                overflow-x: auto;
            }
            .stats-cards {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-title">
            <h1><i class="fas fa-history"></i> Historial de Evaluaciones</h1>
        </div>
        <div class="header-info">
            <% if (jurado != null) { %>
            <span style="font-weight: 500;"><i class="fas fa-user"></i> <%= jurado.getNombreCompleto() %></span>
            <% } %>
            <a href="<%= request.getContextPath() %>/jurado" class="btn-secondary">
                <i class="fas fa-arrow-left"></i> Volver al Dashboard
            </a>
        </div>
    </div>
    
    <div class="container">
        <% if (evaluaciones != null && !evaluaciones.isEmpty()) { 
            int total = evaluaciones.size();
            long aprobadas = evaluaciones.stream().filter(e -> "aprobado".equals(e.getRecomendacion())).count();
            long aprobadasObs = evaluaciones.stream().filter(e -> "aprobado_obs".equals(e.getRecomendacion())).count();
            long desaprobadas = evaluaciones.stream().filter(e -> "desaprobado".equals(e.getRecomendacion())).count();
        %>
        <div class="stats-cards">
            <div class="stat-card total">
                <div class="stat-number"><%= total %></div>
                <div class="stat-label">Total Evaluaciones</div>
            </div>
            <div class="stat-card aprobadas">
                <div class="stat-number"><%= aprobadas %></div>
                <div class="stat-label">Aprobadas</div>
            </div>
            <div class="stat-card observadas">
                <div class="stat-number"><%= aprobadasObs %></div>
                <div class="stat-label">Aprobadas con Obs.</div>
            </div>
            <div class="stat-card desaprobadas">
                <div class="stat-number"><%= desaprobadas %></div>
                <div class="stat-label">Desaprobadas</div>
            </div>
        </div>
        <% } %>
        
        <div class="evaluaciones-container">
            <div class="section-title">
                <h2><i class="fas fa-clipboard-list"></i> Todas mis evaluaciones</h2>
                <span style="color: #7f8c8d; font-size: 14px;">
                    <%= evaluaciones != null ? evaluaciones.size() : 0 %> registros
                </span>
            </div>
            
            <% if (evaluaciones == null || evaluaciones.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon"><i class="fas fa-clipboard"></i></div>
                <h3>No hay evaluaciones en tu historial</h3>
                <p>Comienza evaluando las tesis asignadas desde el dashboard.</p>
            </div>
            <% } else { %>
            <table class="evaluaciones-table">
                <thead>
                    <tr>
                        <th style="width: 35%;">Tesis</th>
                        <th style="width: 10%;">Estado</th>
                        <th style="width: 15%;">Resultado</th>
                        <th style="width: 15%;">Puntaje</th>
                        <th style="width: 20%;">Fecha</th>
                        <th style="width: 5%;">Acción</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Evaluacion e : evaluaciones) { 
                        String estadoClass = "badge-" + e.getEstado().replace("_", "-");
                        String recomendacionClass = "badge-" + e.getRecomendacion().replace("_", "-");
                        String fechaStr = e.getFechaEvaluacion() != null ? 
                            e.getFechaEvaluacion().toString().substring(0, 16) : "Sin fecha";
                        double porcentaje = (e.getCalificacionFinal() / 38.0) * 100;
                    %>
                    <tr>
                        <td>
                            <div class="tesis-title">
                                <strong><%= e.getTesisTitulo() != null ? e.getTesisTitulo() : "Tesis ID: " + e.getIdTesis() %></strong>
                            </div>
                        </td>
                        <td>
                            <span class="badge-estado <%= estadoClass %>">
                                <%= e.getEstado() %>
                            </span>
                        </td>
                        <td>
                            <span class="badge-estado <%= recomendacionClass %>">
                                <%= e.getRecomendacion() %>
                            </span>
                        </td>
                        <td>
                            <div class="puntaje-display">
                                <%= String.format("%.1f", e.getCalificacionFinal()) %>/38
                            </div>
                            <div class="porcentaje-display">
                                <%= String.format("%.2f", porcentaje) %>%
                            </div>
                        </td>
                        <td>
                            <%= fechaStr %>
                        </td>
                        <td>
                            <a href="<%= request.getContextPath() %>/jurado/detalle-evaluacion?id=<%= e.getIdEvaluacion() %>" 
                               class="btn-ver-detalle">
                                <i class="fas fa-eye"></i> Ver
                            </a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } %>
        </div>
    </div>
</body>
</html>