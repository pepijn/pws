DIFFUSIVITEIT = 0.1

HARTBOEZEM_CONTRACTIE_SNELHEID = 5
HART_ONTSPANNING_SNELHEID = 5
HARTKAMER_VOLUME = 80 # mL * 10
HARTBOEZEM_VOLUME = 27 # mL * 10, 1/3 van hartkamer

class Vloeistof
  constructor: ->
    @zuurstofrijk = false

class Onderdeel
  constructor: (kleppen) ->
    @bloed = []
    @kleppen = kleppen ? false

    # Standaard is het onderdeel (meestal bloedvat) rekbaar
    @max_volume = @volume

  vernieuw: ->
    @diffundeer_bloed()

  bloedvolume: ->
    @bloed.length

  concentraties: ->
    concs =
      zuurstofarm:  0
      zuurstofrijk: 0

    for bloed in @bloed
      if bloed.zuurstofrijk then concs.zuurstofrijk++ else concs.zuurstofarm++

    concs

  diffundeer_bloed: ->
    for opvolger in @opvolger
      bloedverplaatsing = 0

      # Duw bloed wat het niet kan hebben naar volgende onderdeel
      verschil = @bloedvolume() - @max_volume
      if @max_volume? and verschil > 0
        bloedverplaatsing += verschil

      # Diffusie onderdeel
      hoeveelheid = Math.floor((@bloedvolume() - opvolger.bloedvolume()) * DIFFUSIVITEIT)
      if hoeveelheid > 0
        bloedverplaatsing += hoeveelheid

      while bloedverplaatsing > 0
        opvolger.bloed.push @bloed.shift()
        bloedverplaatsing--

    return this

class Hartruimte extends Onderdeel
  vernieuw: ->
    if @contract
      # Het hart spant zich aan, hoeveel bloed wordt weggepompt?
      i = @kracht / @volume

      while i > 0
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
  constructor: (volume) ->
    @volume = volume
    super

class Ader extends Bloedvat
  constructor: ->
    super

class Orgaan extends Onderdeel

class Hart extends Orgaan
  vernieuw: ->
    for bloed in @bloed
      bloed.zuurstofrijk = false

    @diffundeer_bloed()

class Longen extends Orgaan
  constructor: ->
    @lucht = 0
    super

  respireer: ->
    @lucht = 200

  vernieuw: ->
    for bloed in @bloed
      break unless @lucht
      bloed.zuurstofrijk = true
      @lucht--

    @diffundeer_bloed()

