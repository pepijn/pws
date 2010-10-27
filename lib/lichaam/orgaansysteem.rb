module Lichaam
  class Orgaansysteem
    include Onderdelen::Bloedvaten
    include Onderdelen::Organen

    attr_reader :hart

    def initialize
      @hart         = Hart.new
      @aorta        = @hart.linker_boezem.verbind Slagader.new
      @holle_ader   = @aorta.verbind Ader.new
      @longslagader = @hart.rechter_boezem.verbind Slagader.new
      @longen       = @longslagader.verbind Longen.new
      @longader     = @longen.verbind Ader.new

      # Verbind inputs van het hart met het hart
      @longader.verbind @hart.linker_kamer

      puts "Het orgaansysteem is samengesteld en de bloedvaten zijn verbonden"
    end
  end
end