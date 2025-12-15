<%@ page import="com.zonajava.sistemaevaluaciontesis.model.Usuario" %>
<%
    Usuario asesor = (Usuario) session.getAttribute("usuario");
    if (asesor == null || !"asesor".equals(asesor.getRol())) {
        response.sendRedirect(request.getContextPath() + "/vistas/login.jsp");
        return;
    }
    
    String param = request.getParameter("id_tesis");
    if (param == null) {
        response.sendRedirect(request.getContextPath() + "/asesor?error=no_tesis");
        return;
    }
    int idTesis = Integer.parseInt(param);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Evaluación de Tesis - Asesor</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/global.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #2980b9;
            --secondary: #2c3e50;
            --success: #27ae60;
            --warning: #f39c12;
            --danger: #e74c3c;
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
        
        .evaluation-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        
        /* Header */
        .evaluation-header {
            background: linear-gradient(to right, var(--primary), var(--secondary));
            color: white;
            padding: 1.5rem 2rem;
            border-radius: 12px 12px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .header-actions {
            display: flex;
            gap: 1rem;
        }
        
        .btn {
            padding: 0.5rem 1.5rem;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            border: none;
            cursor: pointer;
            font-size: 1rem;
        }
        
        .btn-back {
            background: rgba(255,255,255,0.2);
            color: white;
            border: 1px solid rgba(255,255,255,0.3);
        }
        
        .btn-logout {
            background: var(--danger);
            color: white;
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        
        /* Form Container */
        .form-container {
            background: white;
            border-radius: 0 0 12px 12px;
            padding: 2rem;
            box-shadow: 0 6px 15px rgba(0,0,0,0.1);
        }
        
        .form-title {
            color: var(--secondary);
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #eee;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .form-info {
            background: #f8f9fa;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            border-left: 4px solid var(--primary);
        }
        
        /* Form Elements */
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: var(--dark);
            font-weight: 600;
        }
        
        .form-control {
            width: 100%;
            padding: 0.8rem 1rem;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 1rem;
            transition: border 0.3s;
            font-family: inherit;
        }
        
        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(41, 128, 185, 0.1);
        }
        
        textarea.form-control {
            min-height: 150px;
            resize: vertical;
        }
        
        /* Radio Group */
        .radio-group {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 0.5rem;
        }
        
        .radio-option {
            display: flex;
            align-items: center;
            padding: 1rem;
            border: 2px solid #ddd;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .radio-option:hover {
            border-color: var(--primary);
            background: #f8f9fa;
        }
        
        .radio-option input[type="radio"] {
            margin-right: 0.8rem;
            transform: scale(1.2);
        }
        
        .radio-label {
            flex: 1;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--dark);
            font-weight: 500;
        }
        
        .radio-icon {
            font-size: 1.2rem;
        }
        
        /* Buttons */
        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 1rem;
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 2px solid #eee;
        }
        
        .btn-submit {
            background: var(--success);
            color: white;
            padding: 0.8rem 2rem;
        }
        
        .btn-cancel {
            background: #95a5a6;
            color: white;
        }
        
        /* Alerts */
        .alert {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.8rem;
        }
        
        .alert-info {
            background: #d1ecf1;
            border: 1px solid #bee5eb;
            color: #0c5460;
        }
        
        .alert-warning {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
        }
        
        @media (max-width: 768px) {
            .evaluation-header {
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }
            
            .radio-group {
                grid-template-columns: 1fr;
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="evaluation-container">
        <!-- Header -->
        <div class="evaluation-header">
            <div>
                <h2><i class="fas fa-clipboard-check"></i> Formato N.° 4 - Evaluación del Asesor</h2>
                <p style="opacity: 0.9; margin-top: 0.3rem;">Evaluación académica de tesis asignada</p>
            </div>
            <div class="header-actions">
                <a href="<%= request.getContextPath() %>/asesor" class="btn btn-back">
                    <i class="fas fa-arrow-left"></i> Volver
                </a>
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-logout">
                    <i class="fas fa-sign-out-alt"></i> Cerrar Sesión
                </a>
            </div>
        </div>
        
        <!-- Form -->
        <div class="form-container">
            <!-- Info Alert -->
            <div class="alert alert-info">
                <i class="fas fa-info-circle"></i>
                <div>
                    <strong>Instrucciones:</strong> Complete este formulario con su evaluación profesional. 
                    La recomendación será definitiva para el proceso de la tesis.
                </div>
            </div>
            
            <!-- Warning Alert -->
            <div class="alert alert-warning">
                <i class="fas fa-exclamation-triangle"></i>
                <div>
                    <strong>Importante:</strong> Una vez enviada, la evaluación no podrá ser modificada. 
                    Revise cuidadosamente antes de enviar.
                </div>
            </div>
            
            <form id="evaluationForm" action="<%= request.getContextPath() %>/evaluar-asesor" method="post" onsubmit="return validateForm()">
                <input type="hidden" name="id_tesis" value="<%= idTesis %>">
                
                <!-- Form Info -->
                <div class="form-info">
                    <p><strong>ID de Tesis:</strong> <%= idTesis %></p>
                    <p><strong>Asesor:</strong> <%= asesor.getNombreCompleto() %></p>
                    <p><strong>Fecha:</strong> <%= new java.util.Date() %></p>
                </div>
                
                <!-- Observaciones -->
                <div class="form-group">
                    <label for="observaciones">
                        <i class="fas fa-comment-alt"></i> Observaciones Detalladas
                    </label>
                    <textarea 
                        id="observaciones" 
                        name="observaciones" 
                        class="form-control" 
                        placeholder="Describa detalladamente las observaciones sobre la tesis, fortalezas, debilidades, y sugerencias de mejora..."
                        required></textarea>
                    <small style="color: #666; margin-top: 0.5rem; display: block;">
                        Mínimo 100 caracteres. Sea específico y constructivo.
                    </small>
                </div>
                
                <!-- Recomendación -->
                <div class="form-group">
                    <label><i class="fas fa-gavel"></i> Recomendación Final</label>
                    <div class="radio-group">
                        <label class="radio-option">
                            <input type="radio" name="recomendacion" value="aprobada" required>
                            <div class="radio-label">
                                <i class="fas fa-check-circle radio-icon" style="color: var(--success);"></i>
                                <div>
                                    <strong>Aprobar</strong>
                                    <div style="font-size: 0.85rem; opacity: 0.8;">
                                        La tesis cumple con todos los requisitos
                                    </div>
                                </div>
                            </div>
                        </label>
                        
                        <label class="radio-option">
                            <input type="radio" name="recomendacion" value="observada" required>
                            <div class="radio-label">
                                <i class="fas fa-exclamation-circle radio-icon" style="color: var(--warning);"></i>
                                <div>
                                    <strong>Observar</strong>
                                    <div style="font-size: 0.85rem; opacity: 0.8;">
                                        La tesis requiere correcciones
                                    </div>
                                </div>
                            </div>
                        </label>
                    </div>
                </div>
                
                <!-- Condiciones -->
                <div class="form-group">
                    <div style="display: flex; align-items: start; gap: 0.8rem; padding: 1rem; background: #f8f9fa; border-radius: 8px;">
                        <input type="checkbox" id="confirmacion" required style="margin-top: 0.3rem;">
                        <label for="confirmacion" style="margin: 0; color: var(--dark);">
                            <strong>Confirmo que:</strong>
                            <ul style="margin-top: 0.5rem; padding-left: 1.2rem;">
                                <li>He revisado completamente la tesis</li>
                                <li>Mi evaluación es objetiva y basada en criterios académicos</li>
                                <li>He sido imparcial en mi evaluación</li>
                                <li>Acepto que esta evaluación es definitiva</li>
                            </ul>
                        </label>
                    </div>
                </div>
                
                <!-- Actions -->
                <div class="form-actions">
                    <a href="<%= request.getContextPath() %>/asesor" class="btn btn-cancel">
                        <i class="fas fa-times"></i> Cancelar
                    </a>
                    <button type="submit" class="btn btn-submit">
                        <i class="fas fa-paper-plane"></i> Enviar Evaluación
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function validateForm() {
            const observaciones = document.getElementById('observaciones').value.trim();
            const recomendacion = document.querySelector('input[name="recomendacion"]:checked');
            const confirmacion = document.getElementById('confirmacion').checked;
            
            if (observaciones.length < 100) {
                alert('Las observaciones deben tener al menos 100 caracteres.');
                return false;
            }
            
            if (!recomendacion) {
                alert('Debe seleccionar una recomendación.');
                return false;
            }
            
            if (!confirmacion) {
                alert('Debe confirmar los términos de la evaluación.');
                return false;
            }
            
            // Mostrar confirmación final
            const recomendacionText = recomendacion.value === 'aprobada' ? 'APROBAR' : 'OBSERVAR';
            return confirm(`¿Está seguro de enviar su evaluación?\n\nRecomendación: ${recomendacionText}\n\nEsta acción no se puede deshacer.`);
        }
        
        // Contador de caracteres
        const textarea = document.getElementById('observaciones');
        const charCount = document.createElement('div');
        charCount.style.cssText = 'text-align: right; font-size: 0.85rem; color: #666; margin-top: 0.5rem;';
        textarea.parentNode.insertBefore(charCount, textarea.nextSibling);
        
        function updateCharCount() {
            const length = textarea.value.length;
            charCount.textContent = `${length} caracteres ${length < 100 ? ' (mínimo 100)' : ''}`;
            charCount.style.color = length < 100 ? '#e74c3c' : length < 200 ? '#f39c12' : '#27ae60';
        }
        
        textarea.addEventListener('input', updateCharCount);
        updateCharCount();
        
        // Efecto visual para opciones seleccionadas
        document.querySelectorAll('.radio-option').forEach(option => {
            const radio = option.querySelector('input[type="radio"]');
            radio.addEventListener('change', function() {
                document.querySelectorAll('.radio-option').forEach(opt => {
                    opt.style.borderColor = '#ddd';
                    opt.style.background = '';
                });
                if (this.checked) {
                    option.style.borderColor = this.value === 'aprobada' ? '#27ae60' : '#f39c12';
                    option.style.background = this.value === 'aprobada' ? '#eafaf1' : '#fef9e7';
                }
            });
        });
    </script>
</body>
</html>