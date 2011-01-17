DIFFUSIVITEIT = 0.1

HARTBOEZEM_CONTRACTIE_SNELHEID = 5
HART_ONTSPANNING_SNELHEID = 5
HARTKAMER_VOLUME = 80 # mL * 10
HARTBOEZEM_VOLUME = 27 # mL * 10, 1/3 van hartkamer

class Onderdeel
  constructor: (kleppen) ->
    @bloedvolume = 0
    @kleppen = kleppen ? false

    # Standaard is het onderdeel (meestal bloedvat) rekbaar
    @max_volume = @volume

  vernieuw: ->
    @diffundeer_bloed()

  # Drukverschil met opvolger
  drukverschil: ->
    @bloedvolume - @opvolger.bloedvolume

  diffundeer_bloed: ->
    # Duw bloed wat het niet kan hebben naar volgende onderdeel
    verschil = @max_volume - @bloedvolume
    if @max_volume > 0 and verschil < 0
      @bloedvolume += verschil
      @opvolger.bloedvolume -= verschil

    # Bloed naar andere onderdelen
    hoeveelheid = Math.floor(@drukverschil() * DIFFUSIVITEIT)

    while hoeveelheid >= 0
      @bloedvolume--
      @opvolger.bloedvolume++

      hoeveelheid--

    return this

class Hartruimte extends Onderdeel
  vernieuw: ->
    if @contract
      # Het hart spant zich aan, hoeveel bloed wordt weggepompt?
      i = @kracht / @volume

      while i >= 0
        if @max_volume > 0
          @max_volume--
        else
          @contract = false

        i--
    else
      # Bij ontspanning kan de hartruimte gevuld worden
      @max_volume = @volume

    @diffundeer_bloed()

class Hartboezem extends Hartruimte
  constructor: ->
    @volume = HARTBOEZEM_VOLUME
    super

class Hartkamer extends Hartruimte
  constructor: ->
    @volume = HARTKAMER_VOLUME
    super

class Bloedvat extends Onderdeel
  #constructor: ->

class Ader extends Bloedvat
  constructor: ->
    super
    @kleppen = true
