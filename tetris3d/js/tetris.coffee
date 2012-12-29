# set the scene size
WIDTH = 600
HEIGHT = 600

SPLITX = 6
SPLITY = 6
SPLITZ = 20
BLOCK_SIZE = WIDTH / SPLITX

# set some camera attributes
VIEW_ANGLE = 45
ASPECT = WIDTH / HEIGHT
NEAR = 0.1
FAR = 10000

Tetris = {}

init = ->
  # get the DOM element to attach to
  Tetris.canvas = $('#canvas')

  # create a WebGL renderer, camera and scene
  Tetris.renderer = new THREE.WebGLRenderer
  Tetris.camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR)
  Tetris.


prepareCanvas = ->
  canvas.width = WIDTH
  canvas.height = HEIGHT

  camera = new THREE.PerspectiveCamera(VIEW_ANGLE, WIDTH / HEIGHT, 1, 10000)
  camera.position.z = 300

  scene = new THREE.Scene

  cube = new THREE.Mesh(
    new THREE.CubeGeometry(50, 50, 50)
    new THREE.MeshBasicMaterial({color: 0xFF0000})
  )
  scene.add(cube)

  renderer = new THREE.CanvasRenderer(canvas)
  renderer.setSize(WIDTH, HEIGHT)
  renderer.setClearColor(0xEEEEEE, 1.0)
  renderer.clear

start = ->
  prepareCanvas()

