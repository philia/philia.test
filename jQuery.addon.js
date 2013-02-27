// ==UserScript==
// @name         jQuery addon
// @namespace    http://philia.test.com/
// @version      0.1
// @description  add jQuery functions to current page
// @include      *
// @copyright    2011+, Philia
// ==/UserScript==

//  SIMPLEST way
/*
// @require      https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js
*/

//  Simple way
/*
var script = document.createElement("script");
script.type = "text/javascript";
script.src = "https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js";
document.head.appendChild(script);
*/

//  Hard way
/*
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
    console.log("jQuery addon is taking effect!");

     // This function is used to call different functions by location.href
     // route("www.google.com", function() {
     //     process here
     // });

    function route(match, fn) {
        if (window.location.href.indexOf(match) != -1) {
            fn();
        }
    }
});
*/

/*
//  Ajax call

var name_src = "a,b,c,d";
var a_names = name_src.split(",");
for (var i = 0; i < a_names.length; i++) {
    var a_url = "http://hostname/pagename.php?param=" + a_names[i];
    $.ajax({
        url: a_url,
        type: 'GET',
    }).done(function(data) {
        console.log(this.url + ":" + data);
    });
}
*/

GM_log("PD: $().jquery = " + $().jquery);
