// ==UserScript==
// @name       12306 Ticket Assistant
// @namespace  philia.test.com
// @version    0.1
// @description  Assistant helps order ticket from 12306, analyzed and duplicated from https://github.com/zzdhidden/12306/raw/master/
// @include    *://dynamic.12306.cn/*
// @require    https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js
// @copyright  2011+, Philia
// ==/UserScript==

//debugger;
//  Do not run on frames or iframes
//if (window.top != window.self) return;
//alert("12306 Ticket Assistant working....");

function withjQuery(callback, safe) {
    //  typeof operator: evaluates to "number"/"string"/"boolean"/"object"/null/"undefined" if operand is a number/string/Boolean/object/null/not defined.
    if (typeof(jQuery) == "undefined") {
        var script = document.createElement("script");
        script.type = "text/javascript";
        script.src = "https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js";
        
        if (safe) {
            var cb = document.createElement("script");
            cb.type = "text/javascript";
            cb.textContent = "jQuery.noConflict();(" + callback.toString() + ")(jQuery);";
            script.addEventListener('load', function() {
                document.head.appendChild(cb);
            });
        } else {
            //  $ is a shorthand for jQuery namespace and used to reference the global jQuery object
            var dollar = undefined;
            if (typeof($) != "undefined") dollar = $;
            script.addEventListener('load', function() {
                jQuery.noConflict();  //  relinquish jQuery's control of the $variable
                $ = dollar;
                callback(jQuery);
            });
        }
        document.head.appendChild(script);
    } else {
        callback(jQuery);
    }
}

withjQuery(function($) {
    $(document).click(function() {
        if (window.webkitNotifications && window.webkitNotifications.checkPermission() != 0) {
            window.webkitNotifications.requestPermission();
        }
    });
    function notify(str, timeout, skipAlert) {
        if (window.webkitNotifications && window.webkitNotifications.checkPermission() != 0) {
            var notification = webkitNotifications.createNotification("http://www.12306.cn/mormhweb/images/favicon.ico", '12306 Ticket Assistant', str);
            notification.show();
            if (timeout) {
                setTimeout(function() {
                    notification.cancel();
                }, timeout);
            }
            return true;
        } else {
            if (!skipAlert) {
                alert(str);
            }
            return false;
        }
    }
    function route(match, fn) {
        if (window.location.href.indexOf(match) != -1) {
            fn();
        };
    }
    
    route("loginAction.do?method=init", function() {
        console.log("routing loginAction.do....");
        if (!window.location.href.match(/init$/i)) return;
        //  login
        var url = "https://dynamic.12306.cn/otsweb/loginAction.do?method=login";
        //  'Order ticket' link
        var queryurl = "https://dynamic.12306.cn/otsweb/order/querySingleAction.do?method=init";
        //  Check if user has already login, redirect to query url
        if (parent && parnt.$) {
            //  This is 'Register' link right above, it means user has not successfully logined if exists
            var str = parent.$("#username_ a").attr("href");
            if (str && str.indexOf("sysuser/user_info") != -1) {
                //  Login successed, go to 'Order ticket'
                console.log("Login success, go to tickert ordering...");
                window.location.href = queryurl;
                return;
            }
        }
        
        var count = 1;
        //  init
        console.log("Initialize....");
        console.log("$(\"#subLink\").html()=" + $("#subLink").html());
        $("#subLink").after($("<a href='#' />").attr("id", "refreshButton").html("AutoFire").click(function() {
            count = 1;
            $(this).html("Trying for the first time...");
            submitForm();
            return false;
        }));
        console.log("$(\"#refreshButton\").html()=" + $("#refreshButton").html());
        
        function submitForm() {
            var submitUrl = url;
            $.ajax({
                type: "POST",
                url: submitUrl,
                data: {
                    "loginUser.user_name": $("#UserName").val(), "user.password": $("#password").val(), "randCode": $("#randCode").val()
                },
                timeout: 30000,
                success: function(msg) {
                    if (msg.indexOf('请输入正确的验证码') != -1) {
                        alert("Captcha needed!");
                    } else if (msg.indexOf('当前访问用户过多') != -1 || msg.match(/var\s+isLogin\s*=\s*false/i)) {
                        reLogin();
                    } else {
                        notify('Login Success!');
                        window.location.replace(queryurl);
                    };
                }
            });
        }
        
        function reLogin() {
            count++;
            $('#refreshButton').html("(Trying " + count + " times...)");
            setTimeout(submitForm, 2000);
        }
    });
        
}, true);
