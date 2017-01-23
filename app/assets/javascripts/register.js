function setRegisterFields() {
  var $value = $('input[name="record[type]"]:checked, input[name="amount_record[type]"]:checked, input[name="time_record[type]"]:checked').val();

  if ($value == 'TimeRecord') {
    $('.amount_record_field').hide();
    $('.time_record_field').show();
  } else if ($value == 'AmountRecord') {
    $('.time_record_field').hide();
    $('.amount_record_field').show();
  } else {
    $('.amount_record_field').hide();
    $('.time_record_field').hide();
  }
}

document.addEventListener("turbolinks:load", function() {
  setRegisterFields();
  $('input[name="record[type]"], input[name="amount_record[type]"], input[name="time_record[type]"]').change(function(){
    setRegisterFields();
  });
});
