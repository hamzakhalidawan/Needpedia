class Post < ApplicationRecord
	belongs_to :user, foreign_key: "creator_id", class_name: "User"

	scope :type, ->(post_type){ where(post_type: post_type )}

end
