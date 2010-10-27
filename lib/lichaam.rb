[
  "onderdeel",

  "onderdelen/bloedvat",
  "onderdelen/bloedvaten/ader",
  "onderdelen/bloedvaten/slagader",

  "bloed",

  "onderdelen/orgaan",
  "onderdelen/organen/hart",
  "onderdelen/organen/longen",

  "orgaansysteem"
].each do |library|
  require LIB_PATH + library
end