backbone-edit-in-place
======================

Provides view with simple click to edit for model attributes

I'm not gonna say EditView is the prettiest Backbone subclass you've ever seen, but it's simple and get's the job done. 

Install
-------

        ... Backbone.js includes ...
        <script src='backbone-edit-in-place.js'></script>
        ... your app includes ...
        
Usage
-----

        class EditorView extends Backbone.EditView

          events: $.extend
    		    "click .somewhere" : "doSomething"
		  , Backbone.EditView.prototype.events

          doSomething: ->
            console.log "that thing was clicked"

          render: ->
          @$el.html "
            #{@getEditable(@model, { key : 'name', escape : true },'Name', 'Untitled agent')}
            <button>A button</button>
          "

This is an incomplete example meant to show two things

  1. The getEditable function.
  2. How events get extended.

Please see the demo for a working version.