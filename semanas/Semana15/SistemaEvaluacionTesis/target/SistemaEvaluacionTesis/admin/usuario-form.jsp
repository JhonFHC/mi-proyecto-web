<%@ page import="com.zonajava.sistemaevaluaciontesis.model.Usuario" %>
<%
    Usuario admin = (Usuario) session.getAttribute("usuario");
    if (admin == null || !"admin".equals(admin.getRol())) {
        response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
        return;
    }
    
    Usuario usuario = (Usuario) request.getAttribute("usuario");
    boolean isEdit = usuario != null;
    String title = isEdit ? "Editar Usuario" : "Nuevo Usuario";
    String action = isEdit ? "actualizar" : "guardar";
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= title %> - Admin</title>
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
        
        .form-container {
            max-width: 800px;
            margin: 40px auto;
            background: white;
            border-radius: 16px;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
            overflow: hidden;
        }
        
        .form-header {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .form-header h1 {
            font-size: 28px;
            margin-bottom: 10px;
            font-weight: 600;
        }
        
        .form-header p {
            opacity: 0.9;
            font-size: 16px;
            margin-bottom: 5px;
        }
        
        .form-body {
            padding: 40px;
        }
        
        .form-section {
            margin-bottom: 30px;
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
        
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
            font-size: 14px;
        }
        
        .form-label .required {
            color: #e74c3c;
        }
        
        .form-input,
        .form-select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s;
            background: white;
        }
        
        .form-input:focus,
        .form-select:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }
        
        .form-input:disabled {
            background: #f8f9fa;
            cursor: not-allowed;
        }
        
        .form-hint {
            font-size: 13px;
            color: #6c757d;
            margin-top: 6px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        
        .password-toggle {
            position: relative;
        }
        
        .toggle-btn {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #6c757d;
            cursor: pointer;
            font-size: 18px;
        }
        
        .role-options {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 15px;
            margin-top: 10px;
        }
        
        .role-option {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 15px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .role-option:hover {
            border-color: #3498db;
            background: #f8f9fa;
        }
        
        .role-option.selected {
            border-color: #3498db;
            background: #e3f2fd;
        }
        
        .role-icon {
            font-size: 24px;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            color: white;
        }
        
        .role-admin .role-icon { background: #e74c3c; }
        .role-asesor .role-icon { background: #3498db; }
        .role-jurado .role-icon { background: #9b59b6; }
        .role-estudiante .role-icon { background: #2ecc71; }
        
        .role-info h4 {
            margin: 0;
            font-size: 14px;
            font-weight: 600;
            color: #2c3e50;
        }
        
        .role-info p {
            margin: 4px 0 0 0;
            font-size: 12px;
            color: #6c757d;
        }
        
        .form-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 30px;
            margin-top: 40px;
            border-top: 1px solid #ecf0f1;
        }
        
        .btn {
            padding: 12px 28px;
            border-radius: 8px;
            text-decoration: none;
            color: white;
            font-weight: 500;
            font-size: 15px;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: none;
            cursor: pointer;
        }
        
        .btn-back {
            background: #7f8c8d;
        }
        
        .btn-back:hover {
            background: #5d6d7e;
            transform: translateY(-2px);
        }
        
        .btn-submit {
            background: #3498db;
        }
        
        .btn-submit:hover {
            background: #2980b9;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.3);
        }
        
        .btn-delete {
            background: #e74c3c;
        }
        
        .btn-delete:hover {
            background: #c0392b;
            transform: translateY(-2px);
        }
        
        .error-message {
            color: #e74c3c;
            font-size: 13px;
            margin-top: 5px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        
        .password-strength {
            margin-top: 8px;
            height: 6px;
            background: #e9ecef;
            border-radius: 3px;
            overflow: hidden;
        }
        
        .password-strength-bar {
            height: 100%;
            width: 0%;
            transition: width 0.3s, background-color 0.3s;
        }
        
        .strength-weak { background: #e74c3c; }
        .strength-medium { background: #f39c12; }
        .strength-strong { background: #2ecc71; }
        
        @media (max-width: 768px) {
            .form-container {
                margin: 20px;
            }
            
            .form-header,
            .form-body {
                padding: 25px;
            }
            
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .form-actions {
                flex-direction: column;
                gap: 15px;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="form-container">
        <div class="form-header">
            <h1><%= title %></h1>
            <p><%= isEdit ? "Modifica la información del usuario" : "Registra un nuevo usuario en el sistema" %></p>
            <a href="<%= request.getContextPath() %>/admin/usuarios" class="btn btn-back" style="margin-top: 15px;">
                ? Volver a Usuarios
            </a>
        </div>
        
        <div class="form-body">
            <form action="<%= request.getContextPath() %>/admin/usuarios" method="post" 
                  id="userForm" onsubmit="return validateForm()">
                
                <% if (isEdit) { %>
                    <input type="hidden" name="idUsuario" value="<%= usuario.getIdUsuario() %>">
                <% } %>
                <input type="hidden" name="action" value="<%= action %>">
                
                <!-- Información Básica -->
                <div class="form-section">
                    <h2 class="section-title">? Información Básica</h2>
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label">
                                Código UPLA <span class="required">*</span>
                            </label>
                            <input type="text" name="codigoUpla" class="form-input" 
                                   value="<%= isEdit ? usuario.getCodigoUpla() : "" %>" 
                                   required maxlength="20"
                                   placeholder="Ej: 20210001">
                            <div class="form-hint">Código institucional del usuario</div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">
                                Nombre Completo <span class="required">*</span>
                            </label>
                            <input type="text" name="nombreCompleto" class="form-input" 
                                   value="<%= isEdit ? usuario.getNombreCompleto() : "" %>" 
                                   required maxlength="100"
                                   placeholder="Ej: Juan Pérez Gómez">
                            <div class="form-hint">Nombre y apellidos completos</div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">
                                Email <span class="required">*</span>
                            </label>
                            <input type="email" name="email" class="form-input" 
                                   value="<%= isEdit ? usuario.getEmail() : "" %>" 
                                   required maxlength="100"
                                   placeholder="Ej: usuario@upla.cl">
                            <div class="form-hint">Correo electrónico institucional</div>
                        </div>
                        
                        <% if (!isEdit) { %>
                            <div class="form-group">
                                <label class="form-label">
                                    Contraseña <span class="required">*</span>
                                </label>
                                <div class="password-toggle">
                                    <input type="password" name="password" id="password" 
                                           class="form-input" required minlength="6"
                                           placeholder="Mínimo 6 caracteres"
                                           oninput="updatePasswordStrength()">
                                    <button type="button" class="toggle-btn" onclick="togglePassword()">??</button>
                                </div>
                                <div class="password-strength">
                                    <div class="password-strength-bar" id="passwordStrength"></div>
                                </div>
                                <div class="form-hint">La contraseña debe tener al menos 6 caracteres</div>
                            </div>
                        <% } else { %>
                            <div class="form-group">
                                <label class="form-label">
                                    Nueva Contraseña
                                </label>
                                <div class="password-toggle">
                                    <input type="password" name="password" id="password" 
                                           class="form-input" minlength="6"
                                           placeholder="Dejar vacío para no cambiar"
                                           oninput="updatePasswordStrength()">
                                    <button type="button" class="toggle-btn" onclick="togglePassword()">??</button>
                                </div>
                                <div class="password-strength">
                                    <div class="password-strength-bar" id="passwordStrength"></div>
                                </div>
                                <div class="form-hint">Dejar vacío para mantener la contraseña actual</div>
                            </div>
                        <% } %>
                    </div>
                </div>
                
                <!-- Rol y Departamento -->
                <div class="form-section">
                    <h2 class="section-title">? Rol y Departamento</h2>
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label">
                                Rol del Usuario <span class="required">*</span>
                            </label>
                            <input type="hidden" name="rol" id="selectedRole" 
                                   value="<%= isEdit ? usuario.getRol() : "" %>" required>
                            
                            <div class="role-options">
                                <div class="role-option role-admin <%= isEdit && "admin".equals(usuario.getRol()) ? "selected" : "" %>" 
                                     onclick="selectRole('admin')">
                                    <div class="role-icon">?</div>
                                    <div class="role-info">
                                        <h4>Administrador</h4>
                                        <p>Acceso total al sistema</p>
                                    </div>
                                </div>
                                
                                <div class="role-option role-asesor <%= isEdit && "asesor".equals(usuario.getRol()) ? "selected" : "" %>" 
                                     onclick="selectRole('asesor')">
                                    <div class="role-icon">?</div>
                                    <div class="role-info">
                                        <h4>Asesor</h4>
                                        <p>Revisión de tesis</p>
                                    </div>
                                </div>
                                
                                <div class="role-option role-jurado <%= isEdit && "jurado".equals(usuario.getRol()) ? "selected" : "" %>" 
                                     onclick="selectRole('jurado')">
                                    <div class="role-icon">??</div>
                                    <div class="role-info">
                                        <h4>Jurado</h4>
                                        <p>Evaluación de tesis</p>
                                    </div>
                                </div>
                                
                                <div class="role-option role-estudiante <%= isEdit && "estudiante".equals(usuario.getRol()) ? "selected" : "" %>" 
                                     onclick="selectRole('estudiante')">
                                    <div class="role-icon">?</div>
                                    <div class="role-info">
                                        <h4>Estudiante</h4>
                                        <p>Envío de tesis</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">
                                Departamento <span class="required">*</span>
                            </label>
                            <select name="departamento" class="form-select" required>
                                <option value="">Seleccionar departamento</option>
                                <option value="Ingeniería" <%= isEdit && "Ingeniería".equals(usuario.getDepartamento()) ? "selected" : "" %>>Ingeniería</option>
                                <option value="Ciencias" <%= isEdit && "Ciencias".equals(usuario.getDepartamento()) ? "selected" : "" %>>Ciencias</option>
                                <option value="Humanidades" <%= isEdit && "Humanidades".equals(usuario.getDepartamento()) ? "selected" : "" %>>Humanidades</option>
                                <option value="Educación" <%= isEdit && "Educación".equals(usuario.getDepartamento()) ? "selected" : "" %>>Educación</option>
                                <option value="Administración" <%= isEdit && "Administración".equals(usuario.getDepartamento()) ? "selected" : "" %>>Administración</option>
                                <option value="Salud" <%= isEdit && "Salud".equals(usuario.getDepartamento()) ? "selected" : "" %>>Salud</option>
                            </select>
                            <div class="form-hint">Departamento académico al que pertenece</div>
                        </div>
                    </div>
                </div>
                
                <!-- Estado (solo para edición) -->
                <% if (isEdit) { %>
                <div class="form-section">
                    <h2 class="section-title">? Estado del Usuario</h2>
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label">
                                Estado de la Cuenta
                            </label>
                            <select name="estado" class="form-select" required>
                                <option value="activo" <%= "activo".equals(usuario.getEstado()) ? "selected" : "" %>>Activo</option>
                                <option value="inactivo" <%= "inactivo".equals(usuario.getEstado()) ? "selected" : "" %>>Inactivo</option>
                            </select>
                            <div class="form-hint">Un usuario inactivo no puede acceder al sistema</div>
                        </div>
                    </div>
                </div>
                <% } %>
                
                <!-- Acciones -->
                <div class="form-actions">
                    <div>
                        <a href="<%= request.getContextPath() %>/admin/usuarios" class="btn btn-back">
                            ? Cancelar
                        </a>
                    </div>
                    
                    <div style="display: flex; gap: 15px;">
                        <% if (isEdit) { 
                            // No permitir eliminar al propio usuario
                            boolean isCurrentUser = String.valueOf(admin.getIdUsuario()).equals(String.valueOf(usuario.getIdUsuario()));
                            if (!isCurrentUser) { %>
                                <a href="<%= request.getContextPath() %>/admin/usuarios?action=eliminar&id=<%= usuario.getIdUsuario() %>" 
                                   class="btn btn-delete"
                                   onclick="return confirm('¿Está seguro de eliminar a <%= usuario.getNombreCompleto() %>?')">
                                    ?? Eliminar
                                </a>
                            <% } %>
                        <% } %>
                        
                        <button type="submit" class="btn btn-submit">
                            <%= isEdit ? "? Guardar Cambios" : "? Crear Usuario" %>
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        // Seleccionar rol
        function selectRole(role) {
            document.getElementById('selectedRole').value = role;
            
            // Quitar selección anterior
            document.querySelectorAll('.role-option').forEach(el => {
                el.classList.remove('selected');
            });
            
            // Agregar selección nueva
            document.querySelector(`.role-${role}`).classList.add('selected');
        }
        
        // Mostrar/ocultar contraseña
        function togglePassword() {
            const passwordInput = document.getElementById('password');
            const toggleBtn = document.querySelector('.toggle-btn');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleBtn.textContent = '?';
            } else {
                passwordInput.type = 'password';
                toggleBtn.textContent = '??';
            }
        }
        
        // Validar fortaleza de contraseña
        function updatePasswordStrength() {
            const password = document.getElementById('password').value;
            const strengthBar = document.getElementById('passwordStrength');
            
            if (!password) {
                strengthBar.style.width = '0%';
                strengthBar.className = 'password-strength-bar';
                return;
            }
            
            let strength = 0;
            if (password.length >= 6) strength++;
            if (password.length >= 8) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^A-Za-z0-9]/.test(password)) strength++;
            
            const width = (strength / 5) * 100;
            strengthBar.style.width = width + '%';
            
            if (strength <= 2) {
                strengthBar.className = 'password-strength-bar strength-weak';
            } else if (strength <= 4) {
                strengthBar.className = 'password-strength-bar strength-medium';
            } else {
                strengthBar.className = 'password-strength-bar strength-strong';
            }
        }
        
        // Validar formulario
        function validateForm() {
            const role = document.getElementById('selectedRole').value;
            if (!role) {
                alert('Por favor, seleccione un rol para el usuario');
                return false;
            }
            
            return true;
        }
        
        // Inicializar selección de rol si es edición
        <% if (isEdit && usuario.getRol() != null) { %>
            selectRole('<%= usuario.getRol() %>');
        <% } %>
        
        // Inicializar fortaleza de contraseña
        document.addEventListener('DOMContentLoaded', updatePasswordStrength);
    </script>
</body>
</html>