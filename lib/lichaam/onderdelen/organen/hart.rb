module Lichaam
  module Onderdelen
    module Organen
      # Het hart
      class Hart < Orgaan
        # Boezems
        attr_reader :rechter_boezem, :linker_boezem

        # Kamers
        attr_reader :rechter_kamer, :linker_kamer

        # Klep tussen rechterboezem en rechterkamer
        attr_reader :tricuspidalisklep

        # Klep tussen linkerboezem en linkerkamer
        attr_reader :mitralisklep

        # Halvemaanvormige kleppen
        attr_reader :pulmonalisklep, :aortaklep

        def initialize
          # Initializeer als een normaal onderdeel
          super

          @linker_boezem  = Ruimten::Boezem.new
          @linker_kamer   = linker_boezem.verbind Ruimten::Kamer.new
          @rechter_boezem = Ruimten::Boezem.new
          @rechter_kamer  = rechter_boezem.verbind Ruimten::Kamer.new

          @tricuspidalisklep = @linker_boezem.klep  = Klep.new
          @mitralisklep      = @rechter_boezem.klep = Klep.new
          @pulmonalisklep    = @rechter_kamer.klep  = Klep.new
          @aortaklep         = @linker_kamer.klep   = Klep.new
        end

        def boezem_systole
          # Trek spier samen
          [linker_boezem, rechter_boezem].each {|boezem| boezem.trek_samen }
        end

        def kamer_systole
          # Sluit kleppen van kamers naar boezems
          [tricuspidalisklep, mitralisklep].each {|klep| klep.sluit! }

          # Open kleppen van kamers naar slagaders
          [pulmonalisklep, aortaklep].each {|klep| klep.open! }

          # Trek spier samen
          [linker_kamer, rechter_kamer].each {|kamer| kamer.trek_samen }

          # Sluit kleppen van kamers naar slagaders
          [pulmonalisklep, aortaklep].each {|klep| klep.sluit! }

          # Open kleppen van kamers naar boezems
          [tricuspidalisklep, mitralisklep].each {|klep| klep.open! }
        end

        def boezem_diasystole
        end

        def kamer_diasystole
        end

        # Override standaard activeerfunctie
        def vernieuw!
          [self, linker_boezem, rechter_boezem].map &:diffundeer_bloed!
        end

        # Gemeenschappelijk gedrag voor boezems en kamers
        class Ruimte < Onderdeel
          # Hartklep
          attr_accessor :klep

          # Pomp het bloed uit de hartruimte
          def trek_samen
            # Al het bloed wordt naar het volgende onderdeel gepompt
            verplaats_bloed(bloed.druk) if klep.open?
          end
        end

        # Boezems en kamers in het hart
        module Ruimten
          # Hartboezem
          class Boezem < Ruimte
          end

          # Hartkamer
          class Kamer < Ruimte
            # Volume van een hartkamer in mL
            HARTKAMER_VOLUME = 80 # mL

            def initialize
              super

              @volume = HARTKAMER_VOLUME
            end
          end
        end

        # Hartkleppen
        class Klep
          # Hartklep is standaard dicht
          def initialize
            @open = false
          end

          def open!
            @open = true
          end

          def sluit!
            @open = false
          end

          def open?
            @open
          end
        end
      end
    end
  end
end