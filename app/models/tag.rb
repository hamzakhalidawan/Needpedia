class Tag < ApplicationRecord

# Associations
has_many :taggings
has_many :posts, through: :taggings

end
