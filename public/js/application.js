$(document).ready(function() {
  console.log("JS ready!");

  $( "#submit-button" ).click(function(event){
    event.preventDefault();

    var sayings = $("#tweet-input").val()
    console.log(sayings);
    $( "#tweet-input" ).prop( "disabled", true);
    $( "#tweet-input" ).animate( { borderColor: "white" });
    $.ajax({
      type: "POST",
      url: "/tweet",
      data: { message: sayings }
    }).done(function(msg) {
      $( "#tweet-input" ).animate( { borderColor: "#00FF00" });
      $( "#tweet-input" ).prop( "disabled", false );
    }).fail(function(msg) {
      $( "#tweet-input" ).animate( { borderColor: "#FF0000" });
      $( "#tweet-input" ).prop( "disabled", false );
    });
  });
});
