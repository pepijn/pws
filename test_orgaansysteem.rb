LIB_PATH = File.dirname(__FILE__) + "/lib/lichaam/"
require LIB_PATH
require 'test/unit'

class TestOrgaansysteem < Test::Unit::TestCase
  def setup
    @org = Lichaam::Orgaansysteem.new
  end

  def test_compleetheid_van_bloedsomloop
    linker_boezem = @org.hart.linker_boezem
    opvolgers = []

    opvolger = linker_boezem.opvolger
    15.times do
      opvolgers << opvolger
      opvolger = opvolger.opvolger
    end

    assert opvolgers.include?(linker_boezem)
  end
end