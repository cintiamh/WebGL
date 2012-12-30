# set the scene size
WIDTH = 600
HEIGHT = 600
REFRESH_RATE = 60 #ms

SPLITX = 6
SPLITY = 6
SPLITZ = 20
BLOCK_SIZE = WIDTH / SPLITX

# set some camera attributes
VIEW_ANGLE = 45
ASPECT = WIDTH / HEIGHT
NEAR = 0.1
FAR = 10000

running = false
nextUpdate = 0

# instances
board = null
cube = null

canvas = $('#container')
renderer = new THREE.WebGLRenderer
camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR)
scene = new THREE.Scene

prepareCanvas = ->
  scene.add(camera)
  camera.position.z = 300
  renderer.setSize(WIDTH, HEIGHT)
  canvas.append(renderer.domElement)

start = ->
  running = true

  animLoop = ->
    # the browser will throttle the calls to a frame rate
    requestAnimFrame ->
      animate()
      animLoop() if running

  # start the loop
  animLoop()

animate = ->
  try
    if $.now() >= nextUpdate
      update()
      render()
      nextUpdate = $.now() + REFRESH_RATE

  catch e
    running = false
    console.log e
    # Chrome's stack trace
    console.log e.stack if e.stack?

update = ->
  cube.move()

#render = ->


class Background
  constructor: (@radius, @segments, @rings) ->

  draw: ->
    sphereMaterial = new THREE.MeshLambertMaterial({color: 0xCC0000})
    @ = new THREE.Mesh(new THREE.SphereGeometry(@radius, @segments, @rings), sphereMaterial)
    scene.add(@)
