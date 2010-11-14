[
  "molecuul",
  "moleculen/zuurstof"
].each do |library|
  require LIB_PATH + "omgeving/" + library
end

[
  "onderdeel",
  "onderdelen/bloedvat",
  "onderdelen/bloedvaten/ader",
  "onderdelen/bloedvaten/slagader",

  "eiwitten/hemoglobine",

  "bloed/rode_bloedcel",

  "onderdelen/orgaan",
  "onderdelen/organen/hart",
  "onderdelen/organen/longen",

  "orgaansysteem"
].each do |library|
  require LIB_PATH + "lichaam/" + library
end