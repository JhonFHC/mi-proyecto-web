// ===============================
// Animación de partículas (solo modo oscuro)
// ===============================

const canvas = document.getElementById('particles');
if (canvas) {
  const ctx = canvas.getContext('2d');
  let w, h;
  let particlesArray = [];

  function resizeCanvas() {
    w = window.innerWidth;
    h = window.innerHeight;
    canvas.width = w;
    canvas.height = h;
  }
  window.addEventListener('resize', resizeCanvas);
  resizeCanvas();

  class Particle {
    constructor() {
      this.x = Math.random() * w;
      this.y = Math.random() * h;
      this.radius = Math.random() * 1.5 + 0.5;
      this.speedX = (Math.random() - 0.5) * 0.3;
      this.speedY = (Math.random() - 0.5) * 0.3;
      this.opacity = Math.random() * 0.5 + 0.1;
    }
    update() {
      this.x += this.speedX;
      this.y += this.speedY;

      if (this.x > w) this.x = 0;
      if (this.x < 0) this.x = w;
      if (this.y > h) this.y = 0;
      if (this.y < 0) this.y = h;
    }
    draw() {
      ctx.beginPath();
      ctx.fillStyle = `rgba(0, 255, 195, ${this.opacity})`; /* Verde cian para tema oscuro */
      ctx.shadowColor = 'rgba(0, 255, 195, 0.7)';
      ctx.shadowBlur = 5;
      ctx.arc(this.x, this.y, this.radius, 0, Math.PI * 2);
      ctx.fill();
    }
  }

  function initParticles() {
    particlesArray = [];
    for (let i = 0; i < 100; i++) {
      particlesArray.push(new Particle());
    }
  }

  function animateParticles() {
    ctx.clearRect(0, 0, w, h);
    particlesArray.forEach(p => {
      p.update();
      p.draw();
    });
    requestAnimationFrame(animateParticles);
  }

  initParticles();
  animateParticles();
}