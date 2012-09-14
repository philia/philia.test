// ==UserScript==
// @name       XiamiAutoCheckIner
// @namespace  http://use.i.E.your.homepage/
// @version    0.1
// @description  Auto check-in button clicker for Xiami music
// @match      http://www.xiami.com/
// @copyright  2012+, You
// @require    https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js
// ==/UserScript==


GM_log("PD: jQuery = " + jQuery);
GM_log("PD: $().jquery: " + $().jquery);

// This only fires the function assigned to the click event. It will not navigate to the path specified in the href attribute.
//$(document).ready($("#check_in").click());

$(document).ready(function() {
    // Auto Click on check in
    var elem = document.getElementById("check_in");
    GM_log("PD: elem = " + elem);
    if (document.dispatchEvent) {
        // W3C
        var oEvent = document.createEvent("MouseEvents");
        oEvent.initMouseEvent("click", true, true, window, 1, 1, 1, 1, 1, false, false, false, false, 0, elem);
        elem.dispatchEvent(oEvent);
    } else if (document.fireEvent) {
        // IE
        elem.click();
    }
});