const theme = document.querySelector('.web');
const light = document.querySelector('.light .fa-sun');
const system =document.querySelector('.system .fa-computer');
const dark =document.querySelector('.dark .fa-moon')
light.addEventListener('click', ()=> {
    theme.classList.add('activeLight');
});
system.addEventListener('click', ()=> {
    theme.classList.remove('activeLight');
});
dark.addEventListener('click', ()=> {
    theme.classList.add('activeDark');
});
system.addEventListener('click', ()=> {
    theme.classList.remove('activeDark');
});
