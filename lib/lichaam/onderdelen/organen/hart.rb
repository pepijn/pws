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
          # Open kleppen van boezems naar kamers
          [tricuspidalisklep, mitralisklep].each {|klep| klep.open! }

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
        end

        def boezem_diasystole
        end

        def kamer_diasystole
        end

        # Gemeenschappelijk gedrag voor boezems en kamers
        class Ruimte < Onderdeel
          # Pomp het bloed uit de hartruimte
          def trek_samen
            # Al het bloed wordt naar het volgende onderdeel gepompt
            verplaats_bloed(bloeddruk) if klep.open?

            # Begin bij de opvolger van de hartruimte die zojuist heeft gepompt
            huidig = opvolger

            # Zolang er een bloeddrukverschil is in de bloedvaten
            while huidig.bloeddruk > huidig.opvolger.bloeddruk do
              # Kan er uitwisseling plaatsvinden?
              if !huidig.klep || huidig.klep.open?
                # Bereken het drukverschil tussen twee aneenliggende onderdelen
                drukdelta = (huidig.bloeddruk - huidig.opvolger.bloeddruk) / 2

                # Verplaats het bloed van hoge druk naar lage druk
                huidig.verplaats_bloed(drukdelta)
              end

              # Verder naar het volgende onderdeel
              huidig = huidig.opvolger
            end
          end
        end

        # Boezems en kamers in het hart
        module Ruimten
          # Hartboezem
          class Boezem < Ruimte
          end

          # Hartkamer
          class Kamer < Ruimte
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