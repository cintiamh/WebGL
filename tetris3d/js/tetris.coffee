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
block_colors = [0x0000FF, 0x3333FF, 0x6565FF, 0x9999FF, 0xB2B2FF, 0xCBCBFF, 0xE5E5FF,
  0xE5FFE5, 0xCBFFCB, 0xB2FFB2, 0x99FF99, 0x65FF65, 0x33FF33, 0x00FF00]
shapes = []
currShape = null

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
    @active = false
    @cube = null

  setColor: (color) ->
    @color = color

  draw: ->
    @active = true
    @cube = new THREE.SceneUtils.createMultiMaterialObject(
      new THREE.CubeGeometry(BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE)
      [
        new THREE.MeshBasicMaterial({color: 0xFFAA00, wireframe: true, transparent: true })
        new THREE.MeshBasicMaterial({color: @color})
      ]
    )
    @calculate_pos()
    scene.add(@cube)

  print: -> console.log(@cube.position.x + ", " + @cube.position.y + ", " + @cube.position.z)

  calculate_pos: ->
    @cube.position.x = (TABLE_WIDTH / 2 + (@x - (TABLE_WIDTH - 0.5))) * BLOCK_SIZE
    @cube.position.y = -(TABLE_HEIGHT / 2 + (@y - (TABLE_HEIGHT - 0.5))) * BLOCK_SIZE
    @cube.position.z = (@z - TABLE_DEPTH / 2 + 0.5) * BLOCK_SIZE

  erase: ->
    @active = false
    scene.remove(@cube)

# Piece Shape
class Shape
  constructor: (points) ->
    @blocks = points.map ([x, y, z]) -> new Block x, y, z
    @position =
      x: 0
      y: 0
      z: 0

  draw: ->
    @blocks.forEach (b) ->
      b.draw()

  erase: ->
    @blocks.forEach (b) ->
      b.erase()

  move: (diffx, diffy, diffz) ->
    @blocks.forEach (b) ->
      b.x += diffx
      b.y += diffy
      b.z += diffz
      b.calculate_pos()

  set_position: (posx, posy, posz) ->
    @position.x = posx
    @position.y = posy
    @position.z = posz
    @blocks.forEach (b) ->
      b.x += posx
      b.y += posy
      b.z += posz
      b.calculate_pos()

  rotate: (dirx, diry, dirz) ->
    position = @position
    unless dirx == 0
      @blocks.forEach (b) ->
        temp = b.y
        b.y = (-(b.z - position.z)) * dirx + position.y
        b.z = (temp - position.y) * dirx + position.z
        b.calculate_pos()

    unless diry == 0
      @blocks.forEach (b) ->
        temp = b.x
        b.x = (b.z - position.z) * diry + position.x
        b.z = (-(temp - position.x)) * diry + position.z
        b.calculate_pos()

    unless dirz == 0
      @blocks.forEach (b) ->
        temp = b.x
        b.x = (-(b.y - position.y)) * dirz + position.x
        b.y = (temp - position.x) * dirz + position.y
        b.calculate_pos()

  check_col: ->
    reboot = false
    @blocks.forEach (b) ->
      # check if reached a static block

      # check if reached the minimum level
      if b.z <= 0
        reboot = true
    if reboot
      instantiate_shape()
      @erase()
    @move(0, 0, -1)

instantiate_shape = ->
  index = Math.floor(Math.random() * 5)
  currShape = shapes[index]
  currShape.draw()
  currShape.set_position(Math.floor(TABLE_WIDTH/2), Math.floor(TABLE_HEIGHT/2), MAX_DEPTH)

check_shape_pos = ->
  currShape.check_col()

addPoints = (n) ->
  points += n

add_static_block = (x, y, z) ->
  block = new Block x, y, z
  block.setColor(block_colors[z])
  block.draw()
  staticBlocks.push(block)

renderer.render(scene, camera)

# Tetris pieces shapes
# Square
shapes.push(
  new Shape [
    [-1, -1, 0]
    [-1, 0, 0]
    [0, -1, 0]
    [0, 0, 0]
  ]
)
# L
shapes.push(
  new Shape [
    [-1, -1, 0]
    [0, -1, 0]
    [0, 0, 0]
    [0, 1, 0]
  ]
)
# Bar
shapes.push(
  new Shape [
    [0, -2, 0]
    [0, -1, 0]
    [0, 0, 0]
    [0, 1, 0]
  ]
)
# Mountain
shapes.push(
  new Shape [
    [-1, 0, 0]
    [0, -1, 0]
    [0, 0, 0]
    [1, 0, 0]
  ]
)
# S
shapes.push(
  new Shape [
    [-2, -1, 0]
    [-1, -1, 0]
    [-1, 0, 0]
    [0, 0, 0]
  ]
)

start_time = $.now()
instantiate_shape()

animate = (t) ->

  if $.now() - start_time >= stepTime
    start_time = $.now()
    check_shape_pos()

  renderer.clear()
  renderer.render(scene, camera)
  $('#points').text(points)
  window.requestAnimationFrame(animate, renderer.domElement)

animate($.now())



