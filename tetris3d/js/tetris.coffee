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

staticBlocks = []

canvas = $('#canvas')
renderer = new THREE.WebGLRenderer
camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR)
scene = new THREE.Scene

scene.add(camera)
camera.position.z = TABLE_DEPTH * BLOCK_SIZE / 2 + 225
renderer.setSize(WIDTH, HEIGHT)
canvas.append(renderer.domElement)

class Block
  constructor: (@x, @y, @z) ->
    @color = 0xFF0000
    @active = false
    @position = {}
    @position.x = (TABLE_WIDTH / 2 + (@x - (TABLE_WIDTH - 0.5))) * BLOCK_SIZE
    @position.y = -(TABLE_HEIGHT / 2 + (@y - (TABLE_HEIGHT - 0.5))) * BLOCK_SIZE
    @position.z = (@z - TABLE_DEPTH / 2 + 0.5) * BLOCK_SIZE

  setColor: (color) ->
    @color = color

  draw: ->
    if !@active
      @active = true
      cube = new THREE.Mesh(
        new THREE.CubeGeometry(BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE)
        new THREE.MeshBasicMaterial({color: @color})
      )
      cube.position.x = @position.x
      cube.position.y = @position.y
      cube.position.z = @position.z
      scene.add(cube)

  print: ->
    console.log(@position.x + ", " + @position.y + ", " + @position.z)

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

block = new Block(0, 0, 0)
block.print()
block.draw()

block2 = new Block(5, 5, 0)
block2.setColor(0x00FF00)
block2.draw()

renderer.render(scene, camera)


animate = (t) ->

  #camera.position.x = Math.sin(t/1000) * 300;
  #camera.position.y = 150;
  #camera.position.z = Math.cos(t/1000) * 300;

  #camera.lookAt(scene.position);

  renderer.render(scene, camera)
  window.requestAnimationFrame(animate, renderer.domElement)

animate($.now())



