class Api::RegistrationsController < ApplicationController
	def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.json { render json: { success: true, token:@user.authentication_token, user_id:@user.id.to_s }}
      else
        format.json { render json: { error: {status:-1, info: @user.errors.full_messages} } }  
      end
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :grade, :password, :password_confirmation)
  end
end