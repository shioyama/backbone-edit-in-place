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


The MIT License (MIT)

Copyright (c) 2014 fet mar

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.