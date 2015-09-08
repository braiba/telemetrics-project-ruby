class User < ActiveRecord::Base
    has_many :journeys
    has_secure_password
end
