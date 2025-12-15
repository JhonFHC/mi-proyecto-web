<%@ page import="java.util.List" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.model.Usuario" %>
<%
    Usuario admin = (Usuario) session.getAttribute("usuario");
    if (admin == null || !"admin".equals(admin.getRol())) {
        response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
        return;
    }
    
    List<Usuario> usuarios = (List<Usuario>) request.getAttribute("usuarios");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Gestión de Usuarios - Admin</title>
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
        
        .header {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: white;
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
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
        
        .header-actions {
            display: flex;
            align-items: center;
            gap: 15px;
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
        
        .btn-primary {
            background: #3498db;
        }
        
        .btn-primary:hover {
            background: #2980b9;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.3);
        }
        
        .btn-secondary {
            background: #7f8c8d;
        }
        
        .btn-secondary:hover {
            background: #5d6d7e;
            transform: translateY(-2px);
        }
        
        .btn-success {
            background: #2ecc71;
        }
        
        .btn-success:hover {
            background: #27ae60;
            transform: translateY(-2px);
        }
        
        .btn-danger {
            background: #e74c3c;
        }
        
        .btn-danger:hover {
            background: #c0392b;
            transform: translateY(-2px);
        }
        
        .btn-warning {
            background: #f39c12;
        }
        
        .btn-warning:hover {
            background: #d35400;
            transform: translateY(-2px);
        }
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 30px 20px;
        }
        
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
            animation: slideIn 0.3s ease;
        }
        
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }
        
        .alert-info {
            background: #d1ecf1;
            color: #0c5460;
            border-left: 4px solid #17a2b8;
        }
        
        .card {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
            margin-bottom: 30px;
        }
        
        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f1f3f5;
        }
        
        .card-title {
            font-size: 22px;
            color: #2c3e50;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.07);
            transition: transform 0.3s;
            border: 1px solid #eef1f5;
        }
        
        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
        }
        
        .stat-value {
            font-size: 32px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #7f8c8d;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .table-container {
            overflow-x: auto;
            border-radius: 10px;
            border: 1px solid #eef1f5;
        }
        
        .users-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }
        
        .users-table thead {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        }
        
        .users-table th {
            padding: 18px 15px;
            text-align: left;
            font-weight: 600;
            color: #2c3e50;
            border-bottom: 2px solid #dee2e6;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .users-table td {
            padding: 18px 15px;
            border-bottom: 1px solid #eef1f5;
            color: #495057;
            font-size: 14px;
        }
        
        .users-table tbody tr {
            transition: background-color 0.2s;
        }
        
        .users-table tbody tr:hover {
            background-color: #f8f9fa;
        }
        
        .users-table tbody tr:last-child td {
            border-bottom: none;
        }
        
        .role-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            text-transform: uppercase;
        }
        
        .role-admin {
            background: #e74c3c;
            color: white;
        }
        
        .role-asesor {
            background: #3498db;
            color: white;
        }
        
        .role-jurado {
            background: #9b59b6;
            color: white;
        }
        
        .role-estudiante {
            background: #2ecc71;
            color: white;
        }
        
        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .status-active {
            background: #d4edda;
            color: #155724;
        }
        
        .status-inactive {
            background: #f8d7da;
            color: #721c24;
        }
        
        .action-buttons {
            display: flex;
            gap: 8px;
        }
        
        .action-btn {
            padding: 6px 12px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 12px;
            font-weight: 500;
            transition: all 0.3s;
        }
        
        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 3px 8px rgba(0,0,0,0.2);
        }
        
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
            margin: 0 auto 25px;
        }
        
        .search-container {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 25px;
            display: flex;
            gap: 15px;
            align-items: center;
        }
        
        .search-input {
            flex: 1;
            padding: 10px 15px;
            border: 2px solid #e9ecef;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        .search-input:focus {
            outline: none;
            border-color: #3498db;
        }
        
        .filter-select {
            padding: 10px 15px;
            border: 2px solid #e9ecef;
            border-radius: 6px;
            font-size: 14px;
            background: white;
            min-width: 150px;
        }
        
        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                text-align: center;
                padding: 20px;
                gap: 15px;
            }
            
            .header-actions {
                flex-direction: column;
                width: 100%;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .search-container {
                flex-direction: column;
            }
            
            .search-input,
            .filter-select {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-left">
            <h1>? Gestión de Usuarios</h1>
            <p>Sistema de Evaluación de Tesis - Panel Administrativo</p>
        </div>
        <div class="header-actions">
            <a href="<%= request.getContextPath() %>/admin/dashboard.jsp" class="btn btn-secondary">
                ? Dashboard
            </a>
            <a href="<%= request.getContextPath() %>/admin/usuarios?action=nuevo" class="btn btn-success">
                ? Nuevo Usuario
            </a>
            <a href="<%= request.getContextPath() %>/logout" class="btn btn-danger">
                ? Salir
            </a>
        </div>
    </div>
    
    <div class="container">
        <!-- Mensajes de éxito/error -->
        <% if (success != null) { %>
            <div class="alert alert-success">
                <span style="font-size: 20px;">?</span>
                <% 
                    switch(success) {
                        case "usuarioCreado":
                            out.print("Usuario creado exitosamente");
                            break;
                        case "usuarioActualizado":
                            out.print("Usuario actualizado exitosamente");
                            break;
                        case "usuarioEliminado":
                            out.print("Usuario eliminado exitosamente");
                            break;
                        default:
                            out.print("Operación realizada exitosamente");
                    }
                %>
            </div>
        <% } %>
        
        <% if (error != null) { %>
            <div class="alert alert-error">
                <span style="font-size: 20px;">?</span>
                <% 
                    switch(error) {
                        case "usuarioNoEncontrado":
                            out.print("Usuario no encontrado");
                            break;
                        case "noAutoEliminar":
                            out.print("No puedes eliminar tu propio usuario");
                            break;
                        default:
                            out.print("Error en la operación");
                    }
                %>
            </div>
        <% } %>
        
        <!-- Estadísticas -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-value"><%= usuarios != null ? usuarios.size() : 0 %></div>
                <div class="stat-label">Total Usuarios</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">
                    <%= usuarios != null ? 
                        usuarios.stream().filter(u -> "admin".equals(u.getRol())).count() : 0 %>
                </div>
                <div class="stat-label">Administradores</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">
                    <%= usuarios != null ? 
                        usuarios.stream().filter(u -> "asesor".equals(u.getRol())).count() : 0 %>
                </div>
                <div class="stat-label">Asesores</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">
                    <%= usuarios != null ? 
                        usuarios.stream().filter(u -> "jurado".equals(u.getRol())).count() : 0 %>
                </div>
                <div class="stat-label">Jurados</div>
            </div>
        </div>
        
        <!-- Búsqueda y Filtros -->
        <div class="search-container">
            <input type="text" class="search-input" placeholder="? Buscar por nombre o email..." 
                   id="searchInput" onkeyup="filterTable()">
            <select class="filter-select" id="roleFilter" onchange="filterTable()">
                <option value="">Todos los roles</option>
                <option value="admin">Administrador</option>
                <option value="asesor">Asesor</option>
                <option value="jurado">Jurado</option>
                <option value="estudiante">Estudiante</option>
            </select>
            <select class="filter-select" id="statusFilter" onchange="filterTable()">
                <option value="">Todos los estados</option>
                <option value="activo">Activo</option>
                <option value="inactivo">Inactivo</option>
            </select>
        </div>
        
        <!-- Tabla de Usuarios -->
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">? Lista de Usuarios Registrados</h2>
                <span class="btn btn-primary" onclick="exportTable()">? Exportar</span>
            </div>
            
            <% if (usuarios == null || usuarios.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-icon">?</div>
                    <h3>No hay usuarios registrados</h3>
                    <p>Comienza agregando nuevos usuarios al sistema.</p>
                    <a href="<%= request.getContextPath() %>/admin/usuarios?action=nuevo" 
                       class="btn btn-success" style="width: auto;">
                        ? Agregar Primer Usuario
                    </a>
                </div>
            <% } else { %>
                <div class="table-container">
                    <table class="users-table" id="usersTable">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Código</th>
                                <th>Nombre</th>
                                <th>Email</th>
                                <th>Rol</th>
                                <th>Departamento</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Usuario usuario : usuarios) { 
                                String currentUserId = String.valueOf(admin.getIdUsuario());
                                String rowUserId = String.valueOf(usuario.getIdUsuario());
                                boolean isCurrentUser = currentUserId.equals(rowUserId);
                            %>
                                <tr>
                                    <td>#<%= usuario.getIdUsuario() %></td>
                                    <td><%= usuario.getCodigoUpla() %></td>
                                    <td><strong><%= usuario.getNombreCompleto() %></strong></td>
                                    <td><%= usuario.getEmail() %></td>
                                    <td>
                                        <% 
                                            String roleClass = "";
                                            switch(usuario.getRol()) {
                                                case "admin": roleClass = "role-admin"; break;
                                                case "asesor": roleClass = "role-asesor"; break;
                                                case "jurado": roleClass = "role-jurado"; break;
                                                case "estudiante": roleClass = "role-estudiante"; break;
                                            }
                                        %>
                                        <span class="role-badge <%= roleClass %>">
                                            <%= usuario.getRol() %>
                                        </span>
                                    </td>
                                    <td><%= usuario.getDepartamento() %></td>
                                    <td>
                                        <span class="status-badge <%= "activo".equals(usuario.getEstado()) ? "status-active" : "status-inactive" %>">
                                            <%= usuario.getEstado() %>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="<%= request.getContextPath() %>/admin/usuarios?action=ver&id=<%= usuario.getIdUsuario() %>" 
                                               class="action-btn" style="background:#3498db; color:white;">
                                                ?? Ver
                                            </a>
                                            <a href="<%= request.getContextPath() %>/admin/usuarios?action=editar&id=<%= usuario.getIdUsuario() %>" 
                                               class="action-btn" style="background:#2ecc71; color:white;">
                                                ?? Editar
                                            </a>
                                            <% if (!isCurrentUser) { %>
                                                <a href="<%= request.getContextPath() %>/admin/usuarios?action=eliminar&id=<%= usuario.getIdUsuario() %>" 
                                                   class="action-btn" style="background:#e74c3c; color:white;"
                                                   onclick="return confirm('¿Está seguro de eliminar a <%= usuario.getNombreCompleto() %>?')">
                                                    ?? Eliminar
                                                </a>
                                            <% } else { %>
                                                <span class="action-btn" style="background:#95a5a6; color:white; cursor:not-allowed;">
                                                    Tú
                                                </span>
                                            <% } %>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                
                <!-- Info -->
                <div style="margin-top: 20px; padding: 15px; background: #f8f9fa; border-radius: 8px; font-size: 13px; color: #6c757d;">
                    <strong>?? Información:</strong> Total de usuarios mostrados: <strong><%= usuarios.size() %></strong>
                </div>
            <% } %>
        </div>
    </div>
    
    <script>
        // Filtrado de tabla
        function filterTable() {
            const input = document.getElementById('searchInput');
            const roleFilter = document.getElementById('roleFilter').value.toLowerCase();
            const statusFilter = document.getElementById('statusFilter').value.toLowerCase();
            const filter = input.value.toLowerCase();
            const table = document.getElementById('usersTable');
            const tr = table.getElementsByTagName('tr');
            
            for (let i = 1; i < tr.length; i++) {
                const tdName = tr[i].getElementsByTagName('td')[2];
                const tdEmail = tr[i].getElementsByTagName('td')[3];
                const tdRole = tr[i].getElementsByTagName('td')[4];
                const tdStatus = tr[i].getElementsByTagName('td')[6];
                
                if (tdName && tdEmail && tdRole && tdStatus) {
                    const nameText = tdName.textContent || tdName.innerText;
                    const emailText = tdEmail.textContent || tdEmail.innerText;
                    const roleText = tdRole.textContent || tdRole.innerText;
                    const statusText = tdStatus.textContent || tdStatus.innerText;
                    
                    const nameMatch = nameText.toLowerCase().indexOf(filter) > -1;
                    const emailMatch = emailText.toLowerCase().indexOf(filter) > -1;
                    const roleMatch = roleFilter === '' || roleText.toLowerCase().indexOf(roleFilter) > -1;
                    const statusMatch = statusFilter === '' || statusText.toLowerCase().indexOf(statusFilter) > -1;
                    
                    tr[i].style.display = (nameMatch || emailMatch) && roleMatch && statusMatch ? '' : 'none';
                }
            }
        }
        
        // Exportar tabla
        function exportTable() {
            const table = document.getElementById('usersTable');
            let csv = [];
            
            // Encabezados
            const headers = [];
            for (let i = 0; i < table.rows[0].cells.length - 1; i++) { // Excluir columna acciones
                headers.push(table.rows[0].cells[i].innerText);
            }
            csv.push(headers.join(','));
            
            // Datos
            for (let i = 1; i < table.rows.length; i++) {
                const row = table.rows[i];
                if (row.style.display !== 'none') {
                    const rowData = [];
                    for (let j = 0; j < row.cells.length - 1; j++) { // Excluir columna acciones
                        rowData.push(row.cells[j].innerText.replace(/,/g, ' '));
                    }
                    csv.push(rowData.join(','));
                }
            }
            
            // Descargar
            const csvContent = csv.join('\n');
            const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
            const link = document.createElement('a');
            link.href = URL.createObjectURL(blob);
            link.download = 'usuarios_' + new Date().toISOString().split('T')[0] + '.csv';
            link.click();
        }
        
        // Auto-focus en búsqueda
        document.getElementById('searchInput').focus();
    </script>
</body>
</html>