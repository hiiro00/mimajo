class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable,
         :omniauthable, omniauth_providers: [:twitter]
         
  class << self
    def find_or_create_for_oauth(auth)
      logger.debug("xxxxx  twitter auth log!!!")
      logger.debug("auth=#{auth}")
      logger.debug("auth.provider=#{auth.provider}")
      logger.debug("auth.uid=#{auth.uid}")
      logger.debug("auth.info.name=#{auth.info.name}")
      logger.debug("auth.info.email=#{auth.info.email}")
      find_or_create_by!(email: User.checked_email(auth)) do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.name = auth.info.name
        user.email = User.checked_email(auth)
        password = Devise.friendly_token[0..5]
        logger.debug password
        user.password = password
      end
    end
    
    def checked_email(auth)
      if auth.info.email.blank?
        "#{auth.uid}-#{auth.provider}@example.com"
      else
        auth.info.email
      end
    end

    def new_with_session(params, session)
      if user_attributes = session['devise.user_attributes']
        new(user_attributes) { |user| user.attributes = params }
      else
        super
      end
    end
  end
end
