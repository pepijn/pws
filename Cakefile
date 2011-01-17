fs     = require 'fs'
{exec} = require 'child_process'

task 'build', 'Build project from src/*.coffee to lib/*.js', ->
  exec 'coffee --bare -o lib/ -c src/', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr