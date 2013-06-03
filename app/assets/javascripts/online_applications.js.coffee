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

  ##### conference fee logic #####

  recalculate_fees = () ->
    DAY = 1000 * 60 * 60  * 24
    YEAR = DAY * 365.25

    arrival = new Date($('#online_application_arrival_1i').val() + '/' +  $('#online_application_arrival_2i').val() + '/' + $('#online_application_arrival_3i').val())
    departure = new Date($('#online_application_departure_1i').val() + '/' +  $('#online_application_departure_2i').val() + '/' + $('#online_application_departure_3i').val())
    birthdate = new Date($('#online_application_date_of_birth_1i').val() + '/' +  $('#online_application_date_of_birth_2i').val() + '/' + $('#online_application_date_of_birth_3i').val())
    now = new Date()

    age = -1
    if !isNaN(birthdate)
      age = ~~((now.getTime() - birthdate.getTime()) / YEAR)

    nights = 0
    if (!isNaN(departure) and !isNaN(arrival))
      nights = Math.round((departure.getTime() - arrival.getTime()) / DAY)

    if nights < 0
      nights = 0

    if $("#online_application_day_visit_true").is(':checked')
      # We use nights in the calculations below so it needs to be forced to 1 here.
      # We force the night_rate and the registration-fee below for the day visitor case.
      nights = 1

    registration_fee = 100
    night_rate = 92

    calculated_rate_and_fee_details = 'Regular: night rate: CHF 92; registration fee: CHF 100\n'

    if age >= 0 and age <= 5
      night_rate = 0
      registration_fee = 0
      calculated_rate_and_fee_details += 'Child 0-5: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
    else if age >= 6 and age <= 17
      night_rate = 46
      registration_fee = 100
      calculated_rate_and_fee_details += 'Age 6-17: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
    else if age >= 18 and age <= 25
      night_rate = 55
      registration_fee = 100
      calculated_rate_and_fee_details += 'Age 18-25: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
    else if age >= 26
      night_rate = 92
      registration_fee = 100

    if $("#online_application_full_time_volunteer").is(':checked')
      night_rate = 55
      registration_fee = 0
      calculated_rate_and_fee_details += 'Full time volunteer: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

    if $("#online_application_staff").is(':checked')
      night_rate = 35
      registration_fee = 0
      $("#online_application_sponsors_attributes_0_name").val('IofC Switzerland')
      $("#online_application_sponsors_attributes_0_nights").val(nights)
      $("#online_application_sponsors_attributes_0_amount").val(35)
      calculated_rate_and_fee_details += 'Staff: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
    else if $("#online_application_volunteer").is(':checked')
      night_rate = 35
      registration_fee = 0
      $("#online_application_sponsors_attributes_0_name").val('Conference Support Fund (CSF)')
      $("#online_application_sponsors_attributes_0_nights").val(nights)
      $("#online_application_sponsors_attributes_0_amount").val(35)
      calculated_rate_and_fee_details += 'Volunteer: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
    else if $("#online_application_interpreter").is(':checked')
      night_rate = 35
      registration_fee = 0
      $("#online_application_sponsors_attributes_0_name").val('Conference Support Fund (CSF)')
      $("#online_application_sponsors_attributes_0_nights").val(nights)
      $("#online_application_sponsors_attributes_0_amount").val(35)
      calculated_rate_and_fee_details += 'Interpreter: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
    else if $("[id='tp_check_caux scholars program']").is(':checked')
      night_rate = 55
      registration_fee = 50
      $("#online_application_sponsors_attributes_0_name").val('Caux Scholars Program')
      $("#online_application_sponsors_attributes_0_nights").val(nights)
      $("#online_application_sponsors_attributes_0_amount").val(55)
      calculated_rate_and_fee_details += 'Caux Scholars Program: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
    else if $("[id='tp_check_caux interns program – session 1']").is(':checked') or
            $("[id='tp_check_caux interns program – session 2']").is(':checked')
      night_rate = 55
      registration_fee = 50
      $("#online_application_sponsors_attributes_0_name").val('Caux Interns Program')
      $("#online_application_sponsors_attributes_0_nights").val(nights)
      $("#online_application_sponsors_attributes_0_amount").val(55)
      calculated_rate_and_fee_details += 'Caux Interns Program: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
    else if $("[id='tp_check_week of international community']").is(':checked')
      night_rate = 35
      registration_fee = 100
      $("#online_application_sponsors_attributes_0_name").val('Conference Support Fund (CSF)')
      $("#online_application_sponsors_attributes_0_nights").val(nights)
      $("#online_application_sponsors_attributes_0_amount").val(35)
      calculated_rate_and_fee_details += 'Work week: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
    else if $("[id='tp_check_caux artists program']").is(':checked')
      night_rate = 55
      registration_fee = 50
      $("#online_application_sponsors_attributes_0_name").val('Caux Artists Program')
      $("#online_application_sponsors_attributes_0_nights").val(nights)
      $("#online_application_sponsors_attributes_0_amount").val(55)
      calculated_rate_and_fee_details += 'Caux Artists Program: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
    else if $("#online_application_sponsors_attributes_0_name").val() == 'IofC Switzerland' or
            $("#online_application_sponsors_attributes_0_name").val() == 'Caux Scholars Program' or
            $("#online_application_sponsors_attributes_0_name").val() == 'Caux Interns Program' or
            $("#online_application_sponsors_attributes_0_name").val() == 'Caux Artists Program' or
            $("#online_application_sponsors_attributes_0_name").val() == 'Conference Support Fund (CSF)'
      $("#online_application_sponsors_attributes_0_name").val('')
      $("#online_application_sponsors_attributes_0_nights").val('')
      $("#online_application_sponsors_attributes_0_amount").val('')

    if $('input[id$="_speaker"]').is(':checked') or
       $('input[id$="_team"]').is(':checked')
      registration_fee = 0
      calculated_rate_and_fee_details += 'Speaker: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

    if $("#online_application_day_visit_true").is(':checked')
      night_rate = 50
      registration_fee = 0
      calculated_rate_and_fee_details += 'Day visit: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

    if $("#online_application_family_discount").is(':checked')
      night_rate = Math.round(night_rate * 0.8)
      calculated_rate_and_fee_details += 'Family discount: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

    if $("#family_discount").val() == 'true'
      # Only the primary registrant for families pays the registration fee
      night_rate = Math.round(night_rate * 0.8)
      registration_fee = 0
      calculated_rate_and_fee_details += 'Family discount: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

    if $("#online_application_support_renovation_fund").is(':checked')
      night_rate = 150
      calculated_rate_and_fee_details += 'Renovation fund: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

    if $("#online_application_sent_by_employer").is(':checked')
      night_rate = 150
      calculated_rate_and_fee_details += 'Sent by employer: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

    $("#rate_per_night_visible").text(night_rate)
    $("#rate_per_night").val(night_rate)
    $("#registration_fee_visible").text(registration_fee)
    $("#registration_fee").val(registration_fee)
    $("#nights_visible").text(nights)
    $("#total_nights_visible").text(nights * night_rate)
    $("#total_nights").val(nights * night_rate)

    total_nights = nights * night_rate

    sponsor_1_contribution = $("#online_application_sponsors_attributes_0_nights").val() * $("#online_application_sponsors_attributes_0_amount").val()
    sponsor_2_contribution = $("#online_application_sponsors_attributes_1_nights").val() * $("#online_application_sponsors_attributes_1_amount").val()

    if ! isNaN(sponsor_1_contribution)
      sponsor_contribution = sponsor_1_contribution

    if ! isNaN(sponsor_2_contribution)
      sponsor_contribution += sponsor_2_contribution

    if isNaN(sponsor_contribution)
      sponsor_contribution = 0

    total_automatic = total_nights - sponsor_contribution
    if total_automatic < 0
      total_automatic = 0

    # Sponsors shouldn't pay the registration fee
    total_automatic += registration_fee

    $("#total_automatic").text(total_automatic)

    $("#online_application_calculated_nights").val(nights)
    $("#online_application_calculated_night_rate").val(night_rate)
    $("#online_application_calculated_registration_fee").val(registration_fee)
    $("#online_application_calculated_total_personal_contribution").val(total_automatic)
    $("#online_application_calculated_rate_and_fee_details").val(calculated_rate_and_fee_details)
    false

  ## First the code that will run on document load ##
  recalculate_fees()

  $("#online_application_family_discount").change ->
    recalculate_fees()
  $("#online_application_support_renovation_fund").change ->
    recalculate_fees()
  $("#online_application_sent_by_employer").change ->
    recalculate_fees()
  $("#online_application_full_time_volunteer").change ->
    recalculate_fees()
  $("#online_application_staff").change ->
    recalculate_fees()
  $("#online_application_volunteer").change ->
    recalculate_fees()
  $("#online_application_interpreter").change ->
    recalculate_fees()
  $('#online_application_date_of_birth_1i').change ->
    recalculate_fees()
  $('#online_application_date_of_birth_2i').change ->
    recalculate_fees()
  $('#online_application_date_of_birth_3i').change ->
    recalculate_fees()
  $('#online_application_arrival_1i').change ->
    recalculate_fees()
  $('#online_application_arrival_2i').change ->
    recalculate_fees()
  $('#online_application_arrival_3i').change ->
    recalculate_fees()
  $('#online_application_departure_1i').change ->
    recalculate_fees()
  $('#online_application_departure_2i').change ->
    recalculate_fees()
  $('#online_application_departure_3i').change ->
    recalculate_fees()
  $('#online_application_sponsors_attributes_0_nights').change ->
    recalculate_fees()
  $('#online_application_sponsors_attributes_0_amount').change ->
    recalculate_fees()
  $('#online_application_sponsors_attributes_1_nights').change ->
    recalculate_fees()
  $('#online_application_sponsors_attributes_1_amount').change ->
    recalculate_fees()
  $('#online_application_day_visit_false').change ->
    recalculate_fees()
  $('#online_application_day_visit_true').change ->
    recalculate_fees()
  $("[id='tp_check_caux artists program']").change ->
    recalculate_fees()
  $("[id='tp_check_caux scholars program']").change ->
    recalculate_fees()
  $("[id='tp_check_caux interns program – session 1']").change ->
    recalculate_fees()
  $("[id='tp_check_caux interns program – session 2']").change ->
    recalculate_fees()
  $("[id='tp_check_week of international community']").change ->
    recalculate_fees()
  $('input[id$="_team"]').change ->
    recalculate_fees()
  $('input[id$="_speaker"]').change ->
    recalculate_fees()
