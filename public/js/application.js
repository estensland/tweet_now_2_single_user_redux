$(document).ready(function() {
  console.log("JS ready!");

  $( "#submit-button" ).click(function(event){
    event.preventDefault();

    var sayings = $("#tweet-input").val()
    console.log(sayings);
    $( "#tweet-input" ).prop( "disabled", true);
    $( "#tweet-input" ).animate( { backgroundColor: "yellow" });
    $.ajax({
      type: "POST",
      url: "/tweet",
      data: { message: sayings }
    }).done(function(msg) {
      $( "#tweet-input" ).animate( { backgroundColor: "#7CFC00" });
      $( "#tweet-input" ).prop( "disabled", false );
    }).fail(function(msg) {
      $( "#tweet-input" ).animate( { backgroundColor: "#DB7093" });
      $( "#tweet-input" ).prop( "disabled", false );
    });
  });
});
