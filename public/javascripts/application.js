var Onderdeel = Backbone.Model.extend({
	initialize: function () {
		paden[this.get('naam')].attr({ opacity: (this.get('bloeddruk')/2) / 10 });
	}
});

var Orgaansysteem = Backbone.Collection.extend({
  model: Onderdeel,
	url: '/orgaansysteem'
});

var onderdelen = new Orgaansysteem;

setInterval(function() {
	$.get('/systole');
}, 3000);

setInterval(function() {
	onderdelen.fetch();
}, 200);