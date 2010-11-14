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

      # Maak een connectie met de hartboezems en kamers
      self["Linkerkamer"]   = self["Hart"].linker_kamer
      self["Linkerboezem"]  = self["Hart"].linker_boezem
      self["Rechterkamer"]  = self["Hart"].rechter_kamer
      self["Rechterboezem"] = self["Hart"].rechter_boezem

      # Verbind onderdelen
      self["Linkerkamer"].verbind self["Aorta"]
      self["Aorta"].verbind self["Kransslagader"]
      self["Kransslagader"].verbind self["Hart"]
      self["Hart"].verbind self["Kransader"]
      self["Kransader"].verbind self["Rechterboezem"]
      self["Holle ader"].verbind self["Rechterboezem"]
      self["Rechterkamer"].verbind self["Longslagader"]
      self["Longslagader"].verbind self["Longen"]
      self["Longen"].verbind self["Longader"]
      self["Longader"].verbind self["Linkerboezem"]
    end

    # Verspreid het bloed en stuur de gegevens van het orgaansysteem
    def vernieuw!
      self.each_value do |onderdeel|
        onderdeel.vernieuw!
      end

      to_json
    end
  end
end