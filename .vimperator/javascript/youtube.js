
var url = window.getBrowser().webNavigation.document.location.href 
var isYoutube = url.substr(11, 7) == 'youtube';
if (isYoutube) {
	if (url.substr(11, 15) == 'youtuberepeater') {
		var newurl = url.substr(0,11) + 'youtube' + url.substr(26);
	} else {
		var newurl = url.substr(0, 11) + 'youtuberepeater' + url.substr(18);
	}
	window.getBrowser().webNavigation.document.location.href = newurl; 
}


