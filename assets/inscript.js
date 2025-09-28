document.addEventListener('DOMContentLoaded', function() {
  // Evento click en el portal (animación fly-away y redirección)
  const portal = document.getElementById("portal");
  if (portal) {
    portal.addEventListener("click", function () {
      const target = this.dataset.target;
      this.classList.add("fly-away");

      setTimeout(() => {
        window.location.href = target;
      }, 900); // Espera a que termine la animación
    });
  }
});