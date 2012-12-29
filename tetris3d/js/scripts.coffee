Tetris = {}

Tetris.gameStepTime = 1000

Tetris.frameTime = 0
Tetris.cumulatedFramTime = 0
Tetris._lastFrameTime = Date.now()

Tetris.gameOver = false

Tetris.init = ->
  # set the scene size
  WIDTH = window.innerWidth
  HEIGHT = window.innerHeight

  # set some came attributes
  VIEW_ANGLE = 45
  ASPECT = WIDTH / HEIGHT
  NEAR = 0.1
  FAR = 10000

  # create a WebGL renderer, camera and a scene
  Tetris.renderer = new THREE.WebGLRenderer
  Tetris.camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR)
  Tetris.scene = new THREE.Scene

  # The camera starts at 0,0,0 so pull it back
  Tetris.camera.position.z = 600
  Tetris.scene.add(Tetris.camera)

  # start the renderer
  Tetris.renderer.setSize(WIDTH, HEIGHT)

  # attach the render-supplied DOM element
  document.body.appendChild(Tetris.renderer.domElement)

  # configuration object
  boundingBoxConfig = {
    width: 360
    height: 360
    depth: 1200
    splitX: 6
    splitY: 6
    splitZ: 20
  }

  Tetris.boundingBoxConfig = boundingBoxConfig
  Tetris.blockSize = boundingBoxConfig.width / boundingBoxConfig.splitX

  boundingBox = new THREE.Mesh(
    new THREE.CubeGeometry(
      boundingBoxConfig.width
      boundingBoxConfig.height
      boundingBoxConfig.depth
      boundingBoxConfig.splitX
      boundingBoxConfig.splitY
      boundingBoxConfig.splitZ
    )
    new THREE.MeshBasicMaterial({color: 0xFFAA00, wireframe: true})
  )
  Tetris.scene.add(boundingBox)

  # first render
  Tetris.renderer.render(Tetris.scene, Tetris.camera)

  Tetris.stats = new Stats()
  Tetris.stats.domElement.style.position = 'absolute'
  Tetris.stats.domElement.style.top = '10px'
  Tetris.stats.domElement.style.left = '10px'
  document.body.appendChild(Tetris.stats.domElement)

  document.getElementById("play_button").addEventListener('click', (event)->
    event.preventDefault()
    Tetris.start
  )

Tetris.start = ->
  document.getElementById("menu").style.display = "none"
  Tetris.pointsDOM = document.getElementById("points")
  Tetris.pointsDOM.style.display = "block"
  Tetris.animate

Tetris.animate = ->
  time = Date.now()
  Tetris.frameTime = time - Tetris._lastFrameTime
  Tetris._lastFrameTime = time
  Tetris.cumulatedFramTime += Tetris.frameTime

  while Tetris.cumulatedFramTime > Tetris.gameStepTime
    Tetris.cumulatedFramTime -= Tetris.gameStepTime

  Tetris.renderer.render(Tetris.scene, Tetris.camera)
  Tetris.stats.update()

  if !Tetris.gameOver
    window.requestAnimationFrame(Tetris.animate)