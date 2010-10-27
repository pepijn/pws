module Lichaam
  # Het geheel aan organen in een lichaam
  class Orgaansysteem
    include Onderdelen::Bloedvaten
    include Onderdelen::Organen

    attr_reader :hart, :longslagader

    # Bouw het orgaansysteem op
    def initialize
      @hart           = Hart.new
      @aorta          = @hart.linker_kamer.verbind Slagader.new
      @kransslagader  = @aorta.verbind Slagader.new
      @kransader      = @hart.verbind Ader.new
      @holle_ader     = @kransader.verbind Ader.new
      @longslagader   = @hart.rechter_kamer.verbind Slagader.new
      @longen         = @longslagader.verbind Longen.new
      @longader       = @longen.verbind Ader.new

      # Verbind hart
      @longader.verbind @hart.linker_boezem
      @holle_ader.verbind @hart.rechter_boezem
      @kransslagader.verbind @hart

      puts "Het orgaansysteem is samengesteld en de bloedvaten zijn verbonden"
    end
  end
end