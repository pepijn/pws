LIB_PATH = File.dirname(__FILE__) + "/lib/lichaam/"
require LIB_PATH
require 'test/unit'

class TestOrgaansysteem < Test::Unit::TestCase
  def setup
    @orgaansysteem = Lichaam::Orgaansysteem.new
    @hart = @orgaansysteem.hart
    6.times { @hart.rechter_boezem.vaatinhoud << Lichaam::Bloed.new }
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

  def test_boezem_systole
    refute @hart.tricuspidalisklep.open?
    refute @hart.mitralisklep.open?
    refute @hart.aortaklep.open?
    refute @hart.pulmonalisklep.open?

    assert_equal 6, @hart.rechter_boezem.bloeddruk
    assert_equal 0, @hart.rechter_kamer.bloeddruk

    @hart.boezem_systole

    assert @hart.tricuspidalisklep.open?
    assert @hart.mitralisklep.open?
    refute @hart.aortaklep.open?
    refute @hart.pulmonalisklep.open?

    assert_equal 0, @hart.rechter_boezem.bloeddruk
    assert_equal 6, @hart.rechter_kamer.bloeddruk
    assert_equal 0, @orgaansysteem.longslagader.bloeddruk
  end

  def test_kamer_systole
    @hart.boezem_systole

    assert @hart.tricuspidalisklep.open?
    assert @hart.mitralisklep.open?
    refute @hart.aortaklep.open?
    refute @hart.pulmonalisklep.open?

    assert_equal 6, @hart.rechter_kamer.bloeddruk
    assert_equal 0, @orgaansysteem.longslagader.bloeddruk

    @hart.kamer_systole

    refute @hart.tricuspidalisklep.open?
    refute @hart.mitralisklep.open?
    refute @hart.aortaklep.open?
    refute @hart.pulmonalisklep.open?

    assert_equal 0, @hart.rechter_kamer.bloeddruk
    assert_in_delta 6, @orgaansysteem.longslagader.bloeddruk, 3
  end

  def test_werkende_bloedverspreiding
    @hart.boezem_systole

    assert_equal 0, @orgaansysteem.longslagader.bloeddruk
    assert_equal 0, @orgaansysteem.longen.bloeddruk
    assert_equal 0, @orgaansysteem.longader.bloeddruk

    @hart.kamer_systole

    assert_equal 3, @orgaansysteem.longslagader.bloeddruk
    assert_equal 2, @orgaansysteem.longen.bloeddruk
    assert_equal 1, @orgaansysteem.longader.bloeddruk
  end
end