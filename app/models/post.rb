class Post < ApplicationRecord
	belongs_to :user, foreign_key: "creator_id", class_name: "User"
end
