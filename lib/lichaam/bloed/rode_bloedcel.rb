module Lichaam
  module Bloed
    # Een abstractie van een hoeveelheid rode bloedcellen
    class RodeBloedcel < Array
      include Lichaam::Eiwitten
      include Omgeving::Moleculen

      # Hoeveel hemoglobine eiwtten zitten er in een rode bloedcel?
      HEMOGLOBINE_CONCENTRATIE_MODEL = 5

      # Bouw een rode bloedcel met een n aantal hemoglobine eiwitten
      def initialize
        HEMOGLOBINE_CONCENTRATIE_MODEL.times do
          self << Hemoglobine.new
        end
      end

      # Totaal aan hemoglobinen in deze rode bloedcel
      def hemoglobinen
        self.select {|stof| stof.class == Hemoglobine }
      end

      # Totaal aan oxihemoglobinen
      def oxihemoglobinen
        hemoglobinen.select {|hb| hb.binding.class == Zuurstof }
      end
    end
  end
end