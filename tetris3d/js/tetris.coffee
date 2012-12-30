# set the scene size
WIDTH = 600
HEIGHT = 600
REFRESH_RATE = 60 #ms

# bounding box measures
TABLE_WIDTH = 6
TABLE_HEIGHT = 6
TABLE_DEPTH = 20
BLOCK_SIZE = WIDTH / TABLE_WIDTH

# set some camera attributes
VIEW_ANGLE = 45
ASPECT = WIDTH / HEIGHT
NEAR = 0.1
FAR = 10000

# game's values
stepTime = 1000
points = 0

canvas = $('#canvas')
renderer = new THREE.WebGLRenderer
camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR)
scene = new THREE.Scene

scene.add(camera)
camera.position.z = TABLE_DEPTH * BLOCK_SIZE / 2 + 225
renderer.setSize(WIDTH, HEIGHT)
canvas.append(renderer.domElement)

boundingBox = new THREE.Mesh(
  new THREE.CubeGeometry(
    TABLE_WIDTH * BLOCK_SIZE
    TABLE_HEIGHT * BLOCK_SIZE
    TABLE_DEPTH * BLOCK_SIZE
    TABLE_WIDTH
    TABLE_HEIGHT
    TABLE_DEPTH),
  new THREE.MeshBasicMaterial({color: 0xFFAA00, wireframe: true})
)
scene.add(boundingBox)

cube = new THREE.Mesh(
  new THREE.CubeGeometry(BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE)
  new THREE.MeshBasicMaterial({color: 0xFF0000})
)
cube.position.z = - TABLE_DEPTH * BLOCK_SIZE / 2
cube.position.x = BLOCK_SIZE / 2
cube.position.y = BLOCK_SIZE / 2
scene.add(cube)

renderer.render(scene, camera)

staticBlocks = []
zColors = [
  0x6666ff, 0x66ffff, 0xcc68EE, 0x666633, 0x66ff66, 0x9966ff, 0x00ff66, 0x66EE33, 0x003399, 0x330099,
  0xFFA500, 0x99ff00, 0xee1289, 0x71C671, 0x00BFFF, 0x666633, 0x669966, 0x9966ff
]

addStaticBlock = (x, y, z) ->
  if staticBlocks[x] == undefined
    staticBlocks[x] = []
  if staticBlocks[x][y] == undefined
    staticBlocks[x][y] = []



animate = (t) ->

  #camera.position.x = Math.sin(t/1000) * 300;
  #camera.position.y = 150;
  #camera.position.z = Math.cos(t/1000) * 300;

  #camera.lookAt(scene.position);

  renderer.render(scene, camera)
  window.requestAnimationFrame(animate, renderer.domElement)

animate($.now())



