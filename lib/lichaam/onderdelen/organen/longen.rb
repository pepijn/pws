module Lichaam
  module Onderdelen
    module Organen
      class Longen < Orgaan
        attr_reader :alveolaire_lucht, :alveolair_vocht

        def initialize
          super

          @alveolaire_lucht = []
          @alveolair_vocht  = []
        end

        # Activeer gaswisseling tussen alveolair vocht en bloed
        def vernieuw!
          bloed.each do |rbc|
            rbc.each do |hb|
              hb.binding = alveolair_vocht.shift unless !hb.binding.nil? || alveolair_vocht.empty?
            end
          end

          diffundeer_bloed!
        end
      end
    end
  end
end
