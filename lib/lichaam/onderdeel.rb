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

    # Verplaatst bloed met een bepaalde bloeddruk naar z'n opvolger
    def verplaats_bloed(druk)
      druk.times do
        opvolger.vaatinhoud << vaatinhoud.shift
      end
    end
  end
end