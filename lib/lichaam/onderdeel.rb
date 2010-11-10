module Lichaam
  # Abstracte klasse van elk onderdeel in het lichaam dat bloed bevat
  class Onderdeel
    # In welke mate wordt per vernieuwingsronde bloed overgebracht?
    DRUKVERSCHIL_DELER = 5

    # Wat is het kunstmatige maximale volume per onderdeel?
    MAXIMAAL_STANDAARD_VOLUME = 500

    # Methode om het bloed dat in een onderdeel zit te benaderen en te manipuleren
    attr_reader :vaatinhoud

    # Maximaal volume van een onderdel
    attr_reader :volume

    # Initializeer een nieuw onderdeel, maak de vaatinhoud leeg
    def initialize
      @vaatinhoud = []
      @volume     = MAXIMAAL_STANDAARD_VOLUME
    end

    # Abstractie van bloeddruk in aantal Bloed-objecten per onderdeel
    def bloeddruk
      vaatinhoud.size
    end

    # Het orgaan wat in de volgorde van de bloedsomloop na dit onderdeel volgt
    attr_reader :opvolger

    # Verbind een nieuw onderdeel met het huidige onderdeel
    def verbind(onderdeel)
      @opvolger = onderdeel
    end

    # Herhalende check met interval
    def vernieuw
      diffundeer_bloed!
    end

    # Diffundeer het bloed in dit onderdeel naar het volgende
    def diffundeer_bloed!
      # Zolang er een bloeddrukverschil is in de bloedvaten
      if bloeddruk > opvolger.bloeddruk
        # Bereken het drukverschil tussen twee aneenliggende onderdelen
        drukdelta = (bloeddruk - opvolger.bloeddruk) / DRUKVERSCHIL_DELER

        # Verplaats het bloed van hoge druk naar lage druk
        verplaats_bloed(drukdelta)
      end
    end

    # Verplaatst bloed met een bepaalde bloeddruk naar z'n opvolger
    def verplaats_bloed(druk)
      druk.times do
        # Stop met verplaatsing van bloed als bloeddruk hoger of gelijk aan het
        # volume van het opvolgende onderdeel is
        break if opvolger.bloeddruk >= opvolger.volume

        opvolger.vaatinhoud << vaatinhoud.shift
      end
    end

    # Computerweergave
    def to_json(*args)
      {
        :bloeddruk => bloeddruk
      }.to_json
    end
  end
end