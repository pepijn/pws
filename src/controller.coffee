alive = false

initializeOnderdelen = ->
  window.onderdelen = {
    Linkerboezem:   new Hartboezem,
    Linkerkamer:    new Hartkamer,
    Aorta:          new Onderdeel(true),
    Kransslagader:  new Onderdeel,
    Hart:           new Hart,
    Kransader:      new Ader,
    Rechterboezem:  new Hartboezem,
    Rechterkamer:   new Hartkamer,
    Longslagader:   new Onderdeel(true),
    Longen:         new Longen,
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

  volume = 500
  while volume > 0
    onderdelen.Aorta.bloed.push new Vloeistof
    volume--

initializeView = ->
  # Set up table
  for onderdeel of onderdelen
    $('#onderdelen tbody').append('
      <tr id="' + onderdeel + '">
        <td class="naam">' + onderdeel + '</td>
        <td class="volume"></td>
        <td class="bloedvolume">
          <div class="zuurstofrijk"></div>
          <div class="zuurstofarm"></div>
        </td>
      </tr>')

initializeOnderdelen()
initializeView()

$('#parameters').submit ->
  window.params = {}
  for input in $('#parameters input')
    el = $(input)
    params[el.attr('id')] = parseInt el.val() if el.val() unless el.attr('type') is 'submit'

  onderdelen.Rechterboezem.kracht = params.rechterboezem
  onderdelen.Linkerboezem.kracht  = params.linkerboezem
  onderdelen.Rechterkamer.kracht  = params.rechterkamer
  onderdelen.Linkerkamer.kracht   = params.linkerkamer

  onderdelen.Longen.rendement = params.longrendement
  onderdelen.Hart.rendement   = params.hartrendement

  if alive
    clearInterval(onderdelenInterval)
    clearInterval(hartcyclusInterval)

  window.onderdelenInterval = setInterval(loop_organs, 30)
  window.hartcyclusInterval = setInterval(hartslag, (60/params.hartslag) * 1000)
  window.ventilatieInterval = setInterval(ademhaling, (60/params.ademhalingsfrequentie) * 1000)

  alive = true
  return false

loop_organs = ->
  for naam, onderdeel of onderdelen
    data = onderdeel.vernieuw()
    tr = $('#' + naam)
    tr.find('.volume').text(data.max_volume)

    concs = data.concentraties()
    tr.find('.zuurstofrijk').text(concs.zuurstofrijk).css('width', (concs.zuurstofrijk / 130) * 100 + '%')
    tr.find('.zuurstofarm').css('width', (concs.zuurstofarm / 130) * 100 + '%')

window.hartslag = ->
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

window.ademhaling = ->
  onderdelen.Longen.respireer()

$('#parameters').submit()