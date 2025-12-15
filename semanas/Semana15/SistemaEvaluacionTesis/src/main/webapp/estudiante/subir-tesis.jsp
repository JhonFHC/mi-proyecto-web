<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.model.Usuario" %>
<%@ page import="com.zonajava.sistemaevaluaciontesis.dao.UsuarioDAO" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null || !"estudiante".equals(usuario.getRol())) {
        response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
        return;
    }
    
    UsuarioDAO dao = new UsuarioDAO();
    List<Usuario> asesores = dao.obtenerAsesores();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Subir Tesis - Estudiante</title>
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
            max-width: 800px;
            margin: 2rem auto;
            padding: 0 1.5rem;
        }
        
        /* Back Navigation */
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
        
        /* Form Card */
        .form-card {
            background: white;
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border-top: 4px solid #3498db;
        }
        
        .form-header {
            text-align: center;
            margin-bottom: 2rem;
            padding-bottom: 1.5rem;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .form-header h1 {
            color: #3498db;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .form-header p {
            color: #666;
            max-width: 600px;
            margin: 0 auto;
        }
        
        /* Form Styles */
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #444;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .form-label i {
            color: #3498db;
            width: 20px;
        }
        
        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }
        
        textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }
        
        select.form-control {
            cursor: pointer;
            background-color: white;
        }
        
        /* File Upload */
        .file-upload {
            position: relative;
        }
        
        .file-input {
            width: 100%;
            padding: 12px 15px;
            border: 2px dashed #e0e0e0;
            border-radius: 8px;
            background: #fafafa;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .file-input:hover {
            border-color: #3498db;
            background: #f8fbff;
        }
        
        .file-info {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: 8px;
            font-size: 0.9rem;
            color: #666;
        }
        
        /* Requirements */
        .requirements {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 1rem;
            margin-top: 2rem;
            border-left: 4px solid #27ae60;
        }
        
        .requirements h3 {
            color: #27ae60;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .requirements ul {
            padding-left: 1.5rem;
            color: #555;
        }
        
        .requirements li {
            margin-bottom: 5px;
            font-size: 0.95rem;
        }
        
        /* Buttons */
        .form-actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 2px solid #f0f0f0;
        }
        
        .btn {
            flex: 1;
            padding: 12px;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.3s;
            font-size: 1rem;
            text-decoration: none;
        }
        
        .btn-primary {
            background: #3498db;
            color: white;
            border: none;
        }
        
        .btn-primary:hover {
            background: #2980b9;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.3);
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
        
        .btn-profile {
            background: #6c757d;
            color: white;
            border: none;
        }
        
        .btn-profile:hover {
            background: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(108, 117, 125, 0.3);
        }
        
        /* Alert */
        .alert {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 10px;
            background: #fff3cd;
            color: #856404;
            border-left: 4px solid #f39c12;
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
            
            .form-card {
                padding: 1.5rem;
            }
            
            .form-actions {
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
        
        <!-- Alert -->
        <div class="alert">
            <i class="fas fa-exclamation-circle"></i>
            <span>
                <strong>Importante:</strong> Solo puedes modificar tesis en estado "borrador". 
                Una vez enviada, no podrás editarla.
            </span>
        </div>
        
        <!-- Form Card -->
        <div class="form-card">
            <div class="form-header">
                <h1><i class="fas fa-cloud-upload-alt"></i> Subir Nueva Tesis</h1>
                <p>Completa el formulario para registrar tu trabajo de tesis en el sistema</p>
            </div>
            
            <form action="<%= request.getContextPath() %>/tesis" method="post" enctype="multipart/form-data" id="tesisForm">
                <!-- Título -->
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-heading"></i>
                        Título de la Tesis
                    </label>
                    <input type="text" name="titulo" class="form-control" 
                           placeholder="Ingresa el título completo de tu tesis" 
                           required maxlength="200">
                </div>
                
                <!-- Descripción -->
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-align-left"></i>
                        Descripción / Resumen
                    </label>
                    <textarea name="descripcion" class="form-control" 
                              placeholder="Describe brevemente el contenido de tu tesis (mínimo 100 caracteres)"
                              required rows="4" id="descripcion"></textarea>
                    <div id="charCounter" style="font-size: 0.85rem; color: #666; text-align: right; margin-top: 5px;">
                        0 caracteres (mínimo 100)
                    </div>
                </div>
                
                <!-- Asesor -->
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-user-tie"></i>
                        Seleccionar Asesor
                    </label>
                    <select name="id_asesor" class="form-control" required>
                        <option value="">-- Selecciona un asesor --</option>
                        <% for (Usuario a : asesores) { %>
                        <option value="<%= a.getIdUsuario() %>">
                            <%= a.getNombreCompleto() %> - <%= a.getDepartamento() %>
                        </option>
                        <% } %>
                    </select>
                </div>
                
                <!-- Archivo -->
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-file-pdf"></i>
                        Documento de Tesis (PDF)
                    </label>
                    <div class="file-upload">
                        <input type="file" name="archivo" id="archivoInput" 
                               class="form-control file-input" 
                               accept="application/pdf" required>
                        <div class="file-info">
                            <i class="fas fa-info-circle" style="color: #3498db;"></i>
                            <span id="fileName">No se ha seleccionado ningún archivo</span>
                        </div>
                    </div>
                </div>
                
                <!-- Requirements -->
                <div class="requirements">
                    <h3><i class="fas fa-clipboard-check"></i> Requisitos del archivo</h3>
                    <ul>
                        <li>Solo se aceptan archivos en formato PDF (.pdf)</li>
                        <li>Tamaño máximo: 10 MB</li>
                        <li>El archivo debe contener toda la tesis completa</li>
                        <li>Verifica que el documento sea legible y esté completo</li>
                    </ul>
                </div>
                
                <!-- Form Actions -->
                <div class="form-actions">
                    <button type="button" class="btn btn-outline" onclick="window.location.href='dashboard.jsp'">
                        <i class="fas fa-times"></i> Cancelar
                    </button>
                    <button type="button" class="btn btn-profile" onclick="window.location.href='ver-perfil.jsp'">
                        <i class="fas fa-user-circle"></i> Ver Perfil
                    </button>
                    <button type="submit" class="btn btn-primary" id="submitBtn">
                        <i class="fas fa-paper-plane"></i> Enviar Tesis
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        // Mostrar nombre del archivo seleccionado
        document.getElementById('archivoInput').addEventListener('change', function(e) {
            const fileName = e.target.files[0] ? e.target.files[0].name : 'No se ha seleccionado ningún archivo';
            document.getElementById('fileName').textContent = fileName;
            
            // Validar tipo de archivo
            const file = e.target.files[0];
            if (file && !file.type.includes('pdf')) {
                alert('Error: Solo se permiten archivos PDF.');
                e.target.value = '';
                document.getElementById('fileName').textContent = 'No se ha seleccionado ningún archivo';
            }
            
            // Validar tamaño (10MB)
            if (file && file.size > 10 * 1024 * 1024) {
                alert('Error: El archivo excede el tamaño máximo de 10MB.');
                e.target.value = '';
                document.getElementById('fileName').textContent = 'No se ha seleccionado ningún archivo';
            }
        });
        
        // Contador de caracteres para descripción
        document.getElementById('descripcion').addEventListener('input', function(e) {
            const length = e.target.value.length;
            const counter = document.getElementById('charCounter');
            
            counter.textContent = `${length} caracteres ${length < 100 ? '(mínimo 100)' : ''}`;
            counter.style.color = length < 100 ? '#e74c3c' : '#27ae60';
        });
        
        // Validar formulario antes de enviar
        document.getElementById('tesisForm').addEventListener('submit', function(e) {
            const titulo = document.querySelector('input[name="titulo"]').value.trim();
            const descripcion = document.getElementById('descripcion').value.trim();
            const asesor = document.querySelector('select[name="id_asesor"]').value;
            const archivo = document.getElementById('archivoInput').value;
            
            if (!titulo || !descripcion || !asesor || !archivo) {
                e.preventDefault();
                alert('Por favor, complete todos los campos requeridos.');
                return;
            }
            
            if (descripcion.length < 100) {
                e.preventDefault();
                alert('La descripción debe tener al menos 100 caracteres.');
                return;
            }
            
            // Cambiar texto del botón durante el envío
            const submitBtn = document.getElementById('submitBtn');
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Enviando...';
            submitBtn.disabled = true;
        });
    </script>
</body>
</html>