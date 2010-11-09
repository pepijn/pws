$(function() {
  var ws = new WebSocket("ws://localhost:8080");
  ws.onmessage = function(evt) {
    $("#debug").html(evt.data);

		$.each(JSON.parse(evt.data), function(naam, data) {
			onderdeel = onderdelen[naam];
			if(onderdeel) {
				onderdeel.attr("fill-opacity", data.bloeddruk / 100);
			}
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
		onderdelen["Hart"].scale(0.95);

		setTimeout(function() {
		  ws.send("kamersystole")
 			onderdelen["Hart"].scale(0.9);
			onderdelen["Hart"].animate({scale: 1}, parseInt($("#hartslagfrequentie").val()) - 300);
		}, 100);

		setTimeout(function() {
			hartslag();
	  }, parseInt($("#hartslagfrequentie").val()));
	}
});