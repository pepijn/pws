$(function() {
  var ws = new WebSocket("ws://localhost:8080");
  ws.onmessage = function(evt) {
    $("#debug").html(evt.data);

		$.each(JSON.parse(evt.data), function(naam, data) {
			$(onderdeel).attr("opacity", data.bloeddruk / 100);
		});
  };

  ws.onclose = function() { $("#debug").html("Verbinding gesloten") };
  ws.onopen = function() {
		hartslag();
  };

  setInterval(function() {
    ws.send("vernieuw");
  }, 20);

	function hartslag() {
		ws.send("boezemsystole")

		setTimeout(function() {
		  ws.send("kamersystole")
		}, 100);

		setTimeout(function() {
			hartslag();
	  }, parseInt($("#hartslagfrequentie").val()));
	}
});