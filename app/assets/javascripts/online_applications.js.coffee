jQuery ->

  # Member counter for the details form
  update_member_counters = () ->
    count = 2
    $('.member-counter').each ->
      $(@).html(count)
      count = count + 1

  # On document load, set the member counter numbers (if we need to)
  update_member_counters()

  $(document).on "click", "#add_family_member", (e) ->
    e.preventDefault();
    $.ajax
      url: '/en/add_family_member'
      success: (data) ->
        el_to_add = $(data).html()
        $('#members').append(el_to_add)
        update_member_counters()
      error: (data) ->
        alert "Sorry, there was an error!"

  $(document).on "click", "#add_group_member", (e) ->
    e.preventDefault();
    $.ajax
      url: '/en/add_group_member'
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

  ##### handle other_address for group members ####

  ## First the code that will run on document load ##
  $("input[class^=different_address_]").each ->
    if $(this).is(':checked')
      $("." + $(this).attr('class') + "_subform").show()
    else
      $("." + $(this).attr('class') + "_subform").hide()

  # In order to attach to dynamically inserted group members, attach to the form
  # element with jquery's on()
  $(".edit_application_group").on "change", "input[class^=different_address_]", ->
    $("." + $(this).attr('class') + "_subform").toggle()

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
    if $(this).val() == '0'
      $("#" + $(this).attr('class').replace('form-control ','') + "_subform").toggle()

  ##### handle permanent_address_other_country ####

  ## First the code that will run on document load ##
  $("select[class^='form-control country_']").each ->
    if $(this).val() == '0'
      $("." + $(this).attr('class').replace('form-control ','') + "_subform").show()
    else
      $("." + $(this).attr('class').replace('form-control ','') + "_subform").hide()

  # In order to attach to dynamically inserted group members, attach to the form
  # element with jquery's on(). Because we use the permanent_address partial on
  # the personal information and the group page, make sure to attach to either type
  # of form.
  $(".edit_online_application").on "change", "select[class^='form-control country_']", ->
    if $(this).val() == '0'
      $("." + $(this).attr('class').replace('form-control ','') + "_subform").show()
    else
      $("." + $(this).attr('class').replace('form-control ','') + "_subform").hide()
  $(".edit_application_group").on "change", "select[class^='form-control country_']", ->
    if $(this).val() == '0'
      $("." + $(this).attr('class').replace('form-control ','') + "_subform").show()
    else
      $("." + $(this).attr('class').replace('form-control ','') + "_subform").hide()

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

    exports = this

    # exports.sponsors holds the aggregate sponsor information across all group/family members
    exports.sponsors = []
    sponsors = []
    exports.total_automatic = 0
    exports.total_registration_fee = 0

    # Walk the applications in the group/family
    $('.oa-counter').each ->

      # base_id looks like 'application_group_online_applications_attributes_0'
      base_id = '#' + $(this).attr('id')

      arrival = new Date($(base_id + '_arrival').val())
      departure = new Date($(base_id + '_departure').val())
      now = new Date()

      nights = 0
      if (!isNaN(departure) and !isNaN(arrival))
        nights = Math.round((departure.getTime() - arrival.getTime()) / DAY)

      if nights < 0
        nights = 0

      date_of_birth = new Date($(base_id + '_date_of_birth').val())

      age = -1
      if !isNaN(date_of_birth)
        age = ~~((now.getTime() - date_of_birth.getTime()) / YEAR)

      day_visit = 0
      if $(base_id + "_day_visit").val() == '1'
        # We force the night_rate and the registration-fee below for the day visitor case.
        day_visit = 1

      # These are the standard fees
      registration_fee = 100
      night_rate = 165
      calculated_rate_and_fee_details = 'Standard: night rate: CHF 165; registration fee: CHF 100\n'

      if $(base_id + '_rate_student').is(':checked')
        night_rate = 105
        registration_fee = 100
        calculated_rate_and_fee_details += 'Student: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

      if $(base_id + '_rate_amis_de_caux').is(':checked')
        night_rate = 105
        registration_fee = 100
        calculated_rate_and_fee_details += 'amis de Caux: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

      if $(base_id + '_rate_local_iofc_team_member').is(':checked')
        night_rate = 105
        registration_fee = 100
        calculated_rate_and_fee_details += 'local IofC team member: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

      if $(base_id + '_rate_staff').is(':checked')
        night_rate = 63
        registration_fee = 0
        if typeof exports.sponsors['IofC Switzerland'] is 'undefined'
          exports.sponsors['IofC Switzerland'] = {}
          exports.sponsors['IofC Switzerland'].name = 'IofC Switzerland'
          exports.sponsors['IofC Switzerland'].nights = nights
          exports.sponsors['IofC Switzerland'].amount = 63
        else
          exports.sponsors['IofC Switzerland']['nights'] += nights
        sponsors['IofC Switzerland'] = {}
        sponsors['IofC Switzerland'].name = 'IofC Switzerland'
        sponsors['IofC Switzerland'].nights = nights
        sponsors['IofC Switzerland'].amount = 63
        calculated_rate_and_fee_details += 'Staff: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
      else if $(base_id + '_rate_volunteer').is(':checked')
        night_rate = 63
        registration_fee = 0
        if typeof exports.sponsors['Conference Support Fund (CSF)'] is 'undefined'
          exports.sponsors['Conference Support Fund (CSF)'] = {}
          exports.sponsors['Conference Support Fund (CSF)'].name = 'Conference Support Fund (CSF)'
          exports.sponsors['Conference Support Fund (CSF)'].nights = nights
          exports.sponsors['Conference Support Fund (CSF)'].amount = 63
        else
          exports.sponsors['Conference Support Fund (CSF)']['nights'] += nights
        sponsors['Conference Support Fund (CSF)'] = {}
        sponsors['Conference Support Fund (CSF)'].name = 'Conference Support Fund (CSF)'
        sponsors['Conference Support Fund (CSF)'].nights = nights
        sponsors['Conference Support Fund (CSF)'].amount = 63
        calculated_rate_and_fee_details += 'Volunteer: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
      else if $(base_id + '_rate_interpreter').is(':checked')
        night_rate = 63
        registration_fee = 0
        if typeof exports.sponsors['Conference Support Fund (CSF)'] is 'undefined'
          exports.sponsors['Conference Support Fund (CSF)'] = {}
          exports.sponsors['Conference Support Fund (CSF)'].name = 'Conference Support Fund (CSF)'
          exports.sponsors['Conference Support Fund (CSF)'].nights = nights
          exports.sponsors['Conference Support Fund (CSF)'].amount = 63
        else
          exports.sponsors['Conference Support Fund (CSF)']['nights'] += nights
        sponsors['Conference Support Fund (CSF)'] = {}
        sponsors['Conference Support Fund (CSF)'].name = 'Conference Support Fund (CSF)'
        sponsors['Conference Support Fund (CSF)'].nights = nights
        sponsors['Conference Support Fund (CSF)'].amount = 63
        calculated_rate_and_fee_details += 'Interpreter: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
      else if $(base_id + "_caux_scholar").val() == '1'
        night_rate = 63
        registration_fee = 50
        if typeof exports.sponsors['Caux Scholars Program'] is 'undefined'
          exports.sponsors['Caux Scholars Program'] = {}
          exports.sponsors['Caux Scholars Program'].name = 'Caux Scholars Program'
          exports.sponsors['Caux Scholars Program'].nights = nights
          exports.sponsors['Caux Scholars Program'].amount = 63
        else
          exports.sponsors['Caux Scholars Program']['nights'] += nights
        sponsors['Caux Scholars Program'] = {}
        sponsors['Caux Scholars Program'].name = 'Caux Scholars Program'
        sponsors['Caux Scholars Program'].nights = nights
        sponsors['Caux Scholars Program'].amount = 63
        calculated_rate_and_fee_details += 'Caux Scholars Program: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
      else if $(base_id + "_caux_intern").val() == '1'
        night_rate = 63
        registration_fee = 250
        if typeof exports.sponsors['Caux Interns Program'] is 'undefined'
          exports.sponsors['Caux Interns Program'] = {}
          exports.sponsors['Caux Interns Program'].name = 'Caux Interns Program'
          exports.sponsors['Caux Interns Program'].nights = nights
          exports.sponsors['Caux Interns Program'].amount = 63
        else
          exports.sponsors['Caux Interns Program']['nights'] += nights
        sponsors['Caux Interns Program'] = {}
        sponsors['Caux Interns Program'].name = 'Caux Interns Program'
        sponsors['Caux Interns Program'].nights = nights
        sponsors['Caux Interns Program'].amount = 63
        calculated_rate_and_fee_details += 'Caux Interns Program: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
      else if $(base_id + "_week_of_international_community").val() == '1'
        night_rate = 63
        registration_fee = 0
        if typeof exports.sponsors['Conference Support Fund (CSF)'] is 'undefined'
          exports.sponsors['Conference Support Fund (CSF)'] = {}
          exports.sponsors['Conference Support Fund (CSF)'].name = 'Conference Support Fund (CSF)'
          exports.sponsors['Conference Support Fund (CSF)'].nights = nights
          exports.sponsors['Conference Support Fund (CSF)'].amount = 63
        else
          exports.sponsors['Conference Support Fund (CSF)']['nights'] += nights
        sponsors['Conference Support Fund (CSF)'] = {}
        sponsors['Conference Support Fund (CSF)'].name = 'Conference Support Fund (CSF)'
        sponsors['Conference Support Fund (CSF)'].nights = nights
        sponsors['Conference Support Fund (CSF)'].amount = 63
        calculated_rate_and_fee_details += 'Work week: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
      else if $(base_id + "_caux_artist").val() == '1'
        night_rate = 63
        registration_fee = 50
        if typeof exports.sponsors['Caux Artists Program'] is 'undefined'
          exports.sponsors['Caux Artists Program'] = {}
          exports.sponsors['Caux Artists Program'].name = 'Caux Artists Program'
          exports.sponsors['Caux Artists Program'].nights = nights
          exports.sponsors['Caux Artists Program'].amount = 63
        else
          exports.sponsors['Caux Artists Program']['nights'] += nights
        sponsors['Caux Artists Program'] = {}
        sponsors['Caux Artists Program'].name = 'Caux Artists Program'
        sponsors['Caux Artists Program'].nights = nights
        sponsors['Caux Artists Program'].amount = 63
        calculated_rate_and_fee_details += 'Caux Artists Program: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

      if $(base_id + "_conference_speaker").val() == '1'
        registration_fee = 0
        calculated_rate_and_fee_details += 'Speaker: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

      if $(base_id + "_conference_team").val() == '1'
        registration_fee = 0
        night_rate = 63
        calculated_rate_and_fee_details += 'Team: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

      if day_visit == 1
        night_rate = 55
        registration_fee = 0
        calculated_rate_and_fee_details += 'Day visit: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

      if $(base_id + '_rate_family').is(':checked')
        if day_visit == 1
          night_rate = 55
          registration_fee = 0
        else
          night_rate = 105
          registration_fee = 100 if 100 > registration_fee
        calculated_rate_and_fee_details += 'Family: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

      if $(base_id + "_relation").val() == 'spouse'
        # Only the primary registrant for families pays the registration fee
        registration_fee = 0
        calculated_rate_and_fee_details += 'Spouse: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

      if $(base_id + '_rate_full_premium').is(':checked')
        if day_visit == 1
          night_rate = 100
          registration_fee = 0
        else
          night_rate = 220
          registration_fee = 100 if 100 > registration_fee
        calculated_rate_and_fee_details += 'Full premium: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

      if age >= 0 and age <= 5
        night_rate = 0
        registration_fee = 0
        calculated_rate_and_fee_details += 'Child 0-5: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
      else if age >= 6 and age <= 17
        night_rate = 50
        registration_fee = 50
        calculated_rate_and_fee_details += 'Age 6-17: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
      else if age >= 18 and age <= 25 and day_visit == 0
        night_rate = 63
        registration_fee = 50
        calculated_rate_and_fee_details += 'Age 18-25: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

      if $(base_id + "_relation").val() == 'child'
        # Only the primary registrant pays the registration fee for families
        registration_fee = 0
        calculated_rate_and_fee_details += 'Child: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

      $(base_id + "_rate_per_night_visible").text(night_rate)
      $(base_id + "_rate_per_night").val(night_rate)
      $(base_id + "_registration_fee_visible").text(registration_fee)
      $(base_id + "_registration_fee").val(registration_fee)
      $(base_id + "_nights_visible").text(nights)
      $(base_id + "_total_nights_visible").text(nights * night_rate)
      $(base_id + "_total_nights").val(nights * night_rate)

      total_nights = nights * night_rate

      exports.total_automatic += total_nights
      exports.total_registration_fee += registration_fee
      total_personal_automatic = total_nights + registration_fee

      $(base_id + "_calculated_nights").val(nights)
      $(base_id + "_calculated_night_rate").val(night_rate)
      $(base_id + "_calculated_registration_fee").val(registration_fee)
      $(base_id + "_calculated_total_personal_contribution").val(total_personal_automatic)
      $(base_id + "_calculated_rate_and_fee_details").val(calculated_rate_and_fee_details)

      # Deal with the sponsor lines
      sponsor_count = 0
      for key,sponsor of sponsors
        $(base_id + "_sponsors_attributes_" + sponsor_count + "_name").val(sponsor.name)
        $('span' + base_id + "_sponsors_attributes_" + sponsor_count + "_name").text(sponsor.name)
        $(base_id + "_sponsors_attributes_" + sponsor_count + "_nights").val(sponsor.nights)
        $('span' + base_id + '_sponsors_attributes_' + sponsor_count + '_nights').text(sponsor.nights)
        $(base_id + "_sponsors_attributes_" + sponsor_count + "_amount").val(sponsor.amount)
        $('span' + base_id + "_sponsors_attributes_" + sponsor_count + "_amount").text(sponsor.amount)
        $('span' + base_id + "_sponsors_attributes_" + sponsor_count + "_total").text(sponsor.amount * sponsor.nights)
        $(base_id + "_sponsors_attributes_" + sponsor_count).show()
        sponsor_count += 1

      while sponsor_count < 2
        $(base_id + "_sponsors_attributes_" + sponsor_count + "_name").val('')
        $('span' + base_id + "_sponsors_attributes_" + sponsor_count + "_name").text('')
        $(base_id + "_sponsors_attributes_" + sponsor_count + "_nights").val('')
        $('span' + base_id + "_sponsors_attributes_" + sponsor_count + "_nights").text('')
        $(base_id + "_sponsors_attributes_" + sponsor_count + "_amount").val('')
        $('span' + base_id + "_sponsors_attributes_" + sponsor_count + "_amount").text('')
        $(base_id + "_sponsors_attributes_" + sponsor_count).hide()
        sponsor_count += 1

    # Back from walking all the applications
    # Deal with the totals/sponsor calculation
    sponsor_contribution = 0
    for key,sponsor of exports.sponsors
      sponsor_contribution += sponsor.nights * sponsor.amount

    exports.total_automatic -= sponsor_contribution

    $("input[class^='form-control sponsor_field_'][id$=nights]").each ->
      classname=$(this).attr('class').replace('form-control ','')
      val = 1
      $("input[class^='" + $(this).attr('class') + "']").each ->
        val *= $(this).val()
      $('span#' + classname).text(val)
      exports.total_automatic -= val

    if exports.total_automatic < 0
      exports.total_automatic = 0

    # Sponsors shouldn't pay the registration fee
    exports.total_automatic += exports.total_registration_fee

    $("#total_automatic").text(exports.total_automatic)

    false


  ## First the code that will run on document load ##
  recalculate_fees()

  $(".rate").change ->
    recalculate_fees()
  $('#application_group_online_applications_attributes_0_sponsors_attributes_0_nights').change ->
    recalculate_fees()
  $('#application_group_online_applications_attributes_0_sponsors_attributes_0_amount').change ->
    recalculate_fees()
  $('#application_group_online_applications_attributes_0_sponsors_attributes_1_nights').change ->
    recalculate_fees()
  $('#application_group_online_applications_attributes_0_sponsors_attributes_1_amount').change ->
    recalculate_fees()
  # In order to attach to dynamically inserted group members, attach to the form
  # element with jquery's on()
  $(".edit_application_group").on "change", "input[class^='form-control sponsor_field_']", ->
    #sponsor_recalculate_total($(this))
    recalculate_fees()
