$(function() {
	// Creates canvas 640 × 480 at 10, 50
	var r = Raphael(10, 50, 640, 480);
	// Creates pie chart at with center at 320, 200,
	// radius 100 and data: [55, 20, 13, 32, 5, 1, 2]

	var bloeddruk_chart, oxihemoglobinen_chart;

  var ws = new WebSocket("ws://localhost:8080");
  ws.onmessage = function(evt) {
    $("#debug").html(evt.data);

		var legend = [];
		var bloeddruk = [];
		var oxihemoglobinen = [];

		$.each(JSON.parse(evt.data), function(naam, data) {
			legend.push(naam);
			bloeddruk.push(data.bloed.druk);
			oxihemoglobinen.push(data.bloed.oxihemoglobinen > 0 ?  data.bloed.oxihemoglobinen : 40);
		});

		r.clear();
		bloeddruk_chart = r.g.piechart(300, 300, 150, bloeddruk, { legend: legend });
		// oxihemoglobinen_chart = r.g.piechart(400, 240, 100, oxihemoglobinen, { legend: legend });
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
		ws.send("boezemsystole");		//
				// pomp(onderdelen["Linkerboezem"], 0.80);
				// pomp(onderdelen["Rechterboezem"], 0.80);

		setTimeout(function() {
		  ws.send("kamersystole");			//
		  			// pomp(onderdelen["Linkerkamer"], 0.60);
		  			// pomp(onderdelen["Rechterkamer"], 0.60);
		}, 100);

		setTimeout(function() {
			hartslag();
	  }, parseInt($("#hartslagfrequentie").val()));
	}
});