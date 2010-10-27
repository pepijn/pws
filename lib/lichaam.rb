LIB_PATH = File.dirname(__FILE__) + "/lichaam/"

[
  "onderdeel",

  "onderdelen/bloedvat",
  "onderdelen/bloedvaten/ader",
  "onderdelen/bloedvaten/slagader",

  "bloedcel",

  "onderdelen/orgaan",
  "onderdelen/organen/hart",
  "onderdelen/organen/longen",

  "orgaansysteem"
].each do |library|
  require LIB_PATH + library
end