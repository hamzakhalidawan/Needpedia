class Tag < ApplicationRecord

# Associations
has_many :taggings
has_many :posts, through: :taggings


def posts_count
 ["Problem", "Idea", "Proposal"].map! do |post_type|
 	[post_type, self.posts.where(:post_type => post_type).count]	
 end
end


end
