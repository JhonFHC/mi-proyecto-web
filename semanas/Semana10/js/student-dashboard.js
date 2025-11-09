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
        const firstName = userData.name.split(' ')[0];
        welcomeHeading.textContent = `¡Bienvenido de nuevo, ${firstName}!`;
    }
    
    // Configurar eventos de los botones
    setupEventListeners();
});

