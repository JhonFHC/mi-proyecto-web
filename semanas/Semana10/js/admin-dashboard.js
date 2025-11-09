// Cargar datos del usuario
document.addEventListener('DOMContentLoaded', function() {
    const userData = JSON.parse(sessionStorage.getItem('currentUser'));
    
    if (!userData) {
        window.location.href = 'index.html';
        return;
    }
    
    // Actualizar nombre de usuario en el dashboard
    const userNameElements = document.querySelectorAll('.user-profile span');
    userNameElements.forEach(element => {
        if (!element.classList.contains('logout-btn')) {
            element.textContent = userData.name;
        }
    });
    
    // Configurar eventos de los botones
    setupEventListeners();
    
    // Inicializar funcionalidades
    initializeAdminFeatures();
});

function setupEventListeners() {
    // Botones de acción rápida
    const actionCards = document.querySelectorAll('.action-card');
    actionCards.forEach((card, index) => {
        card.addEventListener('click', function() {
            const actions = [
                'Agregar Nuevo Usuario',
                'Subir Documentos de Tesis',
                'Asignar Evaluadores',
                'Generar Reportes del Sistema'
            ];
            
            alert(`Iniciando: ${actions[index]}`);
            
            // Aquí iría la lógica específica para cada acción
            switch(index) {
                case 0:
                    // Abrir modal de agregar usuario
                    openAddUserModal();
                    break;
                case 1:
                    // Abrir modal de subir tesis
                    openUploadThesisModal();
                    break;
                case 2:
                    // Abrir modal de asignar evaluadores
                    openAssignEvaluatorModal();
                    break;
                case 3:
                    // Generar reportes
                    generateSystemReports();
                    break;
            }
        });
    });
    
    // Botón de ver todas las evaluaciones
    const viewAllBtn = document.querySelector('.evaluations-section .btn-primary');
    if (viewAllBtn) {
        viewAllBtn.addEventListener('click', function() {
            alert('Mostrando todas las evaluaciones del sistema...');
            // Aquí iría la lógica para cargar todas las evaluaciones
        });
    }
    
    // Botón de agregar usuario
    const addUserBtn = document.querySelector('.users-section .btn-primary');
    if (addUserBtn) {
        addUserBtn.addEventListener('click', openAddUserModal);
    }
    
    // Botones de editar y eliminar
    const editButtons = document.querySelectorAll('.icon-btn:not(.danger)');
    editButtons.forEach(button => {
        button.addEventListener('click', function() {
            const row = this.closest('.table-row');
            const userName = row.querySelector('.user-info p').textContent;
            alert(`Editando usuario: ${userName}`);
        });
    });
    
    const deleteButtons = document.querySelectorAll('.icon-btn.danger');
    deleteButtons.forEach(button => {
        button.addEventListener('click', function() {
            const row = this.closest('.table-row');
            const userName = row.querySelector('.user-info p').textContent;
            
            if (confirm(`¿Estás seguro de que deseas eliminar al usuario: ${userName}?`)) {
                alert(`Usuario ${userName} eliminado correctamente.`);
                row.remove();
            }
        });
    });
    
    // Botones de configuración
    const configButtons = document.querySelectorAll('.setting-card .btn-outline');
    configButtons.forEach((button, index) => {
        button.addEventListener('click', function() {
            const settings = [
                'Configuración de Calendario Académico',
                'Gestión de Criterios de Evaluación',
                'Ajustes de Notificaciones',
                'Proceso de Respaldo del Sistema'
            ];
            alert(`Abriendo: ${settings[index]}`);
        });
    });
}

function initializeAdminFeatures() {
    // Simular datos en tiempo real
    updateRealTimeStats();
    
    // Configurar actualizaciones automáticas
    setInterval(updateRealTimeStats, 30000); // Actualizar cada 30 segundos
    
    // Verificar estado del sistema
    checkSystemStatus();
}

function updateRealTimeStats() {
    // Simular actualización de estadísticas en tiempo real
    const stats = document.querySelectorAll('.stat-value');
    if (stats.length >= 4) {
        // Simular pequeños cambios en las estadísticas
        const changes = [2, -1, 1, 3]; // Cambios simulados
        stats.forEach((stat, index) => {
            const currentValue = parseInt(stat.textContent);
            const newValue = Math.max(0, currentValue + changes[index]);
            stat.textContent = newValue;
        });
        
        showNotification('Estadísticas del sistema actualizadas', 'success');
    }
}

function checkSystemStatus() {
    // Simular verificación del estado del sistema
    const issues = Math.random() > 0.7; // 30% de probabilidad de issues
    if (issues) {
        showNotification('Se detectaron problemas menores en el sistema. Revisar logs.', 'warning');
    }
}

function openAddUserModal() {
    const modalHTML = `
        <div class="modal-overlay">
            <div class="modal-content">
                <h3>Agregar Nuevo Usuario</h3>
                <form id="addUserForm">
                    <div class="form-group">
                        <label>Nombre Completo:</label>
                        <input type="text" required>
                    </div>
                    <div class="form-group">
                        <label>Correo Electrónico:</label>
                        <input type="email" required>
                    </div>
                    <div class="form-group">
                        <label>Rol:</label>
                        <select required>
                            <option value="">Seleccionar rol</option>
                            <option value="student">Estudiante</option>
                            <option value="teacher">Profesor</option>
                            <option value="admin">Administrador</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Departamento:</label>
                        <input type="text">
                    </div>
                    <div class="modal-actions">
                        <button type="button" class="btn-secondary" onclick="closeModal()">Cancelar</button>
                        <button type="submit" class="btn-primary">Agregar Usuario</button>
                    </div>
                </form>
            </div>
        </div>
    `;
    
    document.body.insertAdjacentHTML('beforeend', modalHTML);
    
    document.getElementById('addUserForm').addEventListener('submit', function(e) {
        e.preventDefault();
        alert('Usuario agregado correctamente al sistema.');
        closeModal();
    });
}

function openUploadThesisModal() {
    alert('Funcionalidad de subida de tesis - Esta característica se implementará en la próxima versión.');
}

function openAssignEvaluatorModal() {
    alert('Funcionalidad de asignación de evaluadores - Esta característica se implementará en la próxima versión.');
}

function generateSystemReports() {
    alert('Generando reportes del sistema... Esto puede tomar unos momentos.');
    // Simular generación de reportes
    setTimeout(() => {
        showNotification('Reportes generados correctamente. Descarga disponible.', 'success');
    }, 2000);
}

function closeModal() {
    const modal = document.querySelector('.modal-overlay');
    if (modal) {
        modal.remove();
    }
}

function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `admin-notification ${type}`;
    notification.textContent = message;
    notification.style.cssText = `
        position: fixed;
        top: 100px;
        right: 20px;
        padding: 12px 20px;
        background: ${type === 'success' ? '#10B981' : type === 'warning' ? '#F59E0B' : type === 'error' ? '#EF4444' : '#3B82F6'};
        color: white;
        border-radius: 8px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        z-index: 1000;
        max-width: 300px;
    `;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.remove();
    }, 5000);
}

// Cerrar modal con ESC
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeModal();
    }
});


