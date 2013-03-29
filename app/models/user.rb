class User < ActiveRecord::Base
  attr_accessible :clef_id, :email

  def self.find_or_create_from_auth_hash(auth_hash)
    if user = User.find_by_clef_id(auth_hash[:uid])
        user
    else
        User.create(
            clef_id: auth_hash[:uid],
            email: auth_hash[:info][:email]
        )
    end
  end
end
