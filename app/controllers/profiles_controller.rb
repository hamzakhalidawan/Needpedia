class ProfilesController < ApplicationController
  def edit
  @profile = current_user.profile
  end

  def update
      @profile = current_user.profile
    respond_to do |format|
      if @profile.update profile_params
        format.html { redirect_to edit_profile_path, notice: "Profile updated!" }
        format.json { render :edit, status: :ok, location: @profile }
      else
        format.html { redirect_to edit_profile_path, flash: { error: "Profile could not be updated!" } }
        format.json { render json: @profile.errors.messages, status: :unprocessable_entity }
      end
    end
  end
end
