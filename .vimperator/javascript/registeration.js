
var doc = window.getBrowser().webNavigation.document;
var url = window.getBrowser().webNavigation.document.location.href 

var classes = [12333, 12334, 12336, 12337];
var drop = [10199];
var inputs = doc.getElementsByTagName("input");
var tds = doc.getElementsByTagName("td");
for (var i = 0; i < tds.length; i++) {
	for (var j = 0; j < drop.length; j++) {
		if (tds[i].textContent == drop[j]) {
			tds[i - 1].childNodes[0].checked = true;
		}
	}		
}
//alert(inputs[5].name);

	var regBoxes = [];
	for (var i = 0; i < inputs.length; i++) {
		if (inputs[i].name.substring(0, 3) == "sln" && inputs[i].type == "text") {
			regBoxes.push(inputs[i]);
			alert(inputs[i].name);
		} else if (inputs[i].value == " Update Schedule ") {
			var update = inputs[i];
		}
	}
	for (var i = 0; i < classes.length; i++) {
		regBoxes[i].value = "" + classes[i];
	}
	alert(update.value);
	//update.click();


