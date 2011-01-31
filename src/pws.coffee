HARTBOEZEM_CONTRACTIE_SNELHEID = 5
HART_ONTSPANNING_SNELHEID = 5
HARTKAMER_VOLUME = 800 # mL * 10
HARTBOEZEM_VOLUME = 270 # mL * 10, 1/3 van hartkamer

class Vloeistof
  constructor: ->
    @binding = 'zuurstofarm'

class Onderdeel
  constructor: (kleppen) ->
    @bloed = []
    @bloedvat = 'haarvat'
    @kleppen = kleppen ? false

    # Standaard is het onderdeel (meestal bloedvat) rekbaar
    @max_volume = @volume

  set_stijfheid: ->
    @stijfheid = params[@bloedvat]

  concentraties: (data = @bloed) ->
    concs =
      koolstofmonoxide: 0
      koolstofdioxide:  0
      zuurstofarm:      0
      zuurstofrijk:     0

    for obj in data
      concs[obj.binding]++ if obj?

    concs

  vernieuw: ->
    @diffundeer_bloed()

  bloedvolume: ->
    @bloed.length

  diffundeer_bloed: ->
    for opvolger in @opvolger
      bloedverplaatsing = 0

      # Duw bloed wat het niet kan hebben naar volgende onderdeel
      verschil = @bloedvolume() - @max_volume
      if @max_volume? and verschil > 0
        bloedverplaatsing += verschil

      # Diffusie onderdeel
      bloedverplaatsing += Math.ceil((@bloedvolume() - opvolger.bloedvolume()) / opvolger.stijfheid)

      while bloedverplaatsing > 0
        opvolger.bloed.push @bloed.shift()
        bloedverplaatsing--

    return this

class Hartruimte extends Onderdeel
  constructor: ->
    super
    @bloedvat = 'hartruimte'

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

class Ader extends Onderdeel
  constructor: ->
    super
    @bloedvat = 'ader'

class Slagader extends Onderdeel
  constructor: ->
    super
    @bloedvat = 'slagader'

class Orgaan extends Onderdeel
  constructor: ->
    super

  vernieuw: ->
    for bloed in @bloed
      bloed.binding = 'koolstofdioxide' if bloed && bloed.binding != 'koolstofmonoxide'

    @diffundeer_bloed()

class Longen extends Orgaan
  constructor: ->
    @inhoud = []
    super

  respireer: ->
    i = 500
    while i > 0
      vl = new Vloeistof
      vl.binding = 'zuurstofrijk'
      @inhoud.push vl
      i--

  vernieuw: ->
    for bloed in @bloed
      vloeistof = @inhoud[0]

      # Geen beschikbaar vloeistof meer in vocht
      break unless vloeistof?

      # Geen diffusie gaande
      continue if bloed.binding == vloeistof.binding

      bloed.binding = vloeistof.binding
      @inhoud.shift()

    @diffundeer_bloed()
