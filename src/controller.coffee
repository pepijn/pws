alive = false

initializeOnderdelen = ->
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

initializeView = ->
  # Set up table
  for onderdeel of onderdelen
    $('#onderdelen tbody').append('
      <tr id="' + onderdeel + '">
        <td class="naam">' + onderdeel + '</td>
        <td class="volume"></td>
        <td><div class="bloedvolume"></div></td>
      </tr>')

initializeOnderdelen()
initializeView()

$('#parameters').submit ->
  initializeOnderdelen()
  window.params = {}
  for input in $('#parameters input')
    el = $(input)
    params[el.attr('id')] = parseInt el.val() if el.val() unless el.attr('type') is 'submit'

  volume = params.bloedinjectie

  while volume > 0
    onderdelen.Aorta.bloed.push new Bloed
    volume--

  onderdelen.Rechterboezem.kracht = params.rechterboezem
  onderdelen.Linkerboezem.kracht  = params.linkerboezem
  onderdelen.Rechterkamer.kracht  = params.rechterkamer
  onderdelen.Linkerkamer.kracht   = params.linkerkamer

  if alive
    clearInterval(onderdelenInterval)
    clearInterval(hartcyclusInterval)

  window.onderdelenInterval = setInterval(loop_organs, 30)
  window.hartcyclusInterval = setInterval(hartcyclus, (60/params.hartslag) * 1000)

  alive = true
  return false

loop_organs = ->
  for naam, onderdeel of onderdelen
    data = onderdeel.vernieuw()
    tr = $('#' + naam)
    tr.find('.volume').text(data.max_volume)
    tr.find('.bloedvolume').text(data.bloedvolume()).css('width', (data.bloedvolume() / 200) * 100 + '%')

window.hartcyclus = ->
  for onderdeel in [onderdelen.Linkerboezem, onderdelen.Rechterboezem]
    onderdeel.contract = true

  setTimeout (->
    # Systole
    for onderdeel in [onderdelen.Linkerkamer, onderdelen.Rechterkamer]
      onderdeel.contract = true

    # Diastole
    for onderdeel in [onderdelen.Linkerboezem, onderdelen.Rechterboezem]
      onderdeel.contract = false
  ), 100

  setTimeout (->
    for onderdeel in [onderdelen.Linkerkamer, onderdelen.Rechterkamer]
      onderdeel.contract = false
  ), 400
