# Initialization
# set the scene size
WIDTH = 600
HEIGHT = 600
REFRESH_RATE = 60 #ms

# bounding box measures
TABLE_WIDTH = 6
TABLE_HEIGHT = 6
TABLE_DEPTH = 20
MAX_DEPTH = 14
BLOCK_SIZE = WIDTH / TABLE_WIDTH

# set some camera attributes
VIEW_ANGLE = 45
ASPECT = WIDTH / HEIGHT
NEAR = 0.1
FAR = 10000

# game's values
stepTime = 1000
points = 0

staticBlocks = []

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

# Classes
# Block class
class Block
  constructor: (@x, @y, @z) ->
    @color = 0xFF0000
    @active = true
    @cube = null

  setColor: (color) ->
    @color = color

  draw: ->
    if @active
      @active = true
      @cube = new THREE.Mesh(
        new THREE.CubeGeometry(BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE)
        new THREE.MeshBasicMaterial({color: @color})
      )
      @calculate_pos()
      scene.add(@cube)

  print: -> console.log(@cube.position.x + ", " + @cube.position.y + ", " + @cube.position.z)

  calculate_pos: ->
    @cube.position.x = (TABLE_WIDTH / 2 + (@x - (TABLE_WIDTH - 0.5))) * BLOCK_SIZE
    @cube.position.y = -(TABLE_HEIGHT / 2 + (@y - (TABLE_HEIGHT - 0.5))) * BLOCK_SIZE
    @cube.position.z = (@z - TABLE_DEPTH / 2 + 0.5) * BLOCK_SIZE

# Piece Shape
class Shape
  constructor: (points) ->
    @blocks = points.map ([x, y, z]) -> new Block x, y, z
    @position = {x: 0, y: 0, z: 0}
    @width = 0
    @height = 0

  draw: ->
    @blocks.forEach (b) ->
      b.draw()

  set_size: (@width, @height) ->

  set_position: (x, y, z) ->
    @blocks.forEach (b) ->
      b.x += x
      b.y += y
      b.z += z
      b.calculate_pos()

  #move: ->
  #  @blocks.forEach (b) ->
  #    b.set_position(@position.x, @position.y, @position.z)

square_shape = new Shape [
  [0, 0, 0]
  [0, 1, 0]
  [1, 0, 0]
  [1, 1, 0]
]

l_shape = new Shape [
  [0, 0, 0]
  [1, 0, 0]
  [1, 1, 0]
  [1, 2, 0]
]

bar_shape = new Shape [
  [0, 0, 0]
  [0, 1, 0]
  [0, 2, 0]
  [0, 3, 0]
]

mountain_shape = new Shape [
  [0, 1, 0]
  [1, 0, 0]
  [1, 1, 0]
  [2, 1, 0]
]

s_shape = new Shape [
  [0, 0, 0]
  [1, 0, 0]
  [1, 1, 0]
  [2, 1, 0]
]

#mountain_shape.move()
#mountain_shape.draw()
#mountain_shape.set_size 3, 2
cube = new Block 0, 0, 0
cube.draw()

addPoints = (n) ->
  points += n

renderer.render(scene, camera)

start_time = $.now()

animate = (t) ->

  #camera.position.x = Math.sin(t/1000) * 300;
  #camera.position.y = 150;
  #camera.position.z = Math.cos(t/1000) * 300;

  #camera.lookAt(scene.position);

  if $.now() - start_time >= stepTime
    start_time = $.now()
    cube.z += 1
    console.log(cube.z)
    cube.calculate_pos()

    #cube.draw()


  renderer.clear()
  renderer.render(scene, camera)
  $('#points').text(points)
  window.requestAnimationFrame(animate, renderer.domElement)

animate($.now())



