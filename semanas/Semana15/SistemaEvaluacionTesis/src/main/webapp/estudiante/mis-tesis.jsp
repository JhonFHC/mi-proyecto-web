<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.model.Usuario" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.model.Tesis" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.dao.TesisDAO" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null || !"estudiante".equals(usuario.getRol())) {
        response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
        return;
    }
    
    TesisDAO dao = new TesisDAO();
    List<Tesis> lista = dao.listarPorEstudiante(usuario.getIdUsuario());
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Tesis - Estudiante</title>
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
        }
        
        .user-role {
            font-size: 0.9rem;
            opacity: 0.9;
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
        
        /* Back Button */
        .back-nav {
            margin-bottom: 1.5rem;
        }
        
        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #3498db;
            text-decoration: none;
            font-weight: 500;
            padding: 8px 15px;
            border-radius: 6px;
            transition: all 0.3s;
        }
        
        .back-btn:hover {
            background: #e3f2fd;
            transform: translateX(-5px);
        }
        
        /* Page Header */
        .page-header {
            background: white;
            border-radius: 12px;
            padding: 1.5rem 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            border-left: 5px solid #3498db;
        }
        
        .page-header h1 {
            color: #3498db;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        /* Table */
        .thesis-table {
            width: 100%;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            margin-bottom: 2rem;
        }
        
        .thesis-table table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .thesis-table th {
            background: #f8f9fa;
            padding: 1rem 1.5rem;
            text-align: left;
            font-weight: 600;
            color: #2c3e50;
            border-bottom: 2px solid #e0e0e0;
        }
        
        .thesis-table td {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .thesis-table tr:hover {
            background: #f8f9fa;
        }
        
        /* Badges */
        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .badge-borrador { background: #fff3cd; color: #856404; }
        .badge-enviada { background: #cce5ff; color: #004085; }
        .badge-en_evaluacion { background: #d4edda; color: #155724; }
        .badge-aprobada { background: #d1ecf1; color: #0c5460; }
        .badge-rechazada { background: #f8d7da; color: #721c24; }
        
        /* Actions */
        .table-actions {
            display: flex;
            gap: 8px;
        }
        
        .action-btn {
            width: 36px;
            height: 36px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s;
            font-size: 0.9rem;
            text-decoration: none;
        }
        
        .btn-view {
            background: #e3f2fd;
            color: #3498db;
        }
        
        .btn-view:hover {
            background: #3498db;
            color: white;
            transform: translateY(-2px);
        }
        
        .btn-download {
            background: #e8f5e9;
            color: #27ae60;
        }
        
        .btn-download:hover {
            background: #27ae60;
            color: white;
            transform: translateY(-2px);
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 3rem;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }
        
        .empty-icon {
            font-size: 3rem;
            color: #ddd;
            margin-bottom: 1rem;
        }
        
        .empty-state h3 {
            color: #666;
            margin-bottom: 0.5rem;
        }
        
        .empty-state p {
            color: #999;
            margin-bottom: 1.5rem;
        }
        
        .btn-primary {
            background: #3498db;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            font-weight: 500;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
            text-decoration: none;
        }
        
        .btn-primary:hover {
            background: #2980b9;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(52, 152, 219, 0.3);
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .header {
                padding: 1rem;
                flex-direction: column;
                gap: 1rem;
            }
            
            .header-user {
                flex-direction: column;
                text-align: center;
            }
            
            .header-actions {
                justify-content: center;
            }
            
            .container {
                padding: 0 1rem;
            }
            
            .thesis-table {
                overflow-x: auto;
            }
            
            .thesis-table table {
                min-width: 600px;
            }
            
            .table-actions {
                flex-direction: column;
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
                <div class="user-role">Estudiante</div>
            </div>
            <div class="header-actions">
                <a href="ver-perfil.jsp" class="header-btn">
                    <i class="fas fa-user-circle"></i> Perfil
                </a>
                <a href="<%= request.getContextPath() %>/logout" class="header-btn">
                    <i class="fas fa-sign-out-alt"></i> Salir
                </a>
            </div>
        </div>
    </div>
    
    <div class="container">
        <!-- Back Navigation -->
        <div class="back-nav">
            <a href="dashboard.jsp" class="back-btn">
                <i class="fas fa-arrow-left"></i> Volver al Dashboard
            </a>
        </div>
        
        <!-- Page Header -->
        <div class="page-header">
            <h1><i class="fas fa-folder-open"></i> Mis Tesis</h1>
            <p>Aquí puedes ver todas tus tesis registradas en el sistema</p>
        </div>
        
        <% if (lista.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon">
                    <i class="fas fa-file-alt"></i>
                </div>
                <h3>No tienes tesis registradas</h3>
                <p>Comienza subiendo tu primera tesis para iniciar el proceso de evaluación</p>
                <a href="subir-tesis.jsp" class="btn-primary">
                    <i class="fas fa-upload"></i> Subir Primera Tesis
                </a>
            </div>
        <% } else { %>
            <div class="thesis-table">
                <table>
                    <thead>
                        <tr>
                            <th>Título</th>
                            <th>Asesor</th>
                            <th>Estado</th>
                            <th>Fecha</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Tesis t : lista) { 
                            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
                            String fecha = t.getFechaCreacion() != null ? sdf.format(t.getFechaCreacion()) : "-";
                        %>
                            <tr>
                                <td style="font-weight: 500;">
                                    <%= t.getTitulo().length() > 60 ? t.getTitulo().substring(0, 60) + "..." : t.getTitulo() %>
                                </td>
                                <td><%= t.getAsesorNombre() %></td>
                                <td>
                                    <span class="badge badge-<%= t.getEstado().toLowerCase().replace("á", "a") %>">
                                        <%= t.getEstado() %>
                                    </span>
                                </td>
                                <td><%= fecha %></td>
                                <td>
                                    <div class="table-actions">
                                        <a href="<%= request.getContextPath() %>/ver-tesis?file=<%= t.getArchivoUrl() %>" 
                                           target="_blank" class="action-btn btn-view" title="Ver PDF">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="#" onclick="descargarPDF('<%= t.getArchivoUrl() %>')" 
                                           class="action-btn btn-download" title="Descargar">
                                            <i class="fas fa-download"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
            <div style="text-align: center; margin-top: 2rem;">
                <p style="color: #666; margin-bottom: 1rem;">
                    <i class="fas fa-info-circle"></i> 
                    Mostrando <%= lista.size() %> tesis registradas
                </p>
                <div style="display: flex; gap: 1rem; justify-content: center;">
                    <a href="subir-tesis.jsp" class="btn-primary">
                        <i class="fas fa-plus-circle"></i> Subir Nueva Tesis
                    </a>
                    <a href="ver-perfil.jsp" class="btn-primary" style="background: #6c757d;">
                        <i class="fas fa-user-circle"></i> Ver Mi Perfil
                    </a>
                </div>
            </div>
        <% } %>
    </div>
    
    <script>
        function descargarPDF(filename) {
            // Simular descarga (en producción, esto sería un servlet de descarga)
            window.open('<%= request.getContextPath() %>/ver-tesis?file=' + filename, '_blank');
        }
        
        // Resaltar fila al pasar el mouse
        document.addEventListener('DOMContentLoaded', function() {
            const rows = document.querySelectorAll('.thesis-table tbody tr');
            rows.forEach(row => {
                row.addEventListener('mouseenter', function() {
                    this.style.backgroundColor = '#f8f9fa';
                });
                row.addEventListener('mouseleave', function() {
                    this.style.backgroundColor = '';
                });
            });
        });
    </script>
</body>
</html>