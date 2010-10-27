LIB_PATH = File.dirname(__FILE__) + "/lib/lichaam/"
require LIB_PATH
require 'test/unit'

class TestOrgaansysteem < Test::Unit::TestCase
  def setup
    @orgaansysteem = Lichaam::Orgaansysteem.new
    @hart = @orgaansysteem.hart
    @longslagader = @orgaansysteem.longslagader
    3.times { @hart.rechter_boezem.vaatinhoud << Lichaam::Bloed.new }
  end

  def test_compleetheid_van_bloedsomloop
    linker_boezem = @hart.linker_boezem
    opvolgers = []

    opvolger = linker_boezem.opvolger
    15.times do
      opvolgers << opvolger
      opvolger = opvolger.opvolger
    end

    assert opvolgers.include?(linker_boezem)
  end

  def test_werkende_diastole
    assert_equal 3, @hart.rechter_boezem.vaatinhoud.size
    assert_equal 0, @hart.rechter_kamer.vaatinhoud.size

    @hart.diastole

    assert_equal 0, @hart.rechter_boezem.vaatinhoud.size
    assert_equal 3, @hart.rechter_kamer.vaatinhoud.size
  end

  def test_werkende_systole
    @hart.diastole

    assert_equal 3, @hart.rechter_kamer.vaatinhoud.size
    assert_equal 0, @longslagader.vaatinhoud.size

    @hart.systole

    assert_equal 0, @hart.rechter_kamer.vaatinhoud.size
    assert_equal 3, @longslagader.vaatinhoud.size
  end
end