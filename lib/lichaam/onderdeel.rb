module Lichaam
  class Onderdeel
    # Methode om het bloed dat in een onderdeel zit te benaderen en te manipuleren
    attr_accessor :vaatinhoud

    # Het orgaan wat in de volgorde van de bloedsomloop na dit onderdeel volgt
    attr_reader :opvolger

    def initialize
      @vaatinhoud = []
    end

    # Verbind een nieuw onderdeel met het huidige onderdeel
    def verbind(onderdeel)
      @opvolger = onderdeel
    end
  end
end