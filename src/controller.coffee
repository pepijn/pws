window.onderdelen = {
  Linkerboezem:   new Hartboezem,
  Linkerkamer:    new Hartkamer,
  Aorta:          new Onderdeel(true),
  Kransslagader:  new Onderdeel,
  Hart:           new Onderdeel,
  Kransader:      new Ader,
  Rechterboezem:  new Hartboezem,
  Rechterkamer:   new Hartkamer,
  Longslagader:   new Onderdeel(true),
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

$('#parameters').submit(->
  window.params = {}
  for input in $('#parameters input')
    el = $(input)
    params[el.attr('id')] = parseInt el.val() if el.val() unless el.attr('type') is 'submit'

  onderdelen.Hart.bloedvolume = params.bloedinjectie
  return false
)

make_table_row = (onderdeel) ->
  $('#onderdelen tbody').append('
    <tr id="' + onderdeel + '">
      <td class="naam">' + onderdeel + '</td>
      <td class="volume"></td>
      <td><div class="bloedvolume"></div></td>
    </tr>')

# Set up table
for onderdeel of onderdelen
  make_table_row onderdeel

loop_organs = (onderdelen) ->
  for naam, onderdeel of onderdelen
    data = onderdeel.vernieuw()
    tr = $('#' + naam)
    tr.find('.volume').text(data.max_volume)
    tr.find('.bloedvolume').text(data.bloedvolume).css('width', data.bloedvolume)

window.systole = ->
  for onderdeel in [onderdelen.Linkerboezem, onderdelen.Rechterboezem]
    onderdeel.systole()

  setTimeout (->
    for onderdeel in [onderdelen.Linkerkamer, onderdelen.Rechterkamer]
      onderdeel.systole()), 100

window.refreshLoop = setInterval(loop_organs, 20, onderdelen)
window.systoleLoop = setInterval(systole, 800)