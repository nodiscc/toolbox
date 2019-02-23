// ==UserScript==
// @name        Torrentz2 Magnet
// @namespace   tzeumg
// @description Add magnet link to torrentz2
// @include     /^https:\/\/torrentz2\.eu\/[a-f0-9]{40}$/
// @include     https://torrentz2.eu/verified*
// @include     https://torrentz2.eu/search*
// @include     https://torrentz2.eu/my
// @include     /^https:\/\/torrentz2\.me\/[a-f0-9]{40}$/
// @include     https://torrentz2.me/verified*
// @include     https://torrentz2.me/search*
// @include     https://torrentz2.me/my
// @version     1.5
// @grant       none
// ==/UserScript==

var magneticon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAZdEVYdFNvZnR3YXJlAHBhaW50Lm5ldCA0LjAuMTJDBGvsAAAAdklEQVQ4T82QQQ7AIAgEPfpP/81X7C4KpQYuTZrUZIxhGaI2rJmBxQ3HPAdtisgD1qKY5WXwrYh90bsWxxgu8qw9yIxSNMnQ2s/EVXjxxs0OnCi5qNMZVhwS0Vv4VSoOib3qxHekA4JgEh0k9++xGIfEZhMWs10JUpWYwegBlwAAAABJRU5ErkJggg==';

if (document.URL.indexOf("/search?f=") > 0 || document.URL.indexOf("/verified?f=") > 0 || document.URL.indexOf("/verifiedN?f=") > 0 || document.URL.substr(document.URL.length-7) === "/search" || document.URL.substr(document.URL.length-3) === "/my") {
    var dtlist = document.querySelectorAll('.results > dl> dt');
    for (var i = 0; i < dtlist.length; i++) {
        var linkel = dtlist[i].firstChild;
        var hash = linkel.href.substr(linkel.href.length - 40);
        var dn = linkel.innerHTML;
        var magneturi = "magnet:?xt=urn:btih:" + hash + "&dn=" + dn;
        var magnetspan = document.createElement("span");
        magnetspan.innerHTML = "<a href='" + magneturi + "'><img src='"+magneticon+"'></a> ";
        dtlist[i].insertBefore(magnetspan, dtlist[i].firstChild);
    }
} else {
    var el1 = document.querySelector('.trackers > h2:nth-child(1)');
    var hash = el1.childNodes[1].nodeValue.substr(6);
    var dn = document.querySelector('.t').childNodes[0].nodeValue.trim();
    var tr = '';

    var trackers = document.querySelectorAll('.trackers > dl > dt');

    for (var i = 0; i < trackers.length; i++) {
        tr += "&tr=" + trackers[i].innerHTML;
    }

    var magneturi = "magnet:?xt=urn:btih:" + hash + "&dn=" + dn + tr;

    el1.innerHTML = "<span style='padding-right: 190px;'>Torrent Trackers</span><a href='" + magneturi + "'><img src='"+magneticon+"'> " + hash + "</a>";
}