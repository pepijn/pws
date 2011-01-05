var appData = {"Rechterkamer":{"bloed":{"oxihemoglobinen":20,"druk":4}},"Longslagader":{"bloed":{"oxihemoglobinen":500,"druk":123}},"Longen":{"bloed":{"oxihemoglobinen":0,"druk":74}},"Longader":{"bloed":{"oxihemoglobinen":0,"druk":38}},"Kransader":{"bloed":{"oxihemoglobinen":200,"druk":40}},"Hart":{"bloed":{"oxihemoglobinen":245,"druk":78}},"Kransslagader":{"bloed":{"oxihemoglobinen":0,"druk":114}},"Linkerboezem":{"bloed":{"oxihemoglobinen":0,"druk":7}},"Aorta":{"bloed":{"oxihemoglobinen":0,"druk":161}},"Linkerkamer":{"bloed":{"oxihemoglobinen":0,"druk":4}},"Holle ader":{"bloed":{"oxihemoglobinen":0,"druk":0}},"Rechterboezem":{"bloed":{"oxihemoglobinen":35,"druk":7}}};

$(function() {
  var ws = new WebSocket("ws://localhost:8080");

	var serie;
  ws.onmessage = function(evt) {
    appData = JSON.parse(evt.data);
    $("#debug").html(JSON.stringify(appData));

		serie = 0;

  };

  ws.onclose = function() { $("#debug").html("Verbinding gesloten") };
  ws.onopen = function() {
		hartslag();
  };

  setInterval(function() {
    ws.send("vernieuw");
  }, 50);

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