size = 20
interval = 200

canvas = document.getElementById 'canvas'
ctx = canvas.getContext '2d'

class Point
  constructor: (@x, @y) ->
  @get: do ->
    repo = {}
    (x, y) -> repo[toId x, y] ?= new Point x, y

toId = (x, y) -> "#{x}, #{y}"

updateSize = ->
  {clientWidth, clientHeight} = document.documentElement
  canvas.width = clientWidth
  canvas.height = clientHeight

expand = (x, y) ->
  _.flatten ([x + i, y + j] for j in [-1..1] for i in [-1..1]), true

asPoint = ([x, y]) -> Point.get x, y

expandPoint = (p) -> expand(p.x, p.y).map asPoint

combineNeighborsOf = (list) -> _.unique _.flatten (neighborsOf p for p in list)

pointId = ({x, y}) -> toId x, y

neighborsOf = _.memoize ((point) -> _.without expandPoint(point), point), pointId

neighborsInList = (list, p) -> (_.intersection list, neighborsOf p).length

survivors = (list) ->
  list.filter (p) ->
    2 <= neighborsInList(list, p) <= 3

deadNeighbors = (list) -> _.difference combineNeighborsOf(list), list

revived = (list) ->
  deadNeighbors(list).filter (p) ->
    neighborsInList(list, p) is 3

nextGeneration = (list) -> _.union survivors(list), revived(list)

# rendering

window.requestAnimationFrame ||=
  window.webkitRequestAnimationFrame ||
  window.mozRequestAnimationFrame    ||
  window.oRequestAnimationFrame      ||
  window.msRequestAnimationFrame     ||
  (callback) -> window.setTimeout callback, 1000 / 60

clear = ->
  ctx.clearRect 0, 0, canvas.width, canvas.height

draw = (list) ->
  ctx.save()
  ctx.fillStyle = 'white'
  ctx.fillRect x * size + 1, y * size + 1, size - 2, size - 2 for {x, y} in list
  ctx.restore()

animate = (list) ->
  lst = list
  last = $.now()
  animLoop = ->
    requestAnimationFrame? animLoop
    time = $.now()
    if last + interval < time
      last = time
      clear()
      draw lst
      lst = nextGeneration lst

  animLoop()

# initialize
do ->
  window.onresize = updateSize
  updateSize()

  max_x = Math.floor canvas.width / size
  max_y = Math.floor canvas.height / size

  animate _.unique [0 ... Math.floor max_x * max_y * 0.2].map ->
    Point.get _.random(0, max_x), _.random(0, max_y)