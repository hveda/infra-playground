exports.install = function() {
	ROUTE('GET /', trivia);
};

function trivia() {
	var self = this;
	// self.proxy('http://trivia.backend:3030');
	self.proxy('http://localhost:3030');
}
