alive = false

initializeOnderdelen = ->
  window.onderdelen =
    Linkerboezem:   new Hartboezem,
    Linkerkamer:    new Hartkamer,
    Aorta:          new Slagader,
    Kransslagader:  new Slagader,
    Hart:           new Orgaan,
    Kransader:      new Ader,
    Aftakkingen:    new Slagader,
    Onderlichaam:   new Orgaan,
    Holleader:      new Ader,
    Rechterboezem:  new Hartboezem,
    Rechterkamer:   new Hartkamer,
    Longslagader:   new Onderdeel,
    Linkerlong:     new Long,
    Rechterlong:    new Long,
    Longader:       new Ader

  onderdelen.Linkerboezem.opvolger  = [onderdelen.Linkerkamer]
  onderdelen.Linkerkamer.opvolger   = [onderdelen.Aorta]
  onderdelen.Aorta.opvolger         = [onderdelen.Kransslagader, onderdelen.Aftakkingen]

  # Eerste aftakking aorta naar het hart
  onderdelen.Kransslagader.opvolger = [onderdelen.Hart]
  onderdelen.Hart.opvolger          = [onderdelen.Kransader]
  onderdelen.Kransader.opvolger     = [onderdelen.Hart]
  onderdelen.Kransader.opvolger     = [onderdelen.Rechterboezem]

  # Doorstroom van de aorta naar rest v/ organen
  onderdelen.Aftakkingen.opvolger   = [onderdelen.Onderlichaam]
  onderdelen.Onderlichaam.opvolger  = [onderdelen.Holleader]
  onderdelen.Holleader.opvolger     = [onderdelen.Rechterboezem]

  onderdelen.Rechterboezem.opvolger = [onderdelen.Rechterkamer]
  onderdelen.Rechterkamer.opvolger  = [onderdelen.Longslagader]

  # Longen
  onderdelen.Longslagader.opvolger  = [onderdelen.Linkerlong, onderdelen.Rechterlong]
  onderdelen.Linkerlong.opvolger    = [onderdelen.Longader]
  onderdelen.Rechterlong.opvolger   = [onderdelen.Longader]
  onderdelen.Longader.opvolger      = [onderdelen.Linkerboezem]

  for onderdeel of onderdelen
    volume = 220
    while volume > 0
      onderdelen[onderdeel].bloed.push new Vloeistof
      volume--

initializeView = ->
  # Set up table
  for onderdeel of onderdelen
    $('#onderdelen tbody').append('
      <tr id="' + onderdeel + '">
        <td class="naam">' + onderdeel + '</td>
        <td class="volume"></td>
        <td class="bloedvolume">
          <div class="koolstofmonoxide"></div>
          <div class="koolstofdioxide"></div>
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

  # Longrendement
  onderdelen.Rechterlong.rendement = params.rechterlongrendement
  onderdelen.Linkerlong.rendement  = params.linkerlongrendement

  onderdelen.Hart.rendement   = params.hartrendement

  # Stijfheid instellen
  for onderdeel of onderdelen
    onderdelen[onderdeel].set_stijfheid()

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

    schaal = 14
    concs = data.concentraties()
    tr.find('.koolstofmonoxide').css('width', (concs.koolstofmonoxide / 130) * schaal + '%')
    tr.find('.koolstofdioxide').css('width', (concs.koolstofdioxide / 130) * schaal + '%')
    tr.find('.zuurstofrijk').css('width', (concs.zuurstofrijk / 130) * schaal + '%')
    tr.find('.zuurstofarm').css('width', (concs.zuurstofarm / 130) * schaal + '%')

window.hartslag = ->
  for onderdeel in [onderdelen.Linkerboezem, onderdelen.Rechterboezem]
    onderdeel.systole()

  setTimeout (->
    # Systole
    for onderdeel in [onderdelen.Linkerkamer, onderdelen.Rechterkamer]
      onderdeel.systole()

    # Diastole
    for onderdeel in [onderdelen.Linkerboezem, onderdelen.Rechterboezem]
      onderdeel.contract = false
  ), 100

  setTimeout (->
    for onderdeel in [onderdelen.Linkerkamer, onderdelen.Rechterkamer]
      onderdeel.contract = false
  ), 400

window.ademhaling = ->
  onderdelen.Linkerlong.respireer()
  onderdelen.Rechterlong.respireer()

$('#parameters').submit()