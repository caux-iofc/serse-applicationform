jQuery ->

  ##### handle diet_other ####

  ## First the code that will run on document load ##
  if ($('#diet_other').is(':checked'))
    $("#diet_other_text").show()
  else
    $("#diet_other_text").hide()

  ## And then all the hooks ##
  $("#diet_other").change ->
    $("#diet_other_text").toggle()
    false
 
  ##### handle other_citizenship ####

  ## First the code that will run on document load ##
  if $('#online_application_citizenship_id').val() == '0'
    $("#online_application_other_citizenship_div").show()
  else
    $("#online_application_other_citizenship_div").hide()

  ## And then all the hooks ##
  $("#online_application_citizenship_id").change ->
    if $("#online_application_citizenship_id").val() == '0'
      $("#online_application_other_citizenship_div").show()
    else
      $("#online_application_other_citizenship_div").hide()

  ##### handle other_country ####

  ## First the code that will run on document load ##
  if $('#online_application_addresses_attributes_0_country_id').val() == '0'
    $("#other_country").show()
  else
    $("#other_country").hide()

  ## And then all the hooks ##
  $("#online_application_addresses_attributes_0_country_id").change ->
    if $("#online_application_addresses_attributes_0_country_id").val() == '0'
      $("#other_country").show()
    else
      $("#other_country").hide()
    return

  ##### handle previous visit conditional fields ####

  ## First the code that will run on document load ##
  if ($('#online_application_previous_visit_false').is(':checked'))
    $("#heard_about_div").show()
  if ($('#online_application_previous_visit_true').is(':checked'))
    $("#previous_year_div").show()

  ## And then all the hooks ##
  $('input:radio[name="online_application[previous_visit]"]').click ->
    if ($('#online_application_previous_visit_false').is(':checked'))
      $("#heard_about_div").show()
      $("#previous_year_div").hide()
    else
      $("#heard_about_div").hide()
      $("#previous_year_div").show()

  ##### fax number is compulsory in certain cases ####

  ## First the code that will run on document load ##
  if $('#online_application_confirmation_letter_via_fax').is(':checked') or $('#online_application_visa').is(':checked')
    $("#fax_required").show()
  else
    $("#fax_required").hide()

  ## And then all the hooks ##
  $('#online_application_visa').change ->
    if $('#online_application_confirmation_letter_via_fax').is(':checked') or $('#online_application_visa').is(':checked')
      $("#fax_required").show()
    else
      $("#fax_required").hide()
    if $('#online_application_visa').is(':checked')
      alert(I18n.t("ensure_fax_number"))

  $('input:radio[name="online_application[confirmation_letter_via]"]').change ->
    if $('#online_application_confirmation_letter_via_fax').is(':checked') or $('#online_application_visa').is(':checked')
      $("#fax_required").show()
    else
      $("#fax_required").hide()
    if $('#online_application_confirmation_letter_via_fax').is(':checked')
      alert(I18n.t("ensure_fax_number"))

  ##### show visa related fields if a visa is required ####

  ## First the code that will run on document load ##
  if ($('#online_application_visa').is(':checked'))
    $(".visa_required").show()
  else
    $(".visa_required").hide()

  ## And then all the hooks
  $("#online_application_visa").change ->
    $(".visa_required").toggle()
    false
  
  ##### update name badge fields when changes are made to name/country fields ####

  ## First the code that will run on document load ##
  if $("#online_application_firstname").val() != ''
    $("#online_application_badge_firstname").val($("#online_application_firstname").val())

  if $("#online_application_surname").val() != ''
    $("#online_application_badge_surname").val($("#online_application_surname").val())

  if $("#online_application_citizenship").val() != 'other' and $("#online_application_citizenship").val() != ''
    $("#online_application_badge_country").val($("#online_application_citizenship option:selected").text())

  if $("#online_application_citizenship").val() == 'other'
    $("#online_application_badge_country").val($("#online_application_other_citizenship").val())

  ## And then all the hooks ##
  $("#online_application_firstname").change ->
    $("#online_application_badge_firstname").val($("#online_application_firstname").val())

  $("#online_application_surname").change ->
    $("#online_application_badge_surname").val($("#online_application_surname").val())
 
  $("#online_application_citizenship").change ->
    if $("#online_application_citizenship").val() != 'other'
      $("#online_application_badge_country").val($("#online_application_citizenship option:selected").text())
    else
      $("#online_application_badge_country").val($("#online_application_other_citizenship").val())
 
  $("#online_application_other_citizenship").change ->
    $("#online_application_badge_country").val($("#online_application_other_citizenship").val())


