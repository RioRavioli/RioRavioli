/* Things to add:
 * Check for correct user input in as much situations as possible.
 * Make prettier.
 * Add instructions.
 */
const CHECK_INTERVAL = 7000;
const tabs = require("tabs");
const contextMenu = require("context-menu");
const selfdata = require("self").data;
const notifications = require("notifications");
const pageWorkers = require("page-worker");
const pageMod = require("page-mod");
const ss = require("simple-storage");
const timers = require("timers");

var getStatus = "var elements = document.getElementsByTagName('tt');" +
					//checks if user is signed in
					 "if (elements.length == 0) {" +
					 "   var element = document.getElementsByTagName('title');" +
					 "   self.postMessage('sign in');" +
					 "} else {" +
					 "   if (elements[8].textContent < elements[9].textContent) {" +
					 "      self.postMessage('open');" +
					 "   } else {" +
					 "      self.postMessage('closed');" +
				    "   }" +	  
				  	 "}";

timerId = -1;
classIndex = -1;
addedClasses = [];
signIn = 0;

pageWorker = 0;
subWorker = 0;

//load data from previous use
store = ss.storage.store;
titles = ss.storage.titles;
mainClasses = ss.storage.mainClasses;
subClasses = ss.storage.subClasses;
dropClasses = ss.storage.dropClasses;		
username = ss.storage.username;
password = ss.storage.password;

if (mainClasses) {
	timerId = timers.setInterval(checkOpening, CHECK_INTERVAL, mainClasses);	
	if (username && password) {
		notifications.notify({
			title: "Waiting for class opening.",
			text: "click to view or edit",
			onClick: function() {
				tabs.open(selfdata.url("register.html"));
				retrieveClasses();
			}	
		});
	} else {
		notifications.notify({
			title: "No login info: make sure you are logged on to MyUW.",
			text: "click to view or edit classes",
			onClick: function() {
				tabs.open(selfdata.url("register.html"));
				retrieveClasses();
			}
		});
	}
} else {
	notifications.notify({
		title: "nothing",
		text: "asoenuthaosneuht",
		data: ""
	});
}

//creates reg option in the dropbox
contextMenu.Item({
	label: "UW class registeration",
	contentScript: "self.on('click', function (node, data) {" +
						"   self.postMessage('')" +
						"});", 
	onMessage: function() {
		tabs.open(selfdata.url("registrationoptions.html"));
		var chooseOption = pageMod.PageMod({
			include: selfdata.url("registrationoptions.html"),
			contentScript: "var search = document.getElementById('search');" +
								"search.onclick = function() {" +
								"   self.port.emit('search', 'search');" +
								"};",
			contentScrpitWhen: "end",
			onAttach: function onAttach(worker) {
				worker.port.on('search', function(data) {
					tabs.activeTab.url = selfdata.url("register.html"); 
					retrieveClasses();
				});
			}
		});
	}	
});


//sets functionality of the registration page
function retrieveClasses() {
	var submitClassesPage = pageMod.PageMod({
		include: selfdata.url("register.html"),
		contentScriptFile: selfdata.url("register.js"),

		contentScriptWhen: "end",
		onAttach: function onAttach(worker) {
			worker.port.emit('titles', titles);
			worker.port.emit('data', mainClasses);
			worker.port.emit('data2', subClasses);
			if (store) {
				worker.port.emit('user', username);
				worker.port.emit('pass', password);
			}
			worker.port.emit('drop', dropClasses);
			worker.port.on('clear', function(data) {
				store = false;
				titles = [];
				username = false;
				password = false;
				mainClasses = [];
				subClasses = [];
				dropClasses = [];
				classIndex = -1;
				updateStorage();
				if (timerId != -1) {
					timers.clearInterval(timerId);
					timerId = -1;
				}
			});
			worker.port.on('store', function(data) {
				store = data;
				ss.storage.store = data;
			});
			worker.port.on('title', function(data) {
				titles = data;
				ss.storage.titles = data;
			});
			worker.port.on('user', function(data) {
				username = data;
			});
			worker.port.on('pass', function(data) {
				password = data;
			});
			worker.port.on('data', function(data) {
				mainClasses = data;
			});
			worker.port.on('data2', function(data) {
				subClasses = data;
			});
			worker.port.on('drop', function(data) {
				dropClasses = data;
				if (timerId != -1) {
					timers.clearInterval(timerId);
				}
				if (store) {
					ss.storage.username = username;
					ss.storage.password = password;
				} else {
					ss.storage.username = false;
					ss.storage.password = false;
				}
				updateStorage();
				timerId = timers.setInterval(checkOpening, CHECK_INTERVAL, mainClasses);	
				tabs.activeTab.url = selfdata.url("registering.html"); 
				console.log(subClasses[mainClasses[0]][0]);
				console.log(ss.storage.subClasses[mainClasses[0]][0]);
				console.log(ss.storage.mainClasses[0]);
				submitClassesPage.destroy();
			});
		}
	});
}


console.log("The add-on is running.");

