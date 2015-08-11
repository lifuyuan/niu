require 'net/http'
class Api::SessionsController < ApplicationController
# before_filter :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    ##验证邮箱是否存在
    user = User.where(:name => params[:user][:name]).first
    return render json: {error: {status:-1}} unless user
 
    respond_to do |format|
      #验证密码是否正确
      if user.valid_password?(params[:user][:password])
        sign_in("user", user)
        user.ensure_authentication_token
        format.json { 
          render json: {token:user.authentication_token, user_id: user.id.to_s}
        }
      else
        format.json {
          render json: {error: {status:-1}}
        }
      end
    end
  end

  # POST /user/code
  def createcode
    code = rand(9999).to_s
    logger.info "#{params[:phone]}"
    url = "http://yunpian.com/v1/sms/send.json"
    res = Net::HTTP.post_form(URI.parse(url), apikey: "c03c12c5190d7d8d5af68d294cd97b1a", mobile: "#{params[:phone]}", text: "【喜点科技】您的验证码为#{code}，在30分钟内有效。如非本人操作，请忽略本短信。")
    logger.info res.body
    logger.info res.code
    if res.code == "200"
      result = JSON.parse(res.body)
      if result["code"] == 0
        render json: {code:code}
      else
        render json: {error: {status:-1}}
      end
    else
      render json: {error: {status:-1}}
    end
  end

  # POST /user/tokenverify
  def tokenverify
    if User.where(authentication_token: params[:token]).first.nil?
      render json: {result: false}
    else
      render json: {result: true}
    end
  end

  # DELETE /resource/sign_out
  #注销就是更换用户token
  def destroy
    current_user.authentication_token = Devise.friendly_token
    sign_out(current_user)
    render json: {success: true}
  end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end
