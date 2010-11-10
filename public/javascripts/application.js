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
		ws.send("boezemsystole");
		onderdelen["Linkerboezem"].scale(0.80);
		onderdelen["Rechterboezem"].scale(0.80);
		onderdelen["Linkerboezem"].animate({scale: 1}, 200);
		onderdelen["Rechterboezem"].animate({scale: 1}, 200);

		setTimeout(function() {
		  ws.send("kamersystole");
			onderdelen["Linkerkamer"].scale(0.60);
			onderdelen["Rechterkamer"].scale(0.60);
			onderdelen["Linkerkamer"].animate({scale: 1}, 200);
			onderdelen["Rechterkamer"].animate({scale: 1}, 150);
		}, 100);

		setTimeout(function() {
			hartslag();
	  }, parseInt($("#hartslagfrequentie").val()));
	}
});