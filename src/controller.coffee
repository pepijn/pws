alive = false

initializeOnderdelen = ->
  window.onderdelen =
    Linkerboezem:   new Hartboezem,
    Linkerkamer:    new Hartkamer,
    Aorta:          new Slagader,
    Kransslagader:  new Slagader,
    Hart:           new Onderdeel,
    Kransader:      new Ader,
    Aftakkingen:    new Slagader,
    Onderlichaam:   new Onderdeel,
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
      onderdelen[onderdeel].bloed.push new Molecuul
      volume--

  # Luchtreservoir initialiseren
  window.luchtreservoir = new Luchtreservoir

initializeView = ->
  # Set up table
  for onderdeel of onderdelen
    $('#onderdelen tbody').append('
      <tr class="' + onderdeel + '">
        <td class="naam">' + onderdeel + '</td>
        <td class="bloedvolume">
          <div class="koolstofmonoxide"></div>
          <div class="koolstofdioxide"></div>
          <div class="zuurstofrijk"></div>
          <div class="zuurstofarm"></div>
        </td>
      </tr>')

  for long in ['Linkerlong', 'Rechterlong']
    $('#lucht tbody').append('
      <tr class="' + long + '">
        <td class="naam">' + long + '</td>
        <td class="longvolume">
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

  # Ademsnelheid
  onderdelen.Rechterlong.snelheid  = params.ademhalingssnelheid
  onderdelen.Linkerlong.snelheid  = params.ademhalingssnelheid

  # Longrendement
  onderdelen.Rechterlong.rendement = params.rechterlongrendement / 100
  onderdelen.Linkerlong.rendement  = params.linkerlongrendement / 100

  onderdelen.Hart.rendement = params.hartrendement / 100

  # Stijfheid instellen
  for onderdeel of onderdelen
    onderdelen[onderdeel].set_stijfheid()

  # Luchtresevoir legen en vullen
  luchtreservoir.inhoud = []
  concs =
    koolstofmonoxide: params.koolstofmonoxidegas
    koolstofdioxide:  params.koolstofdioxidegas
    zuurstofrijk:     params.zuurstofgas

  for binding, eenheden of concs
    i = eenheden
    while i > 0
      luchtreservoir.inhoud.push new Molecuul(binding)
      i--

  if alive
    clearInterval onderdelenInterval
    clearInterval hartcyclusInterval
    clearInterval ventilatieInterval

  window.onderdelenInterval = setInterval(loop_organs, 30)
  hartslag()
  window.hartcyclusInterval = setInterval(hartslag, (60/params.hartslag) * 1000)
  inademen()
  window.ventilatieInterval = setInterval(inademen, (60/params.ademhalingsfrequentie) * 1000)

  alive = true
  return false

loop_organs = ->
  sets =
    onderdelen: onderdelen
    lucht:
      Linkerlong: onderdelen.Linkerlong
      Rechterlong: onderdelen.Rechterlong

  for settype, setdata of sets
    for naam, onderdeel of setdata
      data = onderdeel.vernieuw()

      tr = $('#' + settype + ' .' + naam)

      schaal = 14
      concs = data.concentraties(settype)

      for gas of concs
        tr.find('.' + gas).css('width', (concs[gas] / 130) * schaal + '%')

  # Laat concentraties luchtreservoir zien
  data = luchtreservoir.concentraties('lucht')
  table = $('#luchtreservoir')

  for gas, eenheden of data
    table.find('.' + gas).text(eenheden)

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

window.inademen = ->
  onderdelen.Linkerlong.inademen()
  onderdelen.Rechterlong.inademen()

  setTimeout uitademen, params.ademinhoudingstijd * 1000

window.uitademen = ->
  onderdelen.Linkerlong.uitademen()
  onderdelen.Rechterlong.uitademen()

$('#parameters').submit()