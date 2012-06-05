var socket = io.connect();

document.addEventListener('DOMContentLoaded', function(e) {
  var input = document.getElementById('text');
	input.onkeyup = function(e) {
		if (13 === e.keyCode) {
			socket.emit('text', input.value);
			input.value = '';
		}
	};
});