//Search for class opening
function checkOpening(classes) {
	if (signIn == 0) {
		signIn = "var user = document.getElementsByName('user')[0];" +
					"var pass = document.getElementsByName('pass')[0];" +
					"var submit = document.getElementsByName('submit')[0];" +
					"user.value = '" + username + "';" +
					"pass.value = '" + password + "';" +
					"self.postMessage('');" +
					"submit.click();";  
	}
	classIndex++;
	if (classIndex >= classes.length) {
		classIndex = 0;
	}
	if (pageWorker !== 0) {
		pageWorker.destroy();
	}
	if (subWorker !== 0) {
		subWorker.destroy();
	}

	pageWorker = pageWorkers.Page({
		contentURL: "https://sdb.admin.washington.edu/timeschd/uwnetid/sln.asp?QTRYR=AUT+2012&SLN=" + classes[classIndex],
		contentScript: getStatus,
		contentScriptWhen: "ready",
		onMessage: function(message) {
			if (message == 'sign in') {
				console.log(message + classes[classIndex]);
				subWorker = pageWorkers.Page({
					contentURL: "https://weblogin.washington.edu",
					contentScript: signIn,
					contentScriptWhen: "end"
				});	
			} else if (message == 'open') {
				console.log(message + classes[classIndex]);
				subWorker = 0;
				addedClasses.push(classes[classIndex]);
				timers.clearInterval(timerId);
				//if more subclasses need to be checked
				if (subClasses[classes[classIndex]] === undefined || subClasses[classes[classIndex]].length == 0) {
					submitClasses(addedClasses);
				} else {
					var tempIndex = classIndex;
					classIndex = -1;
					timerId = timers.setInterval(checkSubClasses, CHECK_INTERVAL, subClasses[classes[tempIndex]]);	
				}
			} else {
				console.log(message + classes[classIndex]);
				subWorker = 0;
			/*
				notifications.notify({
					title: classes[classIndex],
					text: "closed",
					data: ""
				});
				*/
			}
		}
	});	
}

//wrapper function to stop if all subclasses closed
function checkSubClasses(subClasses) {
	if (classIndex + 1 == subClasses.length) {
		addedClasses = [];
		timers.clearInterval(timerId);
		//continue search for main classes
		timerId = timers.setInterval(checkOpening, CHECK_INTERVAL, mainClasses);	
	} else {
		checkOpening(subClasses);
	}	
}

//submits the open class
function submitClasses(openClasses) {
	var drop = dropClasses[openClasses[0]];
	var classesString = createString(openClasses);
	if (drop.length == 0) {
		var dropString = "[]";
	} else {
		var dropString = createString(drop);
	}
	var register = "var classes = " + classesString + ";" +
						"var drop = " + dropString + ";" +
						"var regBoxes = [];" +					 
						"var inputs = document.getElementsByTagName('input');" +
						"var tds = document.getElementsByTagName('td');" +
						"for (var i = 0; i < tds.length; i++) {" +
						"   for (var j = 0; j < drop.length; j++) {" +
						"      if (tds[i].textContent == drop[j]) {" +
						"         tds[i - 1].childNodes[0].checked = true;" +
						"      }" +
						"   }" +
						"}" +
						"for (var i = 0; i < inputs.length; i++) {" +
						"   if (inputs[i].name.substring(0, 3) == 'sln' && inputs[i].type == 'text') {" +
						"      regBoxes.push(inputs[i]);" +
						"   } else if (inputs[i].value == ' Update Schedule ') {" +
						"      var update = inputs[i];" +
						"      break;" +
						"   }" +
						"}" +
						"for (var i = 0; i < classes.length; i++) {" +
						"   regBoxes[i].value = classes[i];" +
						"}" +
						"update.click();" +
						"self.postMessage('destroy');"; 

	tabs.open("https://sdb.admin.washington.edu/students/uwnetid/register.asp");
	var submitClassesPage = pageMod.PageMod({
		include: "https://sdb.admin.washington.edu/students/uwnetid/register.asp",
		contentScript: register,
		contentScriptWhen: "end",
		onAttach: function onAttach(worker) {
			worker.on('message', function(data) {
				submitClassesPage.destroy();	
			});
		}
	});

	//removes the open class from search
	var otherClasses = [];
	for (var i = 0; i < mainClasses.length; i++) {
		if (mainClasses[i] != openClasses[0]) {
			otherClasses.push(mainClasses[i]);
		}
	}
	updateStorage();
	if (otherClasses.length == 0) {
		worker.destroy();
	} else {
		timers.clearInterval(timerId);
		addedClasses = [];
		timerId = timers.setInterval(checkOpening, CHECK_INTERVAL, otherClasses);	
	}
}

//creates a string version of an array
function createString(classes) {
	var classesString = "[" + classes[0]; 
	for (var i = 1; i < classes.length; i++) {
		classesString = classesString + ", " + classes[i]; 
	}
	classesString += "]";
	return classesString;
}

//updates strage -_-
function updateStorage() {
	ss.storage.mainClasses = mainClasses;
	ss.storage.subClasses = subClasses;
	ss.storage.dropClasses = dropClasses;
}
