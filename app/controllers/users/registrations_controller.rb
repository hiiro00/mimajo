# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    logger.debug("■SessionsController createに入りました")
    logger.debug(params)
    logger.debug(params[:user][:email])
    logger.debug(User.last(10))
    
    # ユニークidを取得
    if User.last.blank?
      logger.debug("■Userにひとつもデータがなかった")
      num = 1
    else
      num = User.maximum(:id).next
    end
    # ユニーク emailを設定
    params[:user][:email] = (num.to_s + '@mimajomail')
    
    sign_up_params[:password] = "mimajopass"
    sign_up_params[:password_confirmation] = "mimajopass"
    
    logger.debug("■sign_up_paramsパラメータ変更後")
    logger.debug(sign_up_params)

    super
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
