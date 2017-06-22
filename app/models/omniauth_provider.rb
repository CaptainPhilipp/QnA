class OmniauthProvider < ApplicationRecord
   devise omniauth_provider: [:facebook]

   belongs_to :user

   def find_or_create(auth_hash)
     find_by(auth_hash) || create(auth_hash)
   end
end
