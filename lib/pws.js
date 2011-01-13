(function() {
  var Ader, Bloedvat, DIFFUSIVITEIT, HARTBOEZEM_VOLUME, HARTKAMER_VOLUME, HART_ONTSPANNING_SNELHEID, Hartboezem, Hartkamer, Hartruimte, Onderdeel, STANDAARD_MAXIMAAL_VOLUME, loop_organs, make_table_row, onderdeel;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  DIFFUSIVITEIT = 0.1;
  STANDAARD_MAXIMAAL_VOLUME = 500;
  HART_ONTSPANNING_SNELHEID = 0.5;
  HARTKAMER_VOLUME = 80;
  HARTBOEZEM_VOLUME = 27;
  Onderdeel = (function() {
    function Onderdeel() {
      this.bloeddruk = 0;
      this.volume = STANDAARD_MAXIMAAL_VOLUME;
    }
    Onderdeel.prototype.vernieuw = function() {
      var drukdelta, hoeveelheid;
      drukdelta = this.bloeddruk - this.opvolger.bloeddruk;
      if (drukdelta > 0) {
        hoeveelheid = Math.ceil(drukdelta * DIFFUSIVITEIT);
        this.verplaats_bloed(hoeveelheid);
      }
      return this;
    };
    Onderdeel.prototype.verplaats_bloed = function(hoeveelheid) {
      if (hoeveelheid > this.volume) {
        hoeveelheid = this.volume;
      }
      if (hoeveelheid <= this.opvolger.volume) {
        this.bloeddruk -= hoeveelheid;
        return this.opvolger.bloeddruk += hoeveelheid;
      }
    };
    return Onderdeel;
  })();
  Hartruimte = (function() {
    function Hartruimte() {
      Hartruimte.__super__.constructor.apply(this, arguments);
    }
    __extends(Hartruimte, Onderdeel);
    Hartruimte.prototype.systole = function() {
      return this.systole = true;
    };
    return Hartruimte;
  })();
  Hartboezem = (function() {
    __extends(Hartboezem, Hartruimte);
    function Hartboezem() {
      Hartboezem.__super__.constructor.apply(this, arguments);
      this.volume = HARTBOEZEM_VOLUME;
    }
    return Hartboezem;
  })();
  Hartkamer = (function() {
    __extends(Hartkamer, Hartruimte);
    function Hartkamer() {
      Hartkamer.__super__.constructor.apply(this, arguments);
      this.volume = HARTKAMER_VOLUME;
    }
    return Hartkamer;
  })();
  Bloedvat = (function() {
    function Bloedvat() {
      Bloedvat.__super__.constructor.apply(this, arguments);
    }
    __extends(Bloedvat, Onderdeel);
    return Bloedvat;
  })();
  Ader = (function() {
    __extends(Ader, Bloedvat);
    function Ader() {
      Ader.__super__.constructor.apply(this, arguments);
    }
    return Ader;
  })();
  window.onderdelen = {
    Linkerboezem: new Hartboezem,
    Linkerkamer: new Hartkamer,
    Aorta: new Onderdeel,
    Kransslagader: new Onderdeel,
    Hart: new Onderdeel,
    Kransader: new Ader,
    Rechterboezem: new Hartboezem,
    Rechterkamer: new Hartkamer,
    Longslagader: new Onderdeel,
    Longen: new Onderdeel,
    Longader: new Ader
  };
  onderdelen.Linkerboezem.opvolger = onderdelen.Linkerkamer;
  onderdelen.Linkerkamer.opvolger = onderdelen.Aorta;
  onderdelen.Aorta.opvolger = onderdelen.Kransslagader;
  onderdelen.Kransslagader.opvolger = onderdelen.Hart;
  onderdelen.Hart.opvolger = onderdelen.Kransader;
  onderdelen.Kransader.opvolger = onderdelen.Hart;
  onderdelen.Kransader.opvolger = onderdelen.Rechterboezem;
  onderdelen.Rechterboezem.opvolger = onderdelen.Rechterkamer;
  onderdelen.Rechterkamer.opvolger = onderdelen.Longslagader;
  onderdelen.Longslagader.opvolger = onderdelen.Longen;
  onderdelen.Longen.opvolger = onderdelen.Longader;
  onderdelen.Longader.opvolger = onderdelen.Linkerboezem;
  onderdelen.Aorta.bloeddruk = 350;
  make_table_row = function(onderdeel) {
    return $('#onderdelen tbody').append('\
    <tr id="' + onderdeel + '">\
      <td class="naam">' + onderdeel + '</td>\
      <td class="volume"></td>\
      <td><div class="bloeddruk"></div></td>\
    </tr>');
  };
  for (onderdeel in onderdelen) {
    make_table_row(onderdeel);
  }
  loop_organs = function(onderdelen) {
    var data, naam, onderdeel, tr, _results;
    _results = [];
    for (naam in onderdelen) {
      onderdeel = onderdelen[naam];
      data = onderdeel.vernieuw();
      tr = $('#' + naam);
      tr.find('.volume').text(data.volume);
      _results.push(tr.find('.bloeddruk').css('width', data.bloeddruk * 5));
    }
    return _results;
  };
  window.systole = function() {
    var onderdeel, _i, _len, _ref;
    _ref = [onderdelen.Linkerboezem, onderdelen.Rechterboezem];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      onderdeel = _ref[_i];
      onderdeel.verplaats_bloed(onderdeel.bloeddruk);
    }
    return setTimeout((function() {
      var onderdeel, _i, _len, _ref, _results;
      _ref = [onderdelen.Linkerkamer, onderdelen.Rechterkamer];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        onderdeel = _ref[_i];
        _results.push(onderdeel.verplaats_bloed(onderdeel.bloeddruk));
      }
      return _results;
    }), 100);
  };
  window.refreshLoop = setInterval(loop_organs, 20, onderdelen);
  window.systoleLoop = setInterval(systole, 800);
}).call(this);
