(function() {
var css = "* {\nfont-family: \"Ubuntu\" !important;} \n\n\n @media all and (min-width: 760) { div[class^='content'] {\nfont-size: 16px !important;} } \n\n\n nav {\ndisplay: none !important;}  \n\n\n 	footer {\ndisplay: none !important;}  \n\n\n .container_1UEFCPoS {\ndisplay: none !important;}  \n\n\n button[class^='notificationButton'] {\ndisplay: none !important;} \n\n\n #ccm_col_content_regular {\ndisplay: none !important;} \n\n\n #ccm_notification {\ndisplay: none !important;} \n\n\n section[class^='sterBanner'] {\ndisplay: none !important;} \n\n\n \n\n\n\n\n\n"


;


if (typeof GM_addStyle != "undefined") {
    GM_addStyle(css);
} else if (typeof PRO_addStyle != "undefined") {
    PRO_addStyle(css);
} else if (typeof addStyle != "undefined") {
    addStyle(css);
} else {
    var node = document.createElement("style");
    node.type = "text/css";
    node.appendChild(document.createTextNode(css));
    var heads = document.getElementsByTagName("head");
    if (heads.length > 0) {
        heads[0].appendChild(node);
    } else {
        // no head yet, stick it whereever
        document.documentElement.appendChild(node);
    }
}
})();
