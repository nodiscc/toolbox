// JavaScript Document

	function noSpam(user,domain) {
	locationstring = "mailto:" + user + "@" + domain;
	window.location = locationstring;
	}
	
// HTML Usage:
// <script src="js/nospam.js" type="text/javascript" language="Javascript"></script>
// 2008 Alexis Reymond | Référencement <a href="javascript:noSpam('contact','toltek.fr')">toltek</a>
