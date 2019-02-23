// ==UserScript==
// @name        Reddit Disable Subreddit Styles
// @namespace   rP2Kg8TreB8y
// @description Disables all subreddit CSS styling
// @match       http://*.reddit.com/*
// @match       https://*.reddit.com/*
// @author      xHN35RQ
// @source      https://gist.github.com/xHN35RQ/ee0bfd82f92d3cdf75a4
// @version     1.0
// @grant       none
// ==/UserScript==

// lifted from RES: https://github.com/honestbleeps/Reddit-Enhancement-Suite.git
var head = document.getElementsByTagName("head")[0];
var subredditStyleSheet = head.querySelector('link[title=applied_subreddit_stylesheet]');
  if (!subredditStyleSheet) subredditStyleSheet = head.querySelector('style[title=applied_subreddit_stylesheet]');
  if (!subredditStyleSheet) subredditStyleSheet = head.querySelector('style[data-apng-original-href]'); // apng extension fix (see #1076)
  if (subredditStyleSheet) {
    subredditStyleSheet.parentNode.removeChild(subredditStyleSheet);
}
