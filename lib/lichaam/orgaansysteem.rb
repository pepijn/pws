module Lichaam
  # Het geheel aan organen in een lichaam
  class Orgaansysteem < Hash
    include Onderdelen::Bloedvaten
    include Onderdelen::Organen

    ONDERDELEN = [
      :hart,
      :longslagader,
      :longen,
      :longader,
      :aorta,
      :kransslagader,
      :kransader,
      :holle_ader
    ]

    attr_reader *ONDERDELEN

    # Bouw het orgaansysteem op
    def initialize
      self.merge!({
        "Hart"           => Hart.new,
        "Aorta"          => Slagader.new,
        "Kransslagader"  => Slagader.new,
        "Kransader"      => Ader.new,
        "Holle ader"     => Ader.new,
        "Longslagader"   => Slagader.new,
        "Longen"         => Longen.new,
        "Longader"       => Ader.new
      })

      # Verbind onderdelen
      self["Hart"].linker_kamer.verbind self["Aorta"]
      self["Aorta"].verbind self["Kransslagader"]
      self["Kransslagader"].verbind self["Hart"]
      self["Hart"].verbind self["Kransader"]
      self["Kransader"].verbind self["Hart"].rechter_boezem
      self["Holle ader"].verbind self["Hart"].rechter_boezem
      self["Hart"].rechter_kamer.verbind self["Longslagader"]
      self["Longslagader"].verbind self["Longen"]
      self["Longen"].verbind self["Longader"]
      self["Longader"].verbind self["Hart"].linker_boezem
    end

    # Verspreid het bloed en stuur de gegevens van het orgaansysteem
    def vernieuw!
      self.each_value do |onderdeel|
        # Zolang er een bloeddrukverschil is in de bloedvaten
        if onderdeel.bloeddruk > onderdeel.opvolger.bloeddruk
          # Kan er uitwisseling plaatsvinden?
          if !onderdeel.klep || onderdeel.klep.open?
            # Bereken het drukverschil tussen twee aneenliggende onderdelen
            drukdelta = (onderdeel.bloeddruk - onderdeel.opvolger.bloeddruk) / 5

            # Verplaats het bloed van hoge druk naar lage druk
            onderdeel.verplaats_bloed(drukdelta)
          end
        end
      end

      to_json
    end
  end
end