################
# Dependencies #
################

assert    = require 'assert'
connect   = require 'connect'
satellite = require '../../../src/satellite'



describe 'round-robin strategy', ->

  before (done) ->

    setupApp = =>
      @req = {}
      @res = {}
      @app = connect()
      @app.use satellite.roundRobinStrategy
      address = host: '111.11.111.111', port: 80
      satellite.store.addresses.add address, (res) -> done()

    satellite.store.addresses.get (addresses) ->
      if addresses.length is 0
        setupApp()
      else

        removeAddress = (addresses, address) ->
          satellite.store.addresses.remove address, (status) ->
            satellite.store.addresses.get (remainingAddresses) ->
              setupApp() if addresses.indexOf(address) is addresses.length - 1 and remainingAddresses.length is 0

        removeAddress addresses, address for address in addresses



  it 'should set the target address to an address in the list', (done) ->
    @app.stack[0].handle @req, @res, ->
      satellite.store.targetAddress.get (address) ->
        satellite.store.addresses.get (addresses) ->
          assert.deepEqual address, addresses[0]
          done()

  it 'should distribute the requests to each address in a sequential order', (done) ->
    satellite.addAddress host: '192.168.0.3', port: 3000, (res) =>
      
      checkAddress = (request, number) =>
        satellite.store.addresses.get (addresses) =>

          console.log addresses

          @app.stack[0].handle @req, @res, ->
            satellite.store.targetAddress.get (address) ->

              console.log number

              assert.deepEqual address, addresses[number]
              done() if request is 3 and number is 1
      
      for {request, number} in [{request: 0, number: 0},{request: 0, number: 1},{request: 1, number: 0},{request: 1, number: 1},{request: 2, number: 0},{request: 2, number: 1},{request: 3, number: 0},{request: 3, number: 1}]
        checkAddress request, number