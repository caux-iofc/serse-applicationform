jQuery ->

  # Member counter for the details form
  update_member_counters = () ->
    count = 2
    $('.member-counter').each ->
      $(@).html(count)
      count = count + 1

  # On document load, set the member counter numbers (if we need to)
  update_member_counters()

  $(document).on "click", "#add_member", (e) ->
    e.preventDefault();
    $.ajax
      url: '/en/add_member'
      success: (data) ->
        el_to_add = $(data).html()
        $('#members').append(el_to_add)
        update_member_counters()
      error: (data) ->
        alert "Sorry, there was an error!"

  ## Default the year of arrival/departure to the current year
  dt = new Date(); 
  if ($('#online_application_arrival_1i').val() == '')
    $("#online_application_arrival_1i").val(dt.getYear()+1900)
  if ($('#online_application_departure_1i').val() == '')
    $("#online_application_departure_1i").val(dt.getYear()+1900)

  ##### handle diet_other ####

  ## First the code that will run on document load ##
  $("input[class^=diet_other_]").each ->
    if $(this).is(':checked')
      $("." + $(this).attr('class') + "_subform").show()
    else
      $("." + $(this).attr('class') + "_subform").hide()

  ## And then all the hooks
  $("input[class^=diet_other_]").change ->
    $("." + $(this).attr('class') + "_subform").toggle()
 
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
  $("select[class^='form-control citizenship_id_']").each ->
    if $(this).val() == '0'
      $("#" + $(this).attr('class').replace('form-control ','') + "_subform").show()
    else
      $("#" + $(this).attr('class').replace('form-control ','') + "_subform").hide()

  ## And then all the hooks ##
  $("select[class^='form-control citizenship_id_']").change ->
    $("#" + $(this).attr('class').replace('form-control ','') + "_subform").toggle()

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
    $("#travel_car_train").show()
    $("#travel_flight").show()
  if $('#online_application_day_visit_true').is(':checked')
    $("#travel_car_train").hide()
    $("#travel_flight").hide()

  ## And then all the hooks ##
  $('input:radio[name="online_application[day_visit]"]').click ->
    if $('#online_application_day_visit_false').is(':checked')
      $("#travel_car_train").show()
      $("#travel_flight").show()
    else
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
    $("#fax_required").addClass('required');
  else
    $("#fax_required").removeClass('required');

  ## And then all the hooks ##
  $('input:radio[name="online_application[confirmation_letter_via]"]').change ->
    if $('#online_application_confirmation_letter_via_fax').is(':checked') or $('#online_application_visa').is(':checked')
      $("#fax_required").addClass('required');
    else
      $("#fax_required").removeClass('required');
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
  $("input[class^=visa_checkbox_]").each ->
    if $(this).is(':checked')
      $("." + $(this).attr('class') + "_subform").show()
    else
      $("." + $(this).attr('class') + "_subform").hide()

  ## And then all the hooks
  $("input[class^=visa_checkbox_]").change ->
    $("." + $(this).attr('class') + "_subform").toggle()
  
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
  if $('#online_application_relation').val() == 'primary applicant'
    $(".show_for_all_but_primary_applicant").hide()
  else
    $(".show_for_all_but_primary_applicant").show()


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

  ##### cats_2014: put in note about children and the application form #####

  ## First the code that will run on document load ##
  if $('.yes_children').is(':checked')
    $("#cats_2014_please_fill_out").show()
  else
    $("#cats_2014_please_fill_out").hide()

  ## And then all the hooks ##
  $('.yes_children').click ->
    if $('.yes_children').is(':checked')
      $("#cats_2014_please_fill_out").show()
    else
      $("#cats_2014_please_fill_out").hide()
  $('.no_children').click ->
    if $('.yes_children').is(':checked')
      $("#cats_2014_please_fill_out").show()
    else
      $("#cats_2014_please_fill_out").hide()

  ##### TIGE 2014 special logic #####

  tige_2014_special_logic = (label,destination) ->
    if $(label + ' option:selected').text() == 'Programme: EPIC programme for next generation Entrepreneurs, Pathfinders, Innovators and Changemakers' or
       $(label + ' option:selected').text() == 'Programme EPIC pour la prochaine génération entrepreneurs, pionniers,  innovateurs et initiateurs de changement' or
       $(label + ' option:selected').text() == 'Programm: EPIC Programm für die nächste Generation von Unternehmern, Innovatoren und Changemakern'
      $(destination).html(I18n.t("tige_2014_epic_request_application_html"))
      $(destination).show()
    else if $(label + ' option:selected').text() == 'Training: Heart of Effective Leadership' or
            $(label + ' option:selected').text().match(/Formation : Au c.ur d.un leadership efficace/) or
            $(label + ' option:selected').text() == 'Training: Der Kern eines effektiven Führungsstils'
      $(destination).html(I18n.t("tige_2014_hel_info_html"))
      $(destination).show()
    else if $(label + ' option:selected').text() == 'Parallel track: Caux Business Leadership Forum on global sustainability issues' or
            $(label + ' option:selected').text() == 'Forum de Caux Business Leadership sur des questions mondiales de  développement durable (uniquement sur invitation).' or
            $(label + ' option:selected').text() == 'Parallele Veranstaltung: Caux Business Leadership Forum zu Themen globaler Nachhaltigkeit (nur auf Einladung)'
      $(destination).html(I18n.t("tige_2014_business_info_html"))
      $(destination).show()
    else
      $(destination).hide()

  tige_2014_special_logic('#online_application_online_application_conferences_attributes_1_online_application_conference_workstreams_attributes_0_conference_workstream_id','#tige_2014_first_choice_extra')
  tige_2014_special_logic('#online_application_online_application_conferences_attributes_1_online_application_conference_workstreams_attributes_1_conference_workstream_id','#tige_2014_second_choice_extra')

  $('#online_application_online_application_conferences_attributes_1_online_application_conference_workstreams_attributes_0_conference_workstream_id').change ->
    tige_2014_special_logic('#online_application_online_application_conferences_attributes_1_online_application_conference_workstreams_attributes_0_conference_workstream_id','#tige_2014_first_choice_extra')
  $('#online_application_online_application_conferences_attributes_1_online_application_conference_workstreams_attributes_1_conference_workstream_id').change ->
    tige_2014_special_logic('#online_application_online_application_conferences_attributes_1_online_application_conference_workstreams_attributes_1_conference_workstream_id','#tige_2014_second_choice_extra')

  ##### IPF exhibitor logic #####

  ## First the code that will run on document load ##
  if $('.ipbf_role_exhibitor').is(':checked')
    $("#ipbf_exhibitor_note").show()
  else
    $("#ipbf_exhibitor_note").hide()

  ## And then all the hooks ##
  $('.ipbf_role_exhibitor').change ->
    if $('.ipbf_role_exhibitor').is(':checked')
      $("#ipbf_exhibitor_note").show()
    else
      $("#ipbf_exhibitor_note").hide()

  ##### TIGE 2015 logic #####

  ## First the code that will run on document load ##
  if $('#online_application_online_application_conferences_attributes_0_variables_tige_2015_options_other').is(':checked')
    $("#tige_2015_other_detail").show()
  else
    $("#tige_2015_other_detail").hide()

  ## And then all the hooks ##
  $('.tige_2015_options').change ->
    if $('#online_application_online_application_conferences_attributes_0_variables_tige_2015_options_other').is(':checked')
      $("#tige_2015_other_detail").show()
    else
      $("#tige_2015_other_detail").hide()

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

    day_visit = 0

    nights = 0
    if (!isNaN(departure) and !isNaN(arrival))
      nights = Math.round((departure.getTime() - arrival.getTime()) / DAY)

    if nights < 0
      nights = 0
    else if nights == 0
      day_visit = 1

    if $("#online_application_day_visit_true").is(':checked')
      # We force the night_rate and the registration-fee below for the day visitor case.
      day_visit = 1

    registration_fee = 100
    night_rate = 165

    calculated_rate_and_fee_details = 'Regular: night rate: CHF 165; registration fee: CHF 100\n'

    if $("#online_application_student").is(':checked')
      night_rate = 105
      registration_fee = 100
      calculated_rate_and_fee_details += 'Student: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

    if age >= 0 and age <= 5
      night_rate = 0
      registration_fee = 0
      calculated_rate_and_fee_details += 'Child 0-5: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
    else if age >= 6 and age <= 17
      night_rate = 50
      registration_fee = 50
      calculated_rate_and_fee_details += 'Age 6-17: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
    else if age >= 18 and age <= 25
      night_rate = 63
      registration_fee = 100
      calculated_rate_and_fee_details += 'Age 18-25: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

    if $("#online_application_full_time_volunteer").is(':checked')
      night_rate = 63
      registration_fee = 0
      calculated_rate_and_fee_details += 'Full time volunteer: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

    if $("#online_application_staff").is(':checked')
      night_rate = 63
      registration_fee = 0
      $("#online_application_sponsors_attributes_0_name").val('IofC Switzerland')
      $("#online_application_sponsors_attributes_0_nights").val(nights)
      $("#online_application_sponsors_attributes_0_amount").val(63)
      calculated_rate_and_fee_details += 'Staff: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
    else if $("#online_application_volunteer").is(':checked')
      night_rate = 63
      registration_fee = 0
      $("#online_application_sponsors_attributes_0_name").val('Conference Support Fund (CSF)')
      $("#online_application_sponsors_attributes_0_nights").val(nights)
      $("#online_application_sponsors_attributes_0_amount").val(63)
      calculated_rate_and_fee_details += 'Volunteer: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
    else if $("#online_application_interpreter").is(':checked')
      night_rate = 63
      registration_fee = 0
      $("#online_application_sponsors_attributes_0_name").val('Conference Support Fund (CSF)')
      $("#online_application_sponsors_attributes_0_nights").val(nights)
      $("#online_application_sponsors_attributes_0_amount").val(63)
      calculated_rate_and_fee_details += 'Interpreter: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
    else if $("[id='tp_check_caux scholars program']").is(':checked')
      night_rate = 63
      registration_fee = 50
      $("#online_application_sponsors_attributes_0_name").val('Caux Scholars Program')
      $("#online_application_sponsors_attributes_0_nights").val(nights)
      $("#online_application_sponsors_attributes_0_amount").val(63)
      calculated_rate_and_fee_details += 'Caux Scholars Program: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
    else if $("[id='tp_check_caux interns program – session 1']").is(':checked') or
            $("[id='tp_check_caux interns program – session 2']").is(':checked')
      night_rate = 63
      registration_fee = 250
      $("#online_application_sponsors_attributes_0_name").val('Caux Interns Program')
      $("#online_application_sponsors_attributes_0_nights").val(nights)
      $("#online_application_sponsors_attributes_0_amount").val(63)
      calculated_rate_and_fee_details += 'Caux Interns Program: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
    else if $("[id='tp_check_week of international community']").is(':checked')
      night_rate = 63 
      registration_fee = 0
      $("#online_application_sponsors_attributes_0_name").val('Conference Support Fund (CSF)')
      $("#online_application_sponsors_attributes_0_nights").val(nights)
      $("#online_application_sponsors_attributes_0_amount").val(63)
      calculated_rate_and_fee_details += 'Work week: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
    else if $("[id='tp_check_caux artists program']").is(':checked')
      night_rate = 63
      registration_fee = 50
      $("#online_application_sponsors_attributes_0_name").val('Caux Artists Program')
      $("#online_application_sponsors_attributes_0_nights").val(nights)
      $("#online_application_sponsors_attributes_0_amount").val(63)
      calculated_rate_and_fee_details += 'Caux Artists Program: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
    else if $("#online_application_sponsors_attributes_0_name").val() == 'IofC Switzerland' or
            $("#online_application_sponsors_attributes_0_name").val() == 'Caux Scholars Program' or
            $("#online_application_sponsors_attributes_0_name").val() == 'Caux Interns Program' or
            $("#online_application_sponsors_attributes_0_name").val() == 'Caux Artists Program' or
            $("#online_application_sponsors_attributes_0_name").val() == 'Conference Support Fund (CSF)'
      $("#online_application_sponsors_attributes_0_name").val('')
      $("#online_application_sponsors_attributes_0_nights").val('')
      $("#online_application_sponsors_attributes_0_amount").val('')

    if $('input[id$="_speaker"]').is(':checked')
      registration_fee = 0
      calculated_rate_and_fee_details += 'Speaker: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

    if $('input[id$="_team"]').is(':checked')
      registration_fee = 0
      night_rate = 63
      calculated_rate_and_fee_details += 'Team: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

    if day_visit == 1
      night_rate = 55
      registration_fee = 0
      calculated_rate_and_fee_details += 'Day visit: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

    if $("#online_application_family_discount").is(':checked') and night_rate > 105
      night_rate = 105
      calculated_rate_and_fee_details += 'Family discount: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

    if $("#family_discount").val() == 'true' and night_rate > 105
      # Only the primary registrant for families pays the registration fee
      night_rate = 105
      registration_fee = 0
      calculated_rate_and_fee_details += 'Family discount: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

    if $("#online_application_relation").val() == 'spouse'
      # Only the primary registrant for families pays the registration fee
      registration_fee = 0
      calculated_rate_and_fee_details += 'Spouse: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

    if $("#online_application_relation").val() == 'child'
      # Only the primary registrant for families pays the registration fee
      registration_fee = 0
      calculated_rate_and_fee_details += 'Child: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

    if $("#online_application_support_renovation_fund").is(':checked')
      night_rate = 220
      calculated_rate_and_fee_details += 'Renovation fund: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

    if $("#online_application_sent_by_employer").is(':checked')
      if $("#online_application_day_visit_true").is(':checked')
        night_rate = 100
        registration_fee = 0
      else
        night_rate = 220
        registration_fee = 100
      calculated_rate_and_fee_details += 'Sent by employer: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

    ##### aeub_2014: complicated messing with finance #####
    if $('.aeub_2014_two_days_and_one_night').is(':checked')
      # They wanted 1 day at CHF 165 + 1 day at CHF 55
      if night_rate < 220
        night_rate = 220
      if nights < 1
        nights = 1
      calculated_rate_and_fee_details += 'AEUB 2014: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
      calculated_rate_and_fee_details += 'AEUB 2014: 2 days and one night\n'

    if $('.aeub_2014_two_days_and_two_nights').is(':checked')
      if night_rate < 165
        night_rate = 165
      if nights < 2
        nights = 2
      calculated_rate_and_fee_details += 'AEUB 2014: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
      calculated_rate_and_fee_details += 'AEUB 2014: 2 days and 2 nights\n'

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

  $("#online_application_relation").change ->
    recalculate_fees()
  $("#online_application_family_discount").change ->
    recalculate_fees()
  $("#online_application_support_renovation_fund").change ->
    recalculate_fees()
  $("#online_application_sent_by_employer").change ->
    recalculate_fees()
  $("#online_application_student").change ->
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
  $('.aeub_2014_two_days_and_one_night').change ->
    recalculate_fees()
  $('.aeub_2014_two_days_and_two_nights').change ->
    recalculate_fees()
