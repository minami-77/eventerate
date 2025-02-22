class UsersController < ApplicationController
  def change_profile_picture
    authorize current_user
    current_user.photo.purge if current_user&.photo.attached?
    current_user.update(photo_params)
  end

  private

  def photo_params
    params.require(:user).permit(:photo)
  end
end
