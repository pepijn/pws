DIFFUSIVITEIT = 0.5

HART_CONTRACTIE_SNELHEID = 0.9
HART_ONTSPANNING_SNELHEID = 0.5
HARTKAMER_VOLUME = 800 # mL * 10
HARTBOEZEM_VOLUME = 270 # mL * 10, 1/3 van hartkamer

class Onderdeel
  constructor: (kleppen) ->
    @bloedvolume = 0
    @kleppen = kleppen ? false

  vernieuw: ->
    @diffundeer_bloed()

  # Drukverschil met opvolger
  drukverschil: ->
    @bloedvolume - @opvolger.bloedvolume

  verplaats_bloed: (hoeveelheid) ->
    hoeveelheid = Math.floor(hoeveelheid)
    @bloedvolume          -= hoeveelheid
    @opvolger.bloedvolume += hoeveelheid

  diffundeer_bloed: ->
    hoeveelheid = @drukverschil() * DIFFUSIVITEIT

    # Bloed kan niet terugstromen als het opvolgende onderdeel kleppen heeft
    unless hoeveelheid < 0 and @opvolger.kleppen
      @verplaats_bloed hoeveelheid

    return this

class Hartruimte extends Onderdeel
  vrij_volume: ->
    @max_volume - @bloedvolume

  vernieuw: ->
    if @contractie > 0
      # Het hart spant zich aan, hoeveel bloed wordt weggepompt?
      @contractie *= HART_CONTRACTIE_SNELHEID

      hoeveelheid = @bloedvolume * @contractie

      @verplaats_bloed hoeveelheid

    @diffundeer_bloed()

  systole: ->
    @contractie = 1

class Hartboezem extends Hartruimte
  constructor: ->
    super
    @max_volume = HARTBOEZEM_VOLUME

class Hartkamer extends Hartruimte
  constructor: ->
    super
    @max_volume = HARTKAMER_VOLUME
    @kleppen = true

class Bloedvat extends Onderdeel
  #constructor: ->

class Ader extends Bloedvat
  constructor: ->
    super
    @kleppen = true
