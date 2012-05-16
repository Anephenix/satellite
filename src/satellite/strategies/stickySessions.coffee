satellite = require '../../satellite.coffee'

# Used by the stick-session strategy to record which address
# handled which session
@sessions = {}

# Sets a random address in the list as the target address
setRandomTargetAddress = =>
  randomIndex    = Math.floor Math.random() * satellite.addresses.length # GETTER
  satellite.targetAddress = satellite.addresses[randomIndex] # GETTER & SETTER

# the connect middleware to distribute requests with sticky session ids
# to specific addresses
@strategy = (req, res, next) =>
  if req.headers.cookie?
    if @sessions[req.headers.cookie]? # GETTER
      satellite.targetAddress = @sessions[req.headers.cookie] #SETTER     
    else
      @sessions[req.headers.cookie] = setRandomTargetAddress() # SETTER
  else
    setRandomTargetAddress() # GETTER & SETTER
  next()