document.addEventListener('DOMContentLoaded', () => {
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

  prevBtn.addEventListener('click', () => showSlide(currentIndex - 1));
  nextBtn.addEventListener('click', () => showSlide(currentIndex + 1));

  dots.forEach(dot => {
    dot.addEventListener('click', () => {
      const index = parseInt(dot.getAttribute('data-index'));
      showSlide(index);
    });
  });

  setInterval(() => {
    showSlide(currentIndex + 1);
  }, 5000);

  showSlide(currentIndex);
});