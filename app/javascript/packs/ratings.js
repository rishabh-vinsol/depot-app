$(document).on("ajax:success", "form", function(event) {
  var response = event.detail[0];
  if (response.success) {
    $(response.span_id).text(response.average_rating);
  } else {
    alert("Rating submission failed. Please try again.");
  }
});