module Lichaam
  # Abstracte klasse van elk onderdeel in het lichaam dat bloed bevat
  class Onderdeel
    # Methode om het bloed dat in een onderdeel zit te benaderen en te manipuleren
    attr_accessor :vaatinhoud, :klep

    # Initializeer een nieuw onderdeel, maak de vaatinhoud leeg
    def initialize
      @vaatinhoud = []
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

    # Diffundeer het bloed in dit onderdeel naar het volgende
    def diffundeer_bloed!
      # Zolang er een bloeddrukverschil is in de bloedvaten
      if bloeddruk > opvolger.bloeddruk
        # Kan er uitwisseling plaatsvinden?
        if !klep || klep.open?
          # Bereken het drukverschil tussen twee aneenliggende onderdelen
          drukdelta = (bloeddruk - opvolger.bloeddruk) / 5

          # Verplaats het bloed van hoge druk naar lage druk
          verplaats_bloed(drukdelta)
        end
      end
    end

    # Herhalende check
    def vernieuw
      diffundeer_bloed!
    end

    # Verplaatst bloed met een bepaalde bloeddruk naar z'n opvolger
    def verplaats_bloed(druk)
      druk.times do
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