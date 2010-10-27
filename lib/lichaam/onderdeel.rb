module Lichaam
  class Onderdeel
    # Methode om het bloed dat in een onderdeel zit te benaderen en te manipuleren
    attr_accessor :bloed

    # Het orgaan wat in de volgorde van de bloedsomloop na dit onderdeel volgt
    attr_reader :volgende_onderdeel

    # Verbind een nieuw onderdeel met het huidige onderdeel
    def verbind(onderdeel)
      @volgende_onderdeel = onderdeel
    end
  end
end