################
# Dependencies #
################

{print}       = require 'util'
{spawn, exec} = require 'child_process'
mocha         = require 'mocha'



# Compiles the CoffeeScript files into JS files
#
# @param  watch       Boolean     Determines whether to recompile those files if they change
# @param  callback    Function    An optional function to execute once finished
#
build = (watch, callback) ->
  if typeof watch is 'function'
    callback = watch
    watch = false
  options = ['-c', '-o', 'lib', 'src']
  options.unshift '-w' if watch

  coffee = spawn 'coffee', options
  coffee.stdout.on 'data', (data) -> print data.toString()
  coffee.stderr.on 'data', (data) -> print data.toString()
  coffee.on 'exit', (status) -> callback?() if status is 0



# The list of files that we want to document and compile into JS
#
files = [
  'satellite.coffee'
  'satellite/strategies/roundRobin.coffee'
  'satellite/strategies/stickySession.coffee'
  'satellite/stores/default.coffee'
  'satellite/stores/redis.coffee'
]



# Builds the documentation for those files, using Docco
#
buildDocs = () ->
  for file in files
    exec "node_modules/docco/bin/docco src/#{file}",
      (err, stdout, stderr) ->
        print stdout if stdout?
        print stderr if stderr?



#########
# Tasks #
#########

task 'build', 'Compiles source files in src directory, and outputs to the lib directory', build

task 'docs', 'Generates docs for all the source files', buildDocs

task 'watch', 'Recompile CoffeeScript source files when modified', -> build true