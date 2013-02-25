jQuery ->

  ## Default the year of arrival/departure to the current year
  dt = new Date(); 
  if ($('#online_application_arrival_1i').val() == '')
    $("#online_application_arrival_1i").val(dt.getYear()+1900)
  if ($('#online_application_departure_1i').val() == '')
    $("#online_application_departure_1i").val(dt.getYear()+1900)

  ##### handle diet_other ####

  ## First the code that will run on document load ##
  if ($('#diet_check_other').is(':checked'))
    $("#diet_other_text").show()
  else
    $("#diet_other_text").hide()

  ## And then all the hooks ##
  $("#diet_check_other").change ->
    $("#diet_other_text").toggle()
    false
 
  ##### handle ramadan ####

  ## First the code that will run on document load ##
  if ($('#diet_check_halal').is(':checked'))
    $("#ramadan").show()
  else
    $("#ramadan").hide()

  ## And then the hook ##
  $("#diet_check_halal").change ->
    $("#ramadan").toggle()
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

  ##### handle permanent_address_other_country ####

  ## First the code that will run on document load ##
  if $('#online_application_permanent_address_attributes_country_id').val() == '0'
    $("#permanent_address_other_country").show()
  else
    $("#permanent_address_other_country").hide()

  ## And then all the hooks ##
  $("#online_application_permanent_address_attributes_country_id").change ->
    if $("#online_application_permanent_address_attributes_country_id").val() == '0'
      $("#permanent_address_other_country").show()
    else
      $("#permanent_address_other_country").hide()
    return

  ##### handle correspondence_address_other_country ####

  ## First the code that will run on document load ##
  if $('#online_application_correspondence_address_attributes_country_id').val() == '0'
    $("#correspondence_address_other_country").show()
  else
    $("#correspondence_address_other_country").hide()

  ## And then all the hooks ##
  $("#online_application_correspondence_address_attributes_country_id").change ->
    if $("#online_application_correspondence_address_attributes_country_id").val() == '0'
      $("#correspondence_address_other_country").show()
    else
      $("#correspondence_address_other_country").hide()
    return

  ##### handle day_visitor choice #####

  ## First the code that will run on document load ##
  if $('#online_application_day_visit_false').is(':checked')
    $("#online_application_departure_1i").removeAttr("disabled")
    $("#online_application_departure_2i").removeAttr("disabled")
    $("#online_application_departure_3i").removeAttr("disabled")
    $("#travel_car_train").show()
    $("#travel_flight").show()
  if $('#online_application_day_visit_true').is(':checked')
    $("#online_application_departure_1i").attr("disabled", true)
    $("#online_application_departure_2i").attr("disabled", true)
    $("#online_application_departure_3i").attr("disabled", true)
    $("#travel_car_train").hide()
    $("#travel_flight").hide()

  ## And then all the hooks ##
  $('input:radio[name="online_application[day_visit]"]').click ->
    if $('#online_application_day_visit_false').is(':checked')
      $("#online_application_departure_1i").removeAttr("disabled")
      $("#online_application_departure_2i").removeAttr("disabled")
      $("#online_application_departure_3i").removeAttr("disabled")
      $("#travel_car_train").show()
      $("#travel_flight").show()
    else
      $("#online_application_departure_1i").attr("disabled", true)
      $("#online_application_departure_2i").attr("disabled", true)
      $("#online_application_departure_3i").attr("disabled", true)
      $("#travel_car_train").hide()
      $("#travel_flight").hide()

  ##### handle previous visit conditional fields #####

  ## First the code that will run on document load ##
  if $('#online_application_previous_visit_false').is(':checked') and $('#online_application_relation').val() == 'primary applicant'
    $("#heard_about_div").show()
  if $('#online_application_previous_visit_true').is(':checked')
    $("#previous_year_div").show()

  ## And then all the hooks ##
  $('input:radio[name="online_application[previous_visit]"]').click ->
    if $('#online_application_previous_visit_false').is(':checked') 
      if $('#online_application_relation').val() == 'primary applicant'
        $("#heard_about_div").show()
      $("#previous_year_div").hide()
    else
      $("#heard_about_div").hide()
      $("#previous_year_div").show()

  ##### fax number is compulsory in certain cases ####

  ## First the code that will run on document load ##
  if $('#online_application_confirmation_letter_via_fax').is(':checked') and $('#online_application_relation').val() == 'primary applicant'
    $("#fax_required").show()
  else
    $("#fax_required").hide()

  ## And then all the hooks ##
  $('input:radio[name="online_application[confirmation_letter_via]"]').change ->
    if $('#online_application_confirmation_letter_via_fax').is(':checked') or $('#online_application_visa').is(':checked')
      $("#fax_required").show()
    else
      $("#fax_required").hide()
    if $('#online_application_confirmation_letter_via_fax').is(':checked')
      alert(I18n.t("ensure_fax_number"))

  ##### correspondence address is compulsory in certain cases ####

  ## First the code that will run on document load ##
  if $('#online_application_relation').val() == 'primary applicant' and $('#online_application_confirmation_letter_via_correspondence_address').is(':checked')
    $(".correspondence_address_required").show()
  else
    $(".correspondence_address_required").hide()

  ## And then all the hooks ##
  $('input:radio[name="online_application[confirmation_letter_via]"]').change ->
    if $('#online_application_confirmation_letter_via_correspondence_address').is(':checked')
      $(".correspondence_address_required").show()
      alert(I18n.t("ensure_correspondence_address"))
    else
      $(".correspondence_address_required").hide()

  ##### show visa related fields if a visa is required ####

  ## First the code that will run on document load ##
  if ($('#online_application_visa').is(':checked'))
    $(".visa_required").show()
    if $('#online_application_relation').val() == 'primary applicant'
      $(".visa_required_primary_applicant_only").show()
  else
    $(".visa_required").hide()
    $(".visa_required_primary_applicant_only").hide()

  ## And then all the hooks
  $("#online_application_visa").change ->
    $(".visa_required").toggle()
    if $('#online_application_relation').val() == 'primary applicant'
      $(".visa_required_primary_applicant_only").toggle()
  
  ##### update name badge fields when changes are made to name/country fields ####

  ## First the code that will run on document load ##
  if $("#online_application_firstname").val() != ''
    $("#online_application_badge_firstname").val($("#online_application_firstname").val())

  if $("#online_application_surname").val() != ''
    $("#online_application_badge_surname").val($("#online_application_surname").val())

  if $("#online_application_citizenship_id").val() != '0' and $("#online_application_citizenship_id").val() != ''
    $("#online_application_badge_country").val($("#online_application_citizenship_id option:selected").text())

  if $("#online_application_citizenship_id").val() == '0' and $("#online_application_citizenship_id").val() != ''
    $("#online_application_badge_country").val($("#online_application_other_citizenship").val())

  ## And then all the hooks ##
  $("#online_application_firstname").change ->
    $("#online_application_badge_firstname").val($("#online_application_firstname").val())

  $("#online_application_surname").change ->
    $("#online_application_badge_surname").val($("#online_application_surname").val())
 
  $("#online_application_citizenship_id").change ->
    if $("#online_application_citizenship_id").val() != 'other'
      $("#online_application_badge_country").val($("#online_application_citizenship_id option:selected").text())
    else
      $("#online_application_badge_country").val($("#online_application_other_citizenship").val())
 
  $("#online_application_other_citizenship").change ->
    $("#online_application_badge_country").val($("#online_application_other_citizenship").val())

  ##### handle showing/hiding of certain sections for spouse/children ####

  ## First the code that will run on document load ##
  if $('#online_application_relation').val() == 'spouse' or $('#online_application_relation').val() == 'child'
    $(".hide_for_family_members").hide()
  else
    $(".hide_for_family_members").show()
  if $('#online_application_relation').val() == 'child'
    $(".hide_for_children").hide()
    $(".show_for_children").show()
  else
    $(".hide_for_children").show()
    $(".show_for_children").hide()
  if $('#online_application_relation').val() == 'primary applicant'
    $(".show_for_primary_applicant").show()
  else
    $(".show_for_primary_applicant").hide()


  ## And then all the hooks ##
  $("#online_application_relation").change ->
    if $('#online_application_relation').val() == 'spouse' or $('#online_application_relation').val() == 'child'
      $(".hide_for_family_members").hide()
    else
      $(".hide_for_family_members").show()
    if $('#online_application_relation').val() == 'child'
      $(".hide_for_children").hide()
      $(".show_for_children").show()
    else
      $(".hide_for_children").show()
      $(".show_for_children").hide()
    if $('#online_application_relation').val() == 'primary applicant'
      $(".show_for_primary_applicant").show()
    else
      $(".show_for_primary_applicant").hide()

  ##### handle conference subforms #####

  ## First the code that will run on document load ##
  $("input[class^=oac_checkbox_]").each ->
    if $(this).is(':checked')
      $("." + $(this).attr('class') + "_subform").show()
    else
      $("." + $(this).attr('class') + "_subform").hide()

  ## And then all the hooks ##
  $("input[class^=oac_checkbox_]").change ->
    $("." + $(this).attr('class') + "_subform").toggle()

  ##### child_2013: put in note about children and the application form #####

  ## First the code that will run on document load ##
  if $('.yes_children').is(':checked')
    $("#child_2013_please_fill_out").show()
  else
    $("#child_2013_please_fill_out").hide()

  ## And then all the hooks ##
  $('.yes_children').click ->
    #if $('#online_application_online_application_conferences_attributes_4_variables_chil_2013_children_true').is(':checked')
    if $('.yes_children').is(':checked')
      $("#child_2013_please_fill_out").show()
    else
      $("#child_2013_please_fill_out").hide()
  $('.no_children').click ->
    if $('.yes_children').is(':checked')
      $("#child_2013_please_fill_out").show()
    else
      $("#child_2013_please_fill_out").hide()


