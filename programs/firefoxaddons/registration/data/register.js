titles = document.getElementsByName('title');
classes = document.getElementsByName('mainclass');
clear = document.getElementById('clear');
submit = document.getElementById('submit');
adds = document.getElementsByName('add');
usernamePrev = false;

//retrieve data from previous use
self.port.on('titles', function(data) {
	titlesPrev = data;
});
self.port.on('data', function(data) {
	mainClassesPrev = data;
});
self.port.on('data2', function(data) {
	subClassesPrev = data;
});
self.port.on('user', function(data) {
	usernamePrev = data;
});
self.port.on('pass', function(data) {
	passwordPrev = data;
});
self.port.on('drop', function(data) {
	dropClassesPrev = data;
	inputClasses();
});

//update class list to reflect current search
function inputClasses() {
	if (usernamePrev) {
		document.getElementById('user').value = usernamePrev;
		document.getElementById('pass').value = passwordPrev;
		document.getElementById('pass2').value = passwordPrev;
		document.getElementById('store').checked = true;
	}
	if (mainClassesPrev) {
		if (titlesPrev) {	
			for (var i = 0; i < titlesPrev.length; i++) {
				titles[i].value = titlesPrev[i];
			}
		}
		for (var i = 0; i < mainClassesPrev.length; i++) {
			classes[i].value = mainClassesPrev[i];
			var subClasses = subClassesPrev[mainClassesPrev[i]];
			var subBoxes = document.getElementsByName('mainclass' + (i + 1) + 'subclass1');
	//		alert(subClasses.length);
			for (var j = 0; j < subClasses.length; j++) {
				subBoxes[j].value = subClasses[j];
				if (j == 0) {
					var subClasses2 = subClassesPrev[subClasses[0]];
					var subBoxes2 = document.getElementsByName('mainclass' + (i + 1) + 'subclass2');
					for (var k = 0; k < subClasses2.length; k++) {
						subBoxes2[k].value = subClasses2[k];
					}
				}
			}
			var dropBoxes = document.getElementsByName('mainclass' + (i + 1) + 'drop');
			var dropClasses = dropClassesPrev[mainClassesPrev[i]];
			for (var j = 0; j < dropClasses.length; j++) {
				dropBoxes[j].value = dropClasses[j];
			}
		}
	}
}

//activate page functions
for (var i = 0; i < adds.length; i++) {
	adds[i].onclick = addClass;
}
submit.onclick = register;
clear.onclick = clearClasses;

function addClass() {
	var subClasses = document.getElementsByName(this.id);
	for (var i = 0; i < subClasses.length; i++) {
		if (subClasses[i].value == "") {
			if (i == 0) {
				var mainClassNum = this.id.substring(9, 10);
				var mainClass = classes[parseInt(mainClassNum) - 1];
				if (mainClass.value != "") {
					subClasses[i].value = parseInt(mainClass.value) + 1;
				}
			} else if (i < 18) {
				subClasses[i].value = parseInt(subClasses[i - 1].value) + 1;
			} else {
				alert("All classes are filled.");
			}
			break;
		}
	}
}

//actions taken when 'submit' is clicked
function register() {
	var titleNames = [];
	var slns = [];
	var subslns = [];
	var dropslns = [];
	for (var i = 0; i < titles.length; i++) {
		if (titles[i].value.length > 0) {
			titleNames.push(titles[i].value);
		}
	}
	for (var i = 0; i < classes.length; i++) {
		if (classes[i].value.length == 5) {
			slns.push(classes[i].value);
			var drop = document.getElementsByName('mainclass' + (i + 1) + 'drop');
			var dropStrings = [];
			for (var j = 0; j < drop.length; j++) {
				if (drop[j].value.length == 5) {
					dropStrings.push(drop[j].value);
				}
			}
			dropslns[classes[i].value] = dropStrings;
			var subclasses = document.getElementsByName('mainclass' + (i + 1) + 'subclass1');
			var subclassStrings = [];
			var subclasses2 = document.getElementsByName('mainclass' + (i + 1) + 'subclass2');
			var subclass2Strings = [];
			for (var j = 0; j < subclasses2.length; j++) {
				if (subclasses2[j].value.length == 5) {
					subclass2Strings.push(subclasses2[j].value);
				}
			}
			for (var j = 0; j < subclasses.length; j++) {
				if (subclasses[j].value.length == 5) {
					subclassStrings.push(subclasses[j].value);
					subslns[subclasses[j].value] = subclass2Strings;
				}
			}
			subslns[classes[i].value] = subclassStrings;
		}
	}
	var user = document.getElementById('user').value;
	var pass = document.getElementById('pass').value;
	var pass2 = document.getElementById('pass2').value;
	var store = document.getElementById('store').checked;
	if (pass != pass2) {
		document.getElementById('error').textContent = '';
		document.getElementById('error').textContent = 'The two UW Netid passwords do not match!'; 
	} else if (slns.length == 0) {
		document.getElementById('error').textContent = '';
		document.getElementById('error').textContent = 'There are no main classes!';
	} else if (store && user.length == 0) {
		document.getElementById('error').textContent = '';
		document.getElementById('error').textContent = 'Missing login information!';
	} else if (store && pass.length == 0) {
		document.getElementById('error').textContent = '';
		document.getElementById('error').textContent = 'Missing password!';
	} else {
		self.port.emit('title', titleNames);
		self.port.emit('user', user);
		self.port.emit('pass', pass);
		self.port.emit('store', store);
		self.port.emit('data', slns);
		self.port.emit('data2', subslns);
		self.port.emit('drop', dropslns);
	}
}

//clears the current search
function clearClasses() {
	document.getElementById('error').textContent = '';
	document.getElementById('error').innerHTML = 'This will remove all classes that were in search! Are you sure you want to continue?'; 
	document.getElementById('clear').onclick = function() {
		self.port.emit('clear', false);
		document.getElementById('error').innerHTML = '<span id=error2>Classes are no longer in search.</span>';
	}
}
