fs        = require 'fs'

File      = require './psd/file.coffee'
Header    = require './psd/header.coffee'
Resources = require './psd/resources.coffee'
LayerMask = require './psd/layer_mask.coffee'
Image     = require './psd/image.coffee'

module.exports = class PSD
  @fromFile: (file) -> new PSD fs.readFileSync(file)

  constructor: (data) ->
    @file = new File(data)
    @parsed = false
    @header = null

  parse: ->
    return if @parsed

    @parseHeader()
    @parseResources()
    @parseLayerMask()
    @parseImage()

    @parsed = true

  parseHeader: ->
    @header = new Header(@file)
    @header.parse()

  parseResources: ->
    @resources = new Resources(@file)
    @resources.parse()

  parseLayerMask: ->
    @layerMask = new LayerMask(@file, @header)
    @layerMask.parse()

  parseImage: ->
    @image = new Image(@file, @header)
    @image.parse()