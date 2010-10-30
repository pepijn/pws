module Lichaam
  # Het geheel aan organen in een lichaam
  class Orgaansysteem
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
      @hart           = Hart.new
      @aorta          = @hart.linker_kamer.verbind Slagader.new("Aorta")
      @kransslagader  = @aorta.verbind Slagader.new("Kransslagader")
      @kransader      = @hart.verbind Ader.new("Kransader")
      @holle_ader     = @kransader.verbind Ader.new("Holle ader")
      @longslagader   = @hart.rechter_kamer.verbind Slagader.new("Longslagader")
      @longen         = @longslagader.verbind Longen.new("Longen")
      @longader       = @longen.verbind Ader.new("Longader")

      # Verbind hart
      @longader.verbind @hart.linker_boezem
      @holle_ader.verbind @hart.rechter_boezem
      @kransslagader.verbind @hart
    end
  end
end