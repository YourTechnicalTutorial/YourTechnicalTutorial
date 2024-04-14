const moreLess = document.querySelector('.up-down');
const More = document.querySelector('.fa-chevron-down');
const Less =document.querySelector('.fa-chevron-up')
More.addEventListener('click', ()=> {
    moreLess.classList.add('active');
});
Less.addEventListener('click', ()=> {
    moreLess.classList.remove('active');
});
