backbone-edit-in-place
======================

Provides View with simple click-to-edit ability for model attributes.

[Demo](http://rawgit.com/fetmar/backbone-edit-in-place/master/demo.html)

I'm not gonna say EditView is the prettiest Backbone subclass you've ever seen, but it's simple and get's the job done. 

Motivation
----------

I needed a model editor that

  1. was dead simple
  2. was reliable
  3. saved as soon as the user was done editing
  4. didn't take up extra space on the screen

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

Todo
----

1. Add Jasmine tests
2. Refactor for clarity
3. Extend documentation
4. Allow for more types of data