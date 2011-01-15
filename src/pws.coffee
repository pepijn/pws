DIFFUSIVITEIT = 0.1
STANDAARD_MAXIMAAL_VOLUME = 500 # halve liter, kunstmatig

HART_ONTSPANNING_SNELHEID = 0.5
HARTKAMER_VOLUME = 80 # mL
HARTBOEZEM_VOLUME = 27 # mL, 1/3 van hartkamer

class Onderdeel
  constructor: ->
    @bloeddruk = 0
    @volume = STANDAARD_MAXIMAAL_VOLUME

  vrij_volume: ->
    @volume - @bloeddruk

  vernieuw: ->
    @diffundeer_bloed()

  diffundeer_bloed: ->
    drukdelta = @bloeddruk - @opvolger.bloeddruk

    if drukdelta > 0
      hoeveelheid = Math.ceil(drukdelta * DIFFUSIVITEIT)
      @verplaats_bloed hoeveelheid

    return this

  verplaats_bloed: (hoeveelheid) ->
    hoeveelheid = @volume if hoeveelheid > @volume

    if hoeveelheid <= @opvolger.vrij_volume()
      @bloeddruk -= hoeveelheid
      @opvolger.bloeddruk += hoeveelheid

class Hartruimte extends Onderdeel
  vernieuw: ->
    @systole if @volume != HARTKAMER_VOLUME

    @diffundeer_bloed()

  systole: ->
    @systole = true


class Hartboezem extends Hartruimte
  constructor: ->
    super
    @volume = HARTBOEZEM_VOLUME

class Hartkamer extends Hartruimte
  constructor: ->
    super
    @volume = HARTKAMER_VOLUME


class Bloedvat extends Onderdeel
  #constructor: ->

class Ader extends Bloedvat
  constructor: ->
    super
