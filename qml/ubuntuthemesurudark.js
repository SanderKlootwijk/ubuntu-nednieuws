(function() {
var css = "* {\nfont-family: \"Ubuntu\" !important;} \n\n\n 	nav {\ndisplay: none !important;}  \n\n\n 	footer {\ndisplay: none !important;}  \n\n\n .hIVSHa {\ndisplay: none !important;}  \n\n\n .container_1UEFCPoS {\ndisplay: none !important;}  \n\n\n button[class^='notificationButton'] {\ndisplay: none !important;} \n\n\n #ccm_col_content_regular {\ndisplay: none !important;} \n\n\n 	body {\nbackground: #111 !important;\ncolor: #fff !important;}  \n\n\n 	h1 {\ncolor: #fff !important;}  \n\n\n 	h2 {\ncolor: #fff !important;}  \n\n\n 	h3 {\ncolor: #fff !important;}  \n\n\n li {\ncolor: #fff !important;} \n\n\n 	p {\ncolor: #fff !important;} \n\n\n .liveblog__last__content {\ncolor: #fff !important;} \n\n\n div[class^='authorName'] {\ncolor: #fff !important;}  \n\n\n div[class^='title'] {\ncolor: #fff !important;}  \n\n\n p[class^='text'] {\ncolor: #fff !important;}  \n\n\n time[class^='footer'] {\ncolor: #fff !important;}  \n\n\n 	aside {\nbackground-color: #111 !important;}  \n\n\n 	.section-sub {\nbackground: #111 !important;}  \n\n\n 	.container {\nbackground: #111 !important;}  \n\n\n 	span {\ncolor: #fff !important;}  \n\n\n .ext-twitter-caption {\ncolor: #fff !important;}  \n\n\n .ext-twitter-header-author__decorate-name {\ncolor: #fff !important;}  \n\n\n .ext-twitter-date {\ncolor: #fff !important;}  \n\n\n #ccm_notification {\ndisplay: none !important;} \n\n\n section[class^='sterBanner'] {\ndisplay: none !important;} \n\n\n #sterad-container {\ndisplay: none !important;} \n\n\n .jIWxco {\ndisplay: none !important;}  \n\n\n\n\n\n"


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
