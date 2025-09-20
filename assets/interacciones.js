document.addEventListener('DOMContentLoaded', () => {
  // Animación de entrada (fade-in)
  const fadeInSections = document.querySelectorAll('.fade-in');

  const observer = new IntersectionObserver(entries => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
      }
    });
  }, {
    threshold: 0.1,
  });

  fadeInSections.forEach(section => observer.observe(section));

  // Efecto "volar" en botones del navbar
  const navLinks = document.querySelectorAll('.navbar a');

  navLinks.forEach(link => {
    const label = link.textContent.trim();
    link.setAttribute('data-text', label);

    link.addEventListener('click', (e) => {
      e.preventDefault(); // Prevenir navegación inmediata
      link.classList.add('clicked');

      const href = link.getAttribute('href');

      setTimeout(() => {
        window.location.href = href;
      }, 400); // Espera que termine la animación
    });
  });
});