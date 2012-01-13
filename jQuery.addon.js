// ==UserScript==
// @name         jQuery addon
// @namespace    http://philia.test.com/
// @version      0.1
// @description  add jQuery functions to current page
// @include      *
// @require      https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js
// @copyright    2011+, Philia
// ==/UserScript==

function withjQuery(callback) {
    if (typeof(jQuery) == "undefined") {
        var script = document.createElement("script");
        script.type = "text/javascript";
        script.src = "https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js";
        var cb = document.createElement("script");
        cb.type = "text/javascript";
        cb.textContent = "jQuery.noConflict();(" + callback.toString() + ")(jQuery);";
        script.addEventListener('load', function() {
            document.head.appendChild(cb);
        });
        document.head.appendChild(script);
    } else {
        callback(jQuery);
    }
}

withjQuery(function($) {
    console.log("jQuery addon taking effect!");

    /*
     * This function is used to call different functions by location.href
     * route("www.google.com", function() {
     *     // process
     * });
     */
    function route(match, fn) {
        if (window.location.href.indexOf(match) != -1) {
            fn();
        }
    }
});
