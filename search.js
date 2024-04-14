const Search = document.querySelector('.box');
const searchIcon =document.querySelector('.fa-search')
const iconSearchClose = document.querySelector('.fa-times');
searchIcon.addEventListener('click', ()=> {
    Search.classList.add('active');
});
iconSearchClose.addEventListener('click', ()=> {
    Search.classList.remove('active');
});