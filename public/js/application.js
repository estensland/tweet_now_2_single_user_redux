$(document).ready(function() {
  console.log("JS ready!");

  $( "#submit-button" ).click(function(event){
    event.preventDefault();

    var sayings = $("#tweet-input").val()
    $( "#tweet-input" ).prop( "disabled", true);
    $( "#tweet-input" ).animate( { borderColor: "white" });
    $.ajax({
      type: "POST",
      url: "/tweet",
      data: { message: sayings }
    }).done(function(msg) {
      console.log("done message: " + msg)
      $( "#tweet-input" ).animate( { borderColor: "#00FF00" });
      $( "#tweet-input" ).prop( "disabled", false );

      interval = setInterval(function(){timed(msg, sayings)}, 1000);
    }).fail(function(msg) {
      $( "#tweet-input" ).animate( { borderColor: "#FF0000" });
      $( "#tweet-input" ).prop( "disabled", false );
    });
  });

    var timed = function(msg, sayings) {
    return $.ajax({
      type: "GET",
      url: "/status/" + msg,
    }).done(function(twoMsg) {
      console.log("Second Message: " + twoMsg)
      if (twoMsg === "true") {
      $('.status').append('<p>' + sayings + '</p>')
      stop()
    }
    })
  }

   var stop = function(){
       console.log("hi")
       clearInterval(interval)
      }


});
