module Lichaam
  module Onderdelen
    module Organen
      # Het hart
      class Hart < Orgaan
        # Boezems en kamers
        attr_reader :linker_boezem, :linker_kamer, :rechter_boezem, :rechter_kamer

        def initialize
          @linker_boezem  = Ruimten::Boezem.new
          @linker_kamer   = Ruimten::Kamer.new
          @rechter_boezem = Ruimten::Boezem.new
          @rechter_kamer  = Ruimten::Kamer.new
        end

        # Hartkamerspieren aanspannen
        def systole
          [linker_kamer, rechter_kamer].each {|kamer| kamer.pomp }
        end

        # Hartboezemspieren aanspannen
        def diastole
          [linker_boezem, rechter_boezem].each {|boezem| boezem.pomp }
        end

        # Boezems en kamers in het hart
        module Ruimten
          # Gemeenschappelijk gedrag voor boezems en kamers
          class Ruimte < Onderdeel
            # Pomp het bloed uit de hartruimte
            def pomp
            end
          end

          # Hartboezem
          class Boezem < Ruimte
          end

          # Hartkamer
          class Kamer < Ruimte
          end
        end
      end
    end
  end
end