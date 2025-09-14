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
        <a href="https://github.com/usuario/repositorio/semana${numero}" class="btn" target="_blank">🔗 Ver en GitHub</a>
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
