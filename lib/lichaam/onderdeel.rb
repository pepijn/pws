module Lichaam
  # Abstracte klasse van elk onderdeel in het lichaam dat bloed bevat
  class Onderdeel
    # In welke mate wordt per vernieuwingsronde bloed overgebracht?
    DIFFUSIVITEIT = 0.1

    # Wat is het kunstmatige maximale volume per onderdeel?
    MAXIMAAL_STANDAARD_VOLUME = 500

    # Bloed in het onderdeel
    attr_reader :bloed

    # Maximaal volume van een onderdel
    attr_reader :volume

    # Initializeer een nieuw onderdeel, maak de vaatinhoud leeg
    def initialize
      @bloed  = BloedHouder.new
      @volume = MAXIMAAL_STANDAARD_VOLUME
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
      # Zolang er een bloed.drukverschil is in de bloedvaten
      if bloed.druk > opvolger.bloed.druk
        # Bereken het drukverschil tussen twee aneenliggende onderdelen
        drukdelta = DIFFUSIVITEIT * (bloed.druk - opvolger.bloed.druk)

        # Verplaats het bloed van hoge druk naar lage druk
        verplaats_bloed(drukdelta.ceil)
      end
    end

    # Verplaatst bloed met een bepaalde bloed.druk naar z'n opvolger
    def verplaats_bloed(druk)
      druk.times do
        # Stop met verplaatsing van bloed als bloed.druk hoger of gelijk aan het
        # volume van het opvolgende onderdeel is
        break if opvolger.bloed.druk >= opvolger.volume

        opvolger.bloed << bloed.shift
      end
    end

    # Computerweergave
    def to_json(*args)
      {
        :bloeddruk => bloed.druk
      }.to_json
    end

    # Inhoud van de bloedvaten van een onderdeel
    class BloedHouder < Array
      # Hoeveel bloed zit erin?
      def druk
        self.size
      end

      # De concentratie van het bloed
      def concentratie
      end
    end
  end
end