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

  ##### handle previous visit conditional fields #####

  ## First the code that will run on document load ##
  if $('#application_group_online_applications_attributes_0_previous_visit_false').is(':checked')
    $("#heard_about_div").show()
  if $('#application_group_online_applications_attributes_0_previous_visit_true').is(':checked')
    $("#previous_year_div").show()

  ## And then all the hooks ##
  $('input:radio[name="application_group[online_applications_attributes][0][previous_visit]"]').click ->
    if $('#application_group_online_applications_attributes_0_previous_visit_false').is(':checked')
      $("#heard_about_div").show()
      $("#previous_year_div").hide()
    else
      $("#heard_about_div").hide()
      $("#previous_year_div").show()

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
  $("input[id$=_tige_2015_options_other]").each ->
    if $(this).is(':checked')
      $("#" + $(this).attr('id') + "_detail").show()
    else
      $("#" + $(this).attr('id') + "_detail").hide()

  ## And then all the hooks ##
  # We have to be a bit smarter than usual here because radio buttons only get a 'changed'
  # event when they are selected, not when they are deselected.
  $('input[type=radio][class=tige_2015_options]').change ->
    # $(this).attr('name').replace(/[\[\]]+/g, "_") looks like
    #   application_group_online_applications_attributes_1_online_application_conferences_attributes_0_variables_tige_2015_options_
    if $('#' + $(this).attr('name').replace(/[\[\]]+/g, "_") + "other").is(':checked')
      $("#" + $(this).attr('name').replace(/[\[\]]+/g, "_") + "other_detail").show()
    else
      $("#" + $(this).attr('name').replace(/[\[\]]+/g, "_") + "other_detail").hide()

  ##### conference fee logic #####

  find_conference_package = (base_id,rate_nightly,start,stop) ->
    $.ajax
      url: '/en/conference_packages'
      data:
        rate_nightly: rate_nightly
        start: start
        stop: stop
      success: (data) ->
        # data is the object that contains all info returned. It's already in JSON format,
        # thanks to the 'dataType' parameter on this call
        if data.length isnt 0
          window.package_data[base_id] = data[0]
          recalculate_fees()
      error: (data) ->
        alert "Sorry, there was an error!"
      dataType: "json"

  recalculate_fees = () ->
    DAY = 1000 * 60 * 60  * 24
    YEAR = DAY * 365.25

    exports = this

    # Just in case, initialize window.package_data to the empty array if necessary
    if (not window.package_data?)
      window.package_data = []

    # exports.sponsors holds the aggregate sponsor information across all group/family members
    exports.sponsors = []
    exports.total_automatic = 0
    exports.total_registration_fee = 0

    # Walk the applications in the group/family
    $('.oa-counter').each ->
      sponsors = []
      hide_elements = []

      # base_id looks like '#application_group_online_applications_attributes_0'
      base_id = '#' + $(this).attr('id')

      if $(base_id + '_rate_interpreter').is(':checked')
        hide_elements['.' + $(this).attr('id') + '_hide_if_paid_by_foundation'] = true
      if $(base_id + '_rate_staff').is(':checked')
        hide_elements['.' + $(this).attr('id') + '_hide_if_paid_by_foundation'] = true
      if $(base_id + '_rate_volunteer').is(':checked')
        hide_elements['.' + $(this).attr('id') + '_hide_if_paid_by_foundation'] = true

      if hide_elements['.' + $(this).attr('id') + '_hide_if_paid_by_foundation']
        $('.' + $(this).attr('id') + '_hide_if_paid_by_foundation').hide()
        $('.' + $(this).attr('id') + '_show_if_paid_by_foundation').show()
      else
        $('.' + $(this).attr('id') + '_hide_if_paid_by_foundation').show()
        $('.' + $(this).attr('id') + '_show_if_paid_by_foundation').hide()

      # Only Chromium can interpret dates like 'YYYY-MM-DD HH:MM:SS' out of the box.
      # So we accomodate other browsers with a parse function.
      parseDateUTC = (input) ->
        reg = /^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/
        parts = reg.exec(input)
        if parts
          new Date(Date.UTC(parts[1], parts[2] - 1, parts[3], parts[4], parts[5],parts[6]))
        else
          null

      arrival = parseDateUTC($(base_id + '_arrival').val())
      departure = parseDateUTC($(base_id + '_departure').val())
      now = new Date()

      nights = 0
      if (!isNaN(departure) and !isNaN(arrival))
        nights = Math.round((departure.getTime() - arrival.getTime()) / DAY)

      if nights < 0
        nights = 0

      # Note that the format of the date of birth is YYYY-MM-DD which even Firefox can parse
      # without special handholding
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
        sp = {}
        sp.name = 'IofC Switzerland'
        sp.nights = nights
        sp.amount = 63
        exports.sponsors.push(sp)
        sponsors['IofC Switzerland'] = {}
        sponsors['IofC Switzerland'].name = 'IofC Switzerland'
        sponsors['IofC Switzerland'].nights = nights
        sponsors['IofC Switzerland'].amount = 63
        calculated_rate_and_fee_details += 'Staff: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
      else if $(base_id + '_rate_volunteer').is(':checked')
        night_rate = 63
        registration_fee = 0
        sp = {}
        sp.name = 'Conference Support Fund (CSF)'
        sp.nights = nights
        sp.amount = 63
        exports.sponsors.push(sp)
        sponsors['Conference Support Fund (CSF)'] = {}
        sponsors['Conference Support Fund (CSF)'].name = 'Conference Support Fund (CSF)'
        sponsors['Conference Support Fund (CSF)'].nights = nights
        sponsors['Conference Support Fund (CSF)'].amount = 63
        calculated_rate_and_fee_details += 'Volunteer: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
      else if $(base_id + '_rate_interpreter').is(':checked')
        night_rate = 63
        registration_fee = 0
        sp = {}
        sp.name = 'Conference Support Fund (CSF)'
        sp.nights = nights
        sp.amount = 63
        exports.sponsors.push(sp)
        sponsors['Conference Support Fund (CSF)'] = {}
        sponsors['Conference Support Fund (CSF)'].name = 'Conference Support Fund (CSF)'
        sponsors['Conference Support Fund (CSF)'].nights = nights
        sponsors['Conference Support Fund (CSF)'].amount = 63
        calculated_rate_and_fee_details += 'Interpreter: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
      else if $(base_id + "_caux_scholar").val() == '1'
        night_rate = 63
        registration_fee = 50
        sp = {}
        sp.name = 'Caux Scholars Program'
        sp.nights = nights
        sp.amount = 63
        exports.sponsors.push(sp)
        sponsors['Caux Scholars Program'] = {}
        sponsors['Caux Scholars Program'].name = 'Caux Scholars Program'
        sponsors['Caux Scholars Program'].nights = nights
        sponsors['Caux Scholars Program'].amount = 63
        calculated_rate_and_fee_details += 'Caux Scholars Program: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
      else if $(base_id + "_caux_intern").val() == '1'
        night_rate = 63
        registration_fee = 250
        sp = {}
        sp.name = 'Caux Interns Program'
        sp.nights = nights
        sp.amount = 63
        exports.sponsors.push(sp)
        sponsors['Caux Interns Program'] = {}
        sponsors['Caux Interns Program'].name = 'Caux Interns Program'
        sponsors['Caux Interns Program'].nights = nights
        sponsors['Caux Interns Program'].amount = 63
        calculated_rate_and_fee_details += 'Caux Interns Program: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
      else if $(base_id + "_week_of_international_community").val() == '1'
        night_rate = 63
        registration_fee = 0
        sp = {}
        sp.name = 'Conference Support Fund (CSF)'
        sp.nights = nights
        sp.amount = 63
        exports.sponsors.push(sp)
        sponsors['Conference Support Fund (CSF)'] = {}
        sponsors['Conference Support Fund (CSF)'].name = 'Conference Support Fund (CSF)'
        sponsors['Conference Support Fund (CSF)'].nights = nights
        sponsors['Conference Support Fund (CSF)'].amount = 63
        calculated_rate_and_fee_details += 'Work week: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'
      else if $(base_id + "_caux_artist").val() == '1'
        night_rate = 63
        registration_fee = 50
        sp = {}
        sp.name = 'Caux Artists Program'
        sp.nights = nights
        sp.amount = 63
        exports.sponsors.push(sp)
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

      if typeof window.package_data[base_id] is 'undefined'
        # Note that find_conference_package does an async ajax call, which will
        # set window.package_data and then calls recalculate_fees() again to update
        # the night_rate
        find_conference_package(base_id,night_rate,$(base_id + "_arrival").val(),$(base_id + "_departure").val())
        $('.conference_package').hide()
      else
        night_rate = window.package_data[base_id].price / nights
        $('.conference_package').show()

      if $(base_id + "_relation").val() != 'primary applicant'
        # Only the primary applicant pays the registration fee
        registration_fee = 0
        calculated_rate_and_fee_details += 'Group or family: night rate: CHF ' + night_rate + '; registration fee: CHF ' + registration_fee + '\n'

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
        if sponsor.amount > night_rate
          console.log('inside loop: ' + sponsor.name)
          # This can happen for children!
          sponsor.amount = night_rate
          sp = {}
          sp.name = sponsor.name
          sp.nights = sponsor.nights
          sp.amount = sponsor.amount
          # Also adjust exports.sponsors
          exports.sponsors.pop()
          exports.sponsors.push(sp)

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
      console.log(sponsor.name)
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
    # Rate changed; wipe out the package_data variable so that we'll check for a conference_package rate again
    window.package_data = []
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

