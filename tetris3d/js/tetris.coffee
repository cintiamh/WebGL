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
shapes = []

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

# Piece Shape
class Shape
  constructor: (points) ->
    @blocks = points.map ([x, y, z]) -> new Block x, y, z
    @midx = 0
    @midy = 0
    @position =
      x: 0
      y: 0
      z: 0

  draw: ->
    @blocks.forEach (b) ->
      b.draw()

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
    midx = @midx
    midy = @midy

    unless dirx == 0
      @blocks.forEach (b) ->
        temp = b.y
        b.y = (b.z - position.z) * dirx + position.y + midy
        b.z = (-(temp - position.y)) * dirx + position.z
        b.calculate_pos()

    unless diry == 0
      @blocks.forEach (b) ->
        temp = b.x
        b.x = (-(b.z - position.z)) * diry + position.x + midx
        b.z = (temp - position.x) * diry + position.z
        b.calculate_pos()

    unless dirz == 0
      @blocks.forEach (b) ->
        temp = b.x
        b.x = (-(b.y - position.y)) * dirz + position.x
        b.y = (temp - position.x) * dirz + position.y + midy
        b.calculate_pos()

# Square
shapes.push(
  new Shape [
    [0, 0, 0]
    [0, 1, 0]
    [1, 0, 0]
    [1, 1, 0]
  ]
)
shapes[0].midx = 1
shapes[0].midy = 1
# L
shapes.push(
  new Shape [
    [0, 0, 0]
    [1, 0, 0]
    [1, 1, 0]
    [1, 2, 0]
  ]
)
shapes[1].midx = 1
shapes[1].midy = 1
# Bar
shapes.push(
  new Shape [
    [0, 0, 0]
    [0, 1, 0]
    [0, 2, 0]
    [0, 3, 0]
  ]
)
shapes[2].midx = 0
shapes[2].midy = 2
# Mountain
shapes.push(
  new Shape [
    [0, 1, 0]
    [1, 0, 0]
    [1, 1, 0]
    [2, 1, 0]
  ]
)
shapes[3].midx = 2
shapes[3].midy = 1
# S
shapes.push(
  new Shape [
    [0, 0, 0]
    [1, 0, 0]
    [1, 1, 0]
    [2, 1, 0]
  ]
)
shapes[4].midx = 1
shapes[4].midy = 1

shapes[2].draw()
shapes[2].set_position(2, 2, 14)

addPoints = (n) ->
  points += n

renderer.render(scene, camera)

start_time = $.now()

animate = (t) ->

  if $.now() - start_time >= stepTime
    start_time = $.now()

    #shapes[1].move(0, 0, -1)
    #shapes[4].rotate("left")
    shapes[2].rotate(0, 0, -1)

  renderer.clear()
  renderer.render(scene, camera)
  $('#points').text(points)
  window.requestAnimationFrame(animate, renderer.domElement)

animate($.now())



