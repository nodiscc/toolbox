// JavaScript Document
// ==UserScript==
// @name            Repeat Youtube
// @author          Anh Dũng Bùi
// @source          https://greasyfork.org/en/scripts/6485-repeat-youtube
// @description     Script for repeating youtube
// @include         https://youtube.com/*
// @include         https://www.youtube.com/*
// @version 0.1
// @namespace griever.youtuberepeat
// ==/UserScript==
// ==Griever==
// ==============
// ==Icon==

document.querySelector('video').addEventListener('ended', function(){this.play()});
