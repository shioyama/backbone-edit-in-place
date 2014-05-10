class Backbone.EditView extends Backbone.View

  events :
    "click .edit_in_place" : "editInPlace"
    "focusout .editing"    : "editing"
    "keyup    .editing"    : "editing"
    "keydown  .editing"    : "editing"
    "change   select"     : "onSelect"

  onSelect: (event) ->
    $target = $(event.target)
    return unless $target.attr("data-EditView") is "true"
    modelId = $target.attr('data-model-id')
    model = @models.get(modelId)
    key = $target.attr('data-key')
    value = $target.val()
    newObject = {}
    newObject[key] = value
    model.save(newObject)

  getEditable: (model, prop, name="Value", defaultValue = "none", prep) =>

    @preps                     = {} unless @preps?
    @preps[model.id]           = {} unless @preps[model.id]?
    @preps[model.id][prop.key] = prep

    @htmlGenCatelog = {} unless @htmlGenCatelog?
    @htmlGenCatelog[model.id] = {} unless @htmlGenCatelog[model.id]?
    @htmlGenCatelog[model.id][prop.key] = htmlFunction = do (model, prop, name, defaultValue) -> 
      -> 

        key    = prop.key
        escape = prop.escape
        type   = prop.type || ''

        # cook the value
        value = if model.has(key) then model.get(key) else defaultValue
        value = defaultValue if value is ''

        value = value.join(", ") if prop.isArray and value? and value isnt defaultValue
          
        value = _(value).escape() if escape
        untitled = " data-untitled='true' " if value is defaultValue

        # what is it
        editOrNot   = if prop.editable then "class='edit_in_place'" else ""
        numberOrNot = if _.isNumber(value) then "data-is-number='true'" else "data-is-number='false'" 
        isArray = "data-is-array='true'" if prop.isArray

        if prop.choices?
          uid = Math.floor(Math.random()*1e20).toString(16)
          optionsHtml  = ''
          alreadyFound = false
          for choice in prop.choices
            if value is choice.value and not alreadyFound
              alreadyFound = true
              selected = "selected='selected'" 
            else 
              selected = ""
            optionsHtml += "<option value='#{choice.value}' #{selected}>#{choice.label}</option>"
          
          promptSelect = "selected='selected'" unless alreadyFound
          optionsHtml = "<option disabled='disabled' #{promptSelect || ''}>Please select</option>" + optionsHtml
          result = "<select data-EditView='true' data-model-id='#{model.id}' data-key='#{key}'>#{optionsHtml}</select>"
        else

          result = "<div class='edit_in_place #{key}-edit-in-place' id='#{model.id}-#{key}'><span data-model-id='#{model.id}' data-type='#{type}' data-key='#{key}' data-value='#{value}' data-name='#{name}' #{editOrNot} #{numberOrNot} #{isArray||''} #{untitled||''}>#{value}</span></div>"

        return result

    return htmlFunction()


  editInPlace: (event) =>

    return if @alreadyEditing
    @alreadyEditing = true

    # save state
    # replace with text area
    # on save, save and re-replace
    $span = $(event.target)
    if $span[0].tagName is "DIV" # catch an accidental click on the div
      $span = $span.find("span")

    $parent  = $span.parent()

    return if $span.hasClass("editing")

    uid     = Math.floor(Math.random()*1e20).toString(16)

    key      = $span.attr("data-key")
    name     = $span.attr("data-name")
    type     = $span.attr("data-type")
    isNumber = $span.attr("data-is-number") is "true"
    isArray  = $span.attr("data-is-array") is "true"

    console.log @models
    modelId  = $span.attr("data-model-id")
    model    = @models.get(modelId)

    oldValue = model.get(key) || ""
    oldValue = "" if $span.attr("data-untitled") == "true"

    $target = $(event.target)
    classes = ($target.attr("class") || "").replace("settings","")
    margins = $target.css("margin")

    transferVariables = "data-is-number='#{isNumber}' data-is-array='#{isArray}' data-key='#{key}' data-model-id='#{modelId}' "

    # sets width/height with style attribute
    rows = parseInt(Math.max(String(oldValue.length) / 30, 1))
    $parent.html("<textarea placeholder='#{name}' id='#{uid}' rows='#{rows}' #{transferVariables} class='editing #{classes} #{key}-editing' style='margin:#{margins}' data-name='#{name}'>#{oldValue}</textarea>")
    # style='width:#{oldWidth}px; height: #{oldHeight}px;'
    $textarea = $("##{uid}")
    $textarea.select()

  editing: (event) =>

    return false if event.which == 13 and event.type == "keyup"

    $target = $(event.target)

    $parent = $target.parent()

    key        = $target.attr("data-key")
    isNumber   = $target.attr("data-is-number") == "true"
    isArray    = $target.attr("data-is-array") == "true"

    modelId    = $target.attr("data-model-id")
    name       = $target.attr("data-name")

    model      = @models.get(modelId)
    oldValue   = model.get(key)

    newValue = $target.val()
    newValue = if isNumber then parseInt(newValue) else newValue
    newValue = if isArray  then newValue.toLowerCase().replace(/[^a-z0-9, ]/,'').split(/\s?,\s?/) else newValue


    if event.which == 27 or event.type == "focusout"
      @$el.find("##{modelId}-#{key}").html @htmlGenCatelog[modelId][key]?()
      @alreadyEditing = false
      return

    # act normal, unless it's an enter key on keydown
    keyDown = event.type is "keydown"
    enter   = event.which is 13
    altKey  = event.altKey

    $target.val($target.val().slice(0,-2) + ", ") if $target.val().slice(-2) is "  " and isArray

    return true if enter and altKey
    return true unless enter and keyDown

    @alreadyEditing = false

    # If there was a change, save it
    if String(newValue) isnt String(oldValue)
      newValue = _(newValue).compact() if isArray
      attributes = {}
      attributes[key] = newValue
      if @preps?[modelId]?[key]?
        try
          attributes[key+"-cooked"] = @preps[modelId][key](newValue)
        catch e
          console.error("Problem cooking value<br>#{e.message}")
          return

      model.save attributes,
        success: =>
          model.trigger "status", "#{name} saved"
          @$el.find("##{modelId}-#{key}").html @htmlGenCatelog[modelId][key]?()
        error: =>
          alert "Please try to save again, it didn't work that time."
          @render()
    else
      @$el.find("##{modelId}-#{key}").html @htmlGenCatelog[modelId][key]?()

    # this ensures we do not insert a newline character when we press enter
    return false

