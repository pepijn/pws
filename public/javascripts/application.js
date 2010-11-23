$(function() {
	var bloeddruk_chart, oxihemoglobinen_chart;

	chart = new Highcharts.Chart({
	        chart: {
	            renderTo: 'chart',
	            type: 'spline',
							animation: false,
							reflow: false
	        },
	        title: {
	            text: 'Live random data'
	        },
	        xAxis: {
	            type: 'datetime',
	            tickPixelInterval: 150,
	            maxZoom: 20 * 1000
	        },
	        yAxis: {
	            minPadding: 0.2,
	            maxPadding: 0.2,
	            title: {
	                text: 'Value',
	                margin: 80
	            },
							min: 0,
							max: 200
	        },
	        series: [{
	            name: 'Hart',
	            data: []
	        }, {
							name: 'Onderdeel',
							data:[]
					}		, {
									name: 'Onderdeel',
									data:[]
							}		, {
											name: 'Onderdeel',
											data:[]
									}		, {
													name: 'Onderdeel',
													data:[]
											}		, {
															name: 'Onderdeel',
															data:[]
													}		, {
																	name: 'Onderdeel',
																	data:[]
															}		, {
																			name: 'Onderdeel',
																			data:[]
																	}		, {
																					name: 'Onderdeel',
																					data:[]
																			}		, {
																							name: 'Onderdeel',
																							data:[]
																					}		, {
																									name: 'Onderdeel',
																									data:[]
																							}
					]
	    });

  var ws = new WebSocket("ws://localhost:8080");

	var serie;
  ws.onmessage = function(evt) {
    $("#debug").html(evt.data);

		serie = 0;

		$.each(JSON.parse(evt.data), function(naam, data) {
			// add the point
	    chart.series[serie].addPoint(data.bloed.druk, true, chart.series[0].data.length > 20);

			serie++;

			if(serie > 5)
				break;
		});
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