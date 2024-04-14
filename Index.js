let spanTexts=document.getElementsByTagName("span");
window.onload=function(){
    for(spanText of spanTexts){
        spanText.classList.add("active");
    }
}
