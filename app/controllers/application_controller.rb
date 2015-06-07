class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :handle_intercept

  rescue_from Exception do |exception|
  	logger.error "发生异常，跳转，异常原因为：#{exception.message}"
    logger.error exception.backtrace.inspect
    redirect_to root_path, notice: "系统异常"
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :grade,:password, :password_confirmation) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
  end

  def authenticate_admin_activity
    if not current_user.role?("admin")
      logger.info "对不起，您没有权限访问该网址！"
      flash[:notice] = "对不起，只有管理员才有权限访问该网址！"
      redirect_to root_path
    end
  end

  private
  def handle_intercept
  	redirect_to root_path, notice: "系统暂不开放注册" if "/users/sign_up" == request.path
  end
end
