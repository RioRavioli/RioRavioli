
var contextMenu = require("context-menu");
var panel = require("panel");

exports.main = function(options, callbacks) {
	console.log(options.loadReason);

	var menuItem = contextMenu.Item({
		label: "What's this?",
		context: contextMenu.SelectionContext(),
		contentScript: 'self.on("click", function () {' +
							'   var text = window.getSelection().toString();' +
			 				'   self.postMessage(text);' +
			 				'});',
		onMessage: function (item) {
			console.log('looking up "' + item + '"');
			lookup(item);
		}
	});	
};

function lookup(item) {
	wikipanel = panel.Panel({
		width: 240,
		height: 320,
		contentURL: "http://en.wikipedia.org/w/index.php?title=" +
						item + "&useformat=mobile"		
	});
	wikipanel.show();
}
