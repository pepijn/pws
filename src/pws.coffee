HARTKAMER_VOLUME = 800 # staat voor 80 mL
HARTBOEZEM_VOLUME = 270 # 1/3 van hartkamer

class Molecuul
  constructor: (binding) ->
    @binding = binding ? 'zuurstofrijk'

  verbrand: (caller) ->
    if @binding == 'zuurstofrijk'
      @binding = 'koolstofdioxide' if Math.random() > caller.rendement
      true
    else
      false

class ConcentratieHouder
  concentraties: (type) ->
    data = if type == 'lucht' then @inhoud else @bloed

    concs =
      koolstofmonoxide: 0
      koolstofdioxide:  0
      zuurstofrijk:     0

    for obj in data
      concs[obj.binding]++ if obj?

    concs

class Luchtreservoir extends ConcentratieHouder
  constructor: ->
    @inhoud = []

class Onderdeel extends ConcentratieHouder
  constructor: (kleppen) ->
    @bloed = []
    @bloedvat = 'haarvat'

  set_stijfheid: ->
    @stijfheid = params[@bloedvat]

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
        opvolger.bloed.push @bloed.shift() unless opvolger.max_volume? && opvolger.bloedvolume >= opvolger.max_volume
        bloedverplaatsing--

    return this

class Hartruimte extends Onderdeel
  constructor: ->
    super
    @bloedvat = 'hartruimte'

  systole: ->
    @max_volume = @bloedvolume()
    @contract = true

  vernieuw: ->
    if @contract
      # Het hart spant zich aan, hoeveel bloed wordt weggepompt?
      i = @kracht / @volume

      while i > 0
        if @max_volume > 0
          # Checken of er zuurstof te verbranden is in de hartspier
          for bloed in onderdelen.Hart.bloed
            if bloed.verbrand(onderdelen.Hart)
              @max_volume--
              break
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

class Ader extends Bloedvat
  constructor: ->
    super
    @bloedvat = 'ader'

class Slagader extends Bloedvat
  constructor: ->
    super
    @bloedvat = 'slagader'

class Long extends Onderdeel
  constructor: ->
    @inhoud = []

    # Niet inademen en niet uitademen
    @status = false

    super

  longvolume: ->
    @inhoud.length

  inademen: ->
    # Laat lucht in reservoir verspreiden
    luchtreservoir.inhoud.sort ->
      0.5 - Math.random()

    @status = 'inademen'

  uitademen: ->
    # Laat lucht in longen verspreiden
    @inhoud.sort ->
      0.5 - Math.random()

    @status = 'uitademen'

  diffundeer_lucht: ->
    if @status == 'inademen'
      hoeveelheid = (@capaciteit - @longvolume()) / @snelheid
      while hoeveelheid > 0
        if @longvolume() >= @max_longvolume
          # Longen vol met lucht
          @status = false
          break

        for bloed in onderdelen.Middenrifspier.bloed
          if bloed.verbrand(this)
            @inhoud.push luchtreservoir.inhoud.shift()
            break

        hoeveelheid--
    else if @status == 'uitademen'
      hoeveelheid = (@longvolume() - @restvolume) / @snelheid
      while hoeveelheid > 0
        if @longvolume() <= @restvolume
          # Longen leeg
          @status = false
          break

        luchtreservoir.inhoud.push @inhoud.shift()
        hoeveelheid--

  vernieuw: ->
    i = 50
    longvolume = @longvolume()
    bloedvolume = @bloedvolume()

    while i > 0
      vloeistof = @inhoud[Math.floor(Math.random() * longvolume)]
      bloed = @bloed[Math.floor(Math.random() * bloedvolume)]

      # Geen beschikbaar vloeistof meer in vocht
      break unless vloeistof? && bloed?

      # Geen diffusie gaande
      continue if bloed.binding == vloeistof.binding

      # Waarschijnlijk wel diffusie gaande
      binding = vloeistof.binding

      if binding == 'zuurstofrijk' || binding == 'koolstofmonoxide'
        vloeistof.binding = bloed.binding
        bloed.binding = binding

      i--

    @diffundeer_lucht()
    @diffundeer_bloed()
