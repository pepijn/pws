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

	var pomp = function(ruimte, kracht) {
		ruimte.animate({scale: kracht + " " + kracht + " 85 60"}, 50, function() {
			ruimte.animate({scale: "1 1 85 60"}, 150);
		});
	}

	function hartslag() {
		ws.send("boezemsystole");
		pomp(onderdelen["Linkerboezem"], 0.80);
		pomp(onderdelen["Rechterboezem"], 0.80);

		setTimeout(function() {
		  ws.send("kamersystole");
			pomp(onderdelen["Linkerkamer"], 0.60);
			pomp(onderdelen["Rechterkamer"], 0.60);
		}, 100);

		setTimeout(function() {
			hartslag();
	  }, parseInt($("#hartslagfrequentie").val()));
	}
});