const Mode = document.querySelector('.checkbox');
const Dark = document.querySelector('.fa-sun');
const Light =document.querySelector('.fa-moon')
Dark.addEventListener('click', ()=> {
    Mode.classList.add('active');
});
Light.addEventListener('click', ()=> {
    Mode.classList.remove('active');
});
