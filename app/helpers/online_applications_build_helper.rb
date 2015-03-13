module OnlineApplicationsBuildHelper

def tutorial_progress_bar

  wizard_steps[wizard_steps.index(step)]


#<div class="progress">
#  <div class="progress-bar" role="progressbar" aria-valuenow="70"
#  aria-valuemin="0" aria-valuemax="100" style="width:<%= wizard_steps.index(step)/wizard_steps.size -%>%">
#    <span class="sr-only">70% Complete</span>
#  </div>
#</div>

end

end
