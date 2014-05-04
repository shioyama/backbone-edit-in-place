class EditView extends Backbone.EditView

  el : "#content"

  events: $.extend
    "click button" : "onButtonClick"

  , Backbone.EditView.prototype.events

  onButtonClick: ->
    console.log "Button clicked"

  initialize: (options) ->
    @model = new Backbone.Model
      id   : "1234"
      name : "Click to edit me"
    @model.url = "test"

    @models = new Backbone.Collection [@model]

  render: ->
    @$el.html "
      #{@getEditable(@model, { key : 'name', escape : true },'Name', 'Untitled agent')}
      <button>A button</button>
    "

$ ->
  (new EditView).render()
