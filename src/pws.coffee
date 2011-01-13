DIFFUSIVITEIT = 0.1
STANDAARD_MAXIMAAL_VOLUME = 500 # halve liter, kunstmatig

HART_ONTSPANNING_SNELHEID = 0.5
HARTKAMER_VOLUME = 80 # mL
HARTBOEZEM_VOLUME = 27 # mL, 1/3 van hartkamer

class Onderdeel
  constructor: ->
    @bloeddruk = 0
    @volume = STANDAARD_MAXIMAAL_VOLUME

  vernieuw: ->
    drukdelta = @bloeddruk - @opvolger.bloeddruk

    if drukdelta > 0
      hoeveelheid = Math.ceil(drukdelta * DIFFUSIVITEIT)
      @verplaats_bloed hoeveelheid

    return this

  verplaats_bloed: (hoeveelheid) ->
    hoeveelheid = @volume if hoeveelheid > @volume

    if hoeveelheid <= @opvolger.volume
      @bloeddruk -= hoeveelheid
      @opvolger.bloeddruk += hoeveelheid

class Hartruimte extends Onderdeel
  # vernieuw: ->
    # @systole if @volume != HARTKAMER_VOLUME

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


window.onderdelen = {
  Linkerboezem:   new Hartboezem,
  Linkerkamer:    new Hartkamer,
  Aorta:          new Onderdeel,
  Kransslagader:  new Onderdeel,
  Hart:           new Onderdeel,
  Kransader:      new Ader,
  Rechterboezem:  new Hartboezem,
  Rechterkamer:   new Hartkamer,
  Longslagader:   new Onderdeel,
  Longen:         new Onderdeel,
  Longader:       new Ader
}

onderdelen.Linkerboezem.opvolger  = onderdelen.Linkerkamer
onderdelen.Linkerkamer.opvolger   = onderdelen.Aorta
onderdelen.Aorta.opvolger         = onderdelen.Kransslagader
onderdelen.Kransslagader.opvolger = onderdelen.Hart
onderdelen.Hart.opvolger          = onderdelen.Kransader
onderdelen.Kransader.opvolger     = onderdelen.Hart
onderdelen.Kransader.opvolger     = onderdelen.Rechterboezem
onderdelen.Rechterboezem.opvolger = onderdelen.Rechterkamer
onderdelen.Rechterkamer.opvolger  = onderdelen.Longslagader
onderdelen.Longslagader.opvolger  = onderdelen.Longen
onderdelen.Longen.opvolger        = onderdelen.Longader
onderdelen.Longader.opvolger      = onderdelen.Linkerboezem

onderdelen.Aorta.bloeddruk = 350

make_table_row = (onderdeel) ->
  $('#onderdelen tbody').append('
    <tr id="' + onderdeel + '">
      <td class="naam">' + onderdeel + '</td>
      <td class="volume"></td>
      <td><div class="bloeddruk"></div></td>
    </tr>')

# Set up table
for onderdeel of onderdelen
  make_table_row onderdeel

loop_organs = (onderdelen) ->
  for naam, onderdeel of onderdelen
    data = onderdeel.vernieuw()
    tr = $('#' + naam)
    tr.find('.volume').text(data.volume)
    tr.find('.bloeddruk').css('width', data.bloeddruk * 5)

window.systole = ->
  for onderdeel in [onderdelen.Linkerboezem, onderdelen.Rechterboezem]
    onderdeel.verplaats_bloed onderdeel.bloeddruk

  setTimeout (->
    for onderdeel in [onderdelen.Linkerkamer, onderdelen.Rechterkamer]
      onderdeel.verplaats_bloed onderdeel.bloeddruk), 100

window.refreshLoop = setInterval(loop_organs, 20, onderdelen)
window.systoleLoop = setInterval(systole, 800)