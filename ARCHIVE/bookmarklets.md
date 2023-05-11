# Bookmarklets

### Sharing

Submit on Reddit
`javascript:location.href='http://www.reddit.com/submit?url='+encodeURIComponent(location.href)+'&title='+encodeURIponent(document.title)`

Send by e-mail
`javascript:location.href='mailto:?SUBJECT='+document.title+'&BODY='+escape(location.href)

Share on Twitter
`javascript:location.href='http://twitter.com/share?url='+encodeURIComponent(window.location.href)+'&text='+encodeURIComponent(document.title)`

Shorten with ur1.ca
`javascript:myForm=document.createElement(%22form%22);myForm.style.display=%22none%22;myForm.method=%22post%22;myForm.action=%22http://ur1.ca/%22;myInput=document.createElement(%22input%22);myInput.setAttribute(%22name%22,%22longurl%22);myInput.setAttribute(%22value%22,document.URL);myForm.appendChild(myInput);document.body.appendChild(myForm);myForm.submit();document.body.removeChild(myForm);`



### Text

Dokuwiki link
`javascript:Loc=document.location;Title=document.title;Link="[["+Loc+"|"+Title+"]]";alert(Link);`

Markdown link
`javascript:void(prompt("","["+document.title+"]("+location.href+")"));`


### Tools

Play Videos
`javascript:(function()%7Bvar%20a=document.createElement(%22script%22);a.type=%22text/javascript%22;a.src=%22//github.com/zaius/youtube_playlist/raw/master/youtube_playlist.min.js%22;document.getElementsByTagName(%22head%22)[0].appendChild(a)%7D)();`

Show Passwords
`javascript:(function(){var%20s,F,j,f,i;%20s%20=%20"";%20F%20=%20document.forms;%20for(j=0;%20j%3CF.length;%20++j)%20{%20f%20=%20F[j];%20for%20(i=0;%20i%3Cf.length;%20++i)%20{%20if%20(f[i].type.toLowerCase()%20==%20"password")%20s%20+=%20f[i].value%20+%20"/n";%20}%20}%20if%20(s)%20alert("Passwords%20in%20forms%20on%20this%20page:/n/n"%20+%20s);%20else%20alert("There%20are%20no%20passwords%20in%20forms%20on%20this%20page.");})();`

Edit page
`javascript:document.body.contentEditable%20=%20'true';%20document.designMode%20=%20'on';%20void%200;`


### Services

Wayback Machine
`javascript:location.href='http://web.archive.org/web/*/'+document.location.href;`

BugMeNot
`javascript:location.href='http://bugmenot.com/view/'+location.hostname`

Open Google Maps location on OpenStreetMap
`javascript://a=location.href.match(/@(\-?[0-9\.]+),(\-?[0-9\.]+),([0-9\.]+)z/);location.replace("https://www.openstreetmap.org/#map="+a[3]+"/"+a[1]+"/"+a[2])`
