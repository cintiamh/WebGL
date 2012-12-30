class Block
  constructor: (@x, @y, @z) ->
    @color = 0xFF0000

  setColor: (@color) ->

  print: ->
    console.log(@x + ", " + @y + ", " + @z)
