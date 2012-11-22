$(document).ready(function() {
  $("#add_button").bind("click", function() {
    /* Generating unique id
    */
    var rand = Math.random().toString().split(".")[1];
    var input = '<input type="file" name="attachments['+rand+']" />'
    $(this).before('<br/>' + input );
  });

  /* Pushing the first input to the DOM
  */
  $("#add_button").trigger("click");

});
