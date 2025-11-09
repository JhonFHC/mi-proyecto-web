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
    
    // Actualizar mensaje de bienvenida
    const welcomeHeading = document.querySelector('.welcome-section h2');
    if (welcomeHeading) {
        welcomeHeading.textContent = `Bienvenida, ${userData.name.split(' ')[0]}!`;
    }
    
    // Configurar eventos de los botones
    setupEventListeners();
    
    // Inicializar filtros
    initializeFilters();
});

function setupEventListeners() {
    // Botones de acción en la tabla
    const actionButtons = document.querySelectorAll('.actions-cell button');
    actionButtons.forEach(button => {
        button.addEventListener('click', function() {
            const row = this.closest('.table-row');
            const studentName = row.querySelector('.user-info p').textContent;
            const thesisTitle = row.querySelector('div:nth-child(2)').textContent;
            
            if (this.textContent.includes('Iniciar')) {
                alert(`Iniciando evaluación de: "${thesisTitle}" por ${studentName}`);
                // Redirigir a página de evaluación
                // window.location.href = 'evaluation-form.html';
            } else if (this.textContent.includes('Continuar')) {
                alert(`Continuando evaluación de: "${thesisTitle}"`);
                // Redirigir a página de evaluación
                // window.location.href = 'evaluation-form.html';
            } else if (this.textContent.includes('Ver')) {
                alert(`Mostrando evaluación completada de: "${thesisTitle}"`);
                // Mostrar evaluación completada
            }
        });
    });
    
    // Botón de evaluación urgente
    const urgentEvalBtn = document.querySelector('.review-actions .btn-primary');
    if (urgentEvalBtn) {
        urgentEvalBtn.addEventListener('click', function() {
            alert('Iniciando evaluación de tesis urgente: "IA en Sistemas Educativos"');
            // Redirigir a página de evaluación
            // window.location.href = 'evaluation-form.html';
        });
    }
    
    // Botón de solicitar extensión
    const extensionBtn = document.querySelector('.review-actions .btn-outline');
    if (extensionBtn) {
        extensionBtn.addEventListener('click', function() {
            const reason = prompt('Por favor, ingresa el motivo para solicitar una extensión:');
            if (reason) {
                alert('Solicitud de extensión enviada a administración.');
            }
        });
    }
    
    // Botones de herramientas
    const toolButtons = document.querySelectorAll('.tool-card .btn-primary');
    toolButtons.forEach((button, index) => {
        button.addEventListener('click', function() {
            const toolTitles = [
                'Formulario de Evaluación',
                'Guía de Rúbrica',
                'Evaluaciones Anteriores'
            ];
            alert(`Abriendo: ${toolTitles[index]}`);
            // Aquí iría la lógica para abrir cada herramienta
        });
    });
}

function initializeFilters() {
    const filterSelect = document.querySelector('.filter-select');
    if (filterSelect) {
        filterSelect.addEventListener('change', function() {
            const status = this.value;
            const rows = document.querySelectorAll('.table-row');
            
            rows.forEach(row => {
                const statusBadge = row.querySelector('.status-badge');
                if (status === 'Todos los Estados' || 
                    statusBadge.textContent.toLowerCase().includes(status.toLowerCase())) {
                    row.style.display = 'grid';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    }
}

// Función para simular notificaciones
function checkDeadlines() {
    const urgentItems = document.querySelectorAll('.urgency-badge, .warning');
    if (urgentItems.length > 0) {
        showNotification(`Tienes ${urgentItems.length} evaluaciones con fechas límite próximas`, 'warning');
    }
}

function showNotification(message, type = 'info') {
    // Evitar notificaciones duplicadas
    const existingNotification = document.querySelector('.custom-notification');
    if (existingNotification) {
        existingNotification.remove();
    }
    
    const notification = document.createElement('div');
    notification.className = `custom-notification ${type}`;
    notification.textContent = message;
    notification.style.cssText = `
        position: fixed;
        top: 100px;
        right: 20px;
        padding: 12px 20px;
        background: ${type === 'warning' ? '#F59E0B' : type === 'error' ? '#EF4444' : '#3B82F6'};
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

// Verificar deadlines al cargar la página
setTimeout(checkDeadlines, 2000);


