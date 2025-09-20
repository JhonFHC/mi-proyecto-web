// Datos de las semanas (puedes cambiar títulos aquí)
const semanas = [
  "Introducción al desarrollo web",
  "HTML Semántico y Estructura Básica",
  "CSS Básico y Estilos en Línea",
  "Selectores de CSS y Model Box",
  "Colores, Tipografía y Unidades en CSS",
  "Posicionamiento y Display en CSS",
  "Flexbox y Layout Responsivo",
  "Media Queries y Diseño Adaptativo",
  "Introducción a JavaScript",
  "Variables, Tipos de Datos y Operadores",
  "Estructuras de Control y Funciones",
  "DOM y Manipulación de Elementos",
  "Eventos en JavaScript",
  "Arreglos y Objetos en JavaScript",
  "Proyecto Final – Maquetación Web",
  "Presentación de Proyectos y Evaluación",
];

// Generar dinámicamente el contenido
const contenedor = document.getElementById("contenedor-semanas");

semanas.forEach((titulo, i) => {
  const numero = i + 1;

  const semanaHTML = `
    <div class="semana">
      <button class="acordeon">Semana ${numero}</button>
      <div class="panel">
        <p>Título: ${titulo}</p>
        <a href="semana${numero}.html" class="btn">📖 Ver Contenido</a>
        <a href="downloads/Taller Aplicaciones - Semana${numero}.docx" class="btn" download>⬇️ Descargar</a>
        <a href="https://github.com/JhonFHC/mi-proyecto-web" class="btn" target="_blank">🔗 Ver en GitHub</a>
      </div>
    </div>
  `;

  contenedor.innerHTML += semanaHTML;
});

// Funcionalidad del acordeón (se ejecuta después de generar el HTML)
setTimeout(() => {
  const acordeones = document.querySelectorAll(".acordeon");

  acordeones.forEach((btn) => {
    btn.addEventListener("click", function () {
      this.classList.toggle("active");
      const panel = this.nextElementSibling;
      if (panel.style.maxHeight) {
        panel.style.maxHeight = null;
      } else {
        panel.style.maxHeight = panel.scrollHeight + "px";
      }
    });
  });
}, 0);

// SLIDER - Funcionalidad
const slides = document.querySelector('.slides');
const dots = document.querySelectorAll('.dot');
const prevBtn = document.querySelector('.prev');
const nextBtn = document.querySelector('.next');
let currentIndex = 0;
const totalSlides = dots.length;

function showSlide(index) {
  if (index >= totalSlides) currentIndex = 0;
  else if (index < 0) currentIndex = totalSlides - 1;
  else currentIndex = index;
  
  const offset = -currentIndex * 100;
  slides.style.transform = `translateX(${offset}%)`;

  dots.forEach(dot => dot.classList.remove('active'));
  dots[currentIndex].classList.add('active');
}

// Manejo de los botones de navegación del slider
prevBtn.addEventListener('click', () => showSlide(currentIndex - 1));
nextBtn.addEventListener('click', () => showSlide(currentIndex + 1));

// Manejo de los puntos de navegación
dots.forEach(dot => {
  dot.addEventListener('click', () => {
    const index = parseInt(dot.getAttribute('data-index'));
    showSlide(index);
  });
});

// Auto-slide (opcional)
setInterval(() => {
  showSlide(currentIndex + 1);
}, 5000);

// Inicializar
showSlide(currentIndex);