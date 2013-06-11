/*
  jQuery's document.ready/$(function(){}) should
  you wish to use a cross-browser DOMReady solution
  without opting for a library.

  usage:
  $(function(){
    // your code
  })

  Parts: jQuery project, Diego Perini, Lucent M.
  This version: Addy Osmani
*/
(function(window) {
  "use strict"

  // Define a local copy of $
  var $ = function(callback) {
      readyBound = false
      $.isReady = false
      if (typeof callback === "function") {
        DOMReadyCallback = callback
      }
      bindReady()
    },

    // Use the correct document accordingly with window argument (sandbox)
    document = window.document,
    readyBound = false,
    DOMReadyCallback = function() {},

    // The ready event handler
    DOMContentLoaded = function() {
      if (document.addEventListener) {
          document.removeEventListener("DOMContentLoaded", DOMContentLoaded, false)
      } else {
          // we're here because readyState !== "loading" in oldIE
          // which is good enough for us to call the dom ready!
          document.detachEvent("onreadystatechange", DOMContentLoaded)
      }
      DOMReady()
    },

    // Handle when the DOM is ready
    DOMReady = function() {
      // Make sure that the DOM is not already loaded
      if (!$.isReady) {
        // Make sure body exists, at least, in case IE gets a little overzealous (ticket #5443).
        if (!document.body) { return setTimeout(DOMReady, 1) }
        // Remember that the DOM is ready
        $.isReady = true
        // If there are functions bound, to execute
        DOMReadyCallback()
        // Execute all of them
      }
    }, // /ready()

    bindReady = function() {
      var toplevel = false

      if (readyBound) { return }
      readyBound = true

      // Catch cases where $ is called after the
      // browser event has already occurred.
      if (document.readyState !== "loading") {
        DOMReady()
      }

      // Mozilla, Opera and webkit nightlies currently support this event
      if (document.addEventListener) {
        // Use the handy event callback
        document.addEventListener("DOMContentLoaded", DOMContentLoaded, false)
        // A fallback to window.onload, that will always work
        window.addEventListener("load", DOMContentLoaded, false)
        // If IE event model is used
      } else if (document.attachEvent) {
        // ensure firing before onload,
        // maybe late but safe also for iframes
        document.attachEvent("onreadystatechange", DOMContentLoaded)
        // A fallback to window.onload, that will always work
        window.attachEvent("onload", DOMContentLoaded)
        // If IE and not a frame
        // continually check to see if the document is ready
        try {
          toplevel = window.frameElement == null
        } catch (e) { }
        if (document.documentElement.doScroll && toplevel) {
          doScrollCheck()
        }
      }
    },

    // The DOM ready check for Internet Explorer
    doScrollCheck = function() {
      if ($.isReady) { return }
      try {
        // If IE is used, use the trick by Diego Perini
        // http://javascript.nwbox.com/IEContentLoaded/
        document.documentElement.doScroll("left")
      } catch (error) {
        setTimeout(doScrollCheck, 1)
        return
      }
      // and execute any waiting functions
      DOMReady()
    }

  // Is the DOM ready to be used? Set to true once it occurs.
  $.isReady = false

  // Expose $ to the global object
  window.$ = $

})(window)

Rubulex = {

}

Rubulex.queryRegex = function(e) {
  if (this.inputTimeout) {
    window.clearTimeout(this.inputTimeout)
    this.inputTimeout = null
  }
  if (Rubulex.regexInput.value !== "" && Rubulex.testData.value !== "") {
    this.inputTimeout = window.setTimeout(function() {
      var form = document.getElementById("editor_form")
      var formData = new FormData(form)
      var xhr = new XMLHttpRequest()
      xhr.open('POST', form.action, true)
      xhr.onload = function(e) {
        var json_response = JSON.parse(xhr.responseText)
        Rubulex.result.innerHTML = json_response.match_result 
        if (json_response.match_groups !== null) {
          Rubulex.result_group_container.style.display = "block"
          Rubulex.result_groups.innerHTML = json_response.match_groups
        } else {
          Rubulex.result_group_container.style.display = "none"
        }
      }

      xhr.send(formData)
      return false // Prevent page from submitting.
    }, 750)
  }
}

$(function() {
  Rubulex.regexInput = document.getElementById("regex")
  Rubulex.regexOptionsInput = document.getElementById("regex_options")
  Rubulex.testData = document.getElementById("test_data")
  Rubulex.result = document.getElementById("result")
  Rubulex.result_group_container = document.getElementsByClassName("result_groups")[0]
  Rubulex.result_groups = document.getElementById("result_groups")
  var elements = [
    Rubulex.regexInput,
    Rubulex.regexOptionsInput,
    Rubulex.testData
  ]

  for (var i = 0; i < elements.length; i++) {
    elements[i].addEventListener('input', Rubulex.queryRegex, false)
  }
})
