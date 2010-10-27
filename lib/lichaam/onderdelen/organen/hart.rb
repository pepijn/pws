module Lichaam
  module Onderdelen
    module Organen
      class Hart < Orgaan
        # Boezems en kamers
        attr_reader :linker_boezem, :linker_kamer, :rechter_boezem, :rechter_kamer

        def initialize
          @linker_boezem  = Boezem.new
          @linker_kamer   = Kamer.new
          @rechter_boezem = Boezem.new
          @rechter_kamer  = Kamer.new
        end

        # Hartkamerspieren aanspannen
        def systole
          [linker_kamer, rechter_kamer].each {|kamer| kamer.pomp }
        end

        # Hartboezemspieren aanspannen
        def diastole
          [linker_boezem, rechter_boezem].each {|boezem| boezem.pomp }
        end

        class Boezem < Onderdeel
        end

        class Kamer < Onderdeel
        end
      end
    end
  end
end