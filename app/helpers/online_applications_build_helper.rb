module OnlineApplicationsBuildHelper

  def tutorial_progress_bar
    wizard_steps[wizard_steps.index(step)]
  end

end
