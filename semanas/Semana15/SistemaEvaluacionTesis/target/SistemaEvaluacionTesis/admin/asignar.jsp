<%@ page import="java.util.List" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.model.Usuario" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.dao.UsuarioDAO" %>
<%
    Usuario admin = (Usuario) session.getAttribute("usuario");
    if (admin == null || !"admin".equals(admin.getRol())) {
        response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
        return;
    }
    
    int idTesis = Integer.parseInt(request.getParameter("id_tesis"));
    UsuarioDAO udao = new UsuarioDAO();
    List<Usuario> jurados = udao.obtenerJurados();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Asignar Jurados</title>
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
        
        .assignment-container {
            max-width: 800px;
            margin: 40px auto;
            background: white;
            border-radius: 16px;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
            overflow: hidden;
        }
        
        .assignment-header {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .assignment-header h2 {
            font-size: 28px;
            margin-bottom: 10px;
            font-weight: 600;
        }
        
        .assignment-header p {
            opacity: 0.9;
            font-size: 16px;
            margin-bottom: 5px;
        }
        
        .header-actions {
            margin-top: 15px;
        }
        
        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            background: rgba(255, 255, 255, 0.1);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .btn-back:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateY(-2px);
        }
        
        .assignment-body {
            padding: 40px;
        }
        
        .selection-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            border-left: 4px solid #3498db;
        }
        
        .selection-info h3 {
            color: #2c3e50;
            margin-bottom: 10px;
            font-size: 18px;
        }
        
        .selection-info p {
            color: #7f8c8d;
            font-size: 14px;
        }
        
        .selection-info strong {
            color: #e74c3c;
        }
        
        .jurados-list {
            margin-bottom: 40px;
        }
        
        .jurados-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        
        .jurado-card {
            background: white;
            border: 2px solid #eef1f5;
            border-radius: 10px;
            padding: 25px;
            transition: all 0.3s;
            cursor: pointer;
        }
        
        .jurado-card:hover {
            border-color: #3498db;
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.1);
        }
        
        .jurado-card.selected {
            border-color: #2ecc71;
            background: #f8fff9;
        }
        
        .jurado-checkbox {
            margin-bottom: 15px;
        }
        
        .jurado-checkbox input[type="checkbox"] {
            width: 20px;
            height: 20px;
            cursor: pointer;
        }
        
        .jurado-name {
            font-size: 18px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
        }
        
        .jurado-email {
            color: #7f8c8d;
            font-size: 14px;
            margin-bottom: 10px;
        }
        
        .jurado-department {
            display: inline-block;
            background: #ecf0f1;
            color: #7f8c8d;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .form-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 30px;
            border-top: 1px solid #ecf0f1;
        }
        
        .counter {
            font-size: 16px;
            color: #7f8c8d;
        }
        
        .counter span {
            font-weight: 600;
            color: #2c3e50;
        }
        
        .btn-submit {
            background: #3498db;
            color: white;
            border: none;
            padding: 12px 35px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }
        
        .btn-submit:disabled {
            background: #bdc3c7;
            cursor: not-allowed;
            transform: none;
        }
        
        .btn-submit:not(:disabled):hover {
            background: #2980b9;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.3);
        }
        
        .error-message {
            background: #fee;
            color: #c0392b;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 25px;
            border-left: 4px solid #e74c3c;
            display: none;
        }
        
        @media (max-width: 768px) {
            .assignment-container {
                margin: 20px;
            }
            
            .assignment-header,
            .assignment-body {
                padding: 25px;
            }
            
            .jurados-grid {
                grid-template-columns: 1fr;
            }
            
            .form-actions {
                flex-direction: column;
                gap: 20px;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <div class="assignment-container">
        <div class="assignment-header">
            <h2>? Asignar Jurados</h2>
            <p>Tesis ID: #<%= idTesis %></p>
            <p><strong>Seleccione exactamente 3 jurados</strong></p>
            <div class="header-actions">
                <a href="<%= request.getContextPath() %>/admin/dashboard.jsp" class="btn-back">
                    ? Volver al Dashboard
                </a>
            </div>
        </div>
        
        <div class="assignment-body">
            <div class="selection-info">
                <h3>Información Importante</h3>
                <p>? Debe seleccionar <strong>exactamente 3 jurados</strong> para evaluar esta tesis.</p>
                <p>? Solo puede seleccionar jurados con estado activo en el sistema.</p>
                <p>? Una vez asignados, los jurados recibirán la tesis para evaluación.</p>
            </div>
            
            <div class="error-message" id="errorMessage">
                ? Debe seleccionar exactamente 3 jurados.
            </div>
            
            <form action="<%= request.getContextPath() %>/asignar-jurados" method="post" 
                  id="assignForm" onsubmit="return validateSelection()">
                <input type="hidden" name="id_tesis" value="<%= idTesis %>">
                
                <div class="jurados-list">
                    <h3 style="color:#2c3e50; margin-bottom:20px; font-size:18px;">
                        Lista de Jurados Disponibles (<%= jurados.size() %>)
                    </h3>
                    
                    <div class="jurados-grid">
                        <% for (Usuario j : jurados) { %>
                            <label class="jurado-card">
                                <div class="jurado-checkbox">
                                    <input type="checkbox" name="jurados" 
                                           value="<%= j.getIdUsuario() %>"
                                           onchange="updateCounter()">
                                </div>
                                <div class="jurado-name"><%= j.getNombreCompleto() %></div>
                                <div class="jurado-email"><%= j.getEmail() %></div>
                                <div class="jurado-department"><%= j.getDepartamento() %></div>
                            </label>
                        <% } %>
                    </div>
                </div>
                
                <div class="form-actions">
                    <div class="counter">
                        Jurados seleccionados: <span id="selectedCount">0</span> / 3
                    </div>
                    <button type="submit" class="btn-submit" id="submitBtn" disabled>
                        ? Asignar Jurados
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        function updateCounter() {
            const checkboxes = document.querySelectorAll('input[name="jurados"]:checked');
            const count = checkboxes.length;
            const submitBtn = document.getElementById('submitBtn');
            const errorMessage = document.getElementById('errorMessage');
            
            document.getElementById('selectedCount').textContent = count;
            
            // Habilitar/deshabilitar botón
            submitBtn.disabled = count !== 3;
            
            // Estilo de tarjetas seleccionadas
            document.querySelectorAll('.jurado-card').forEach(card => {
                const checkbox = card.querySelector('input[type="checkbox"]');
                if (checkbox.checked) {
                    card.classList.add('selected');
                } else {
                    card.classList.remove('selected');
                }
            });
            
            // Ocultar mensaje de error si está bien
            if (count === 3) {
                errorMessage.style.display = 'none';
            }
        }
        
        function validateSelection() {
            const checkboxes = document.querySelectorAll('input[name="jurados"]:checked');
            const errorMessage = document.getElementById('errorMessage');
            
            if (checkboxes.length !== 3) {
                errorMessage.style.display = 'block';
                errorMessage.scrollIntoView({ behavior: 'smooth' });
                return false;
            }
            
            return true;
        }
        
        // Inicializar contador
        document.addEventListener('DOMContentLoaded', updateCounter);
    </script>
</body>
</html>