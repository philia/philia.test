// ==UserScript==
// @name       XiamiAutoCheckIner
// @namespace  http://use.i.E.your.homepage/
// @version    0.1
// @description  Auto check-in button clicker for Xiami music
// @match      http://www.xiami.com/*
// @copyright  2012+, You
// @require    http://libs.baidu.com/jquery/1.7.1/jquery.min.js
// ==/UserScript==


console.log("PD: jQuery = " + jQuery);
console.log("PD: $().jquery: " + $().jquery);

// This only fires the function assigned to the click event. It will not navigate to the path specified in the href attribute.
//$(document).ready($("#check_in").click());

function autocheckin() {
    var elem = $('b.icon.tosign');
    if (typeof elem.get(0) === "undefined") {
        console.log("PD: no action element found, waiting....");
        setTimeout(autocheckin, 2000);
        return;
    }
    elem = elem.get(0);
    elem.click();
    console.log("PD: Checked in");
}

$(document).ready(function() {
    // Auto Click on check in
	autocheckin();
});
