class Post < ApplicationRecord
	# Use slugs instead of DB IDs in URLs
  include FriendlyId
  friendly_id :title, use: :slugged

	# Associations
	belongs_to :user, foreign_key: "creator_id", class_name: "User"
	has_many :taggings
	has_many :tags, through: :taggings
	has_many :ideas, -> { where(post_type: 'Idea')} , class_name: "Post", foreign_key: "parent_post_id"
	has_many :proposals, -> { where(post_type: 'Proposal')}, class_name: "Post", foreign_key: "parent_post_id"
	has_many :problems, -> { where(post_type: 'Problem')} , class_name: "Post", foreign_key: "parent_post_id"
	
	# Scopes	
	scope :type, ->(post_type){ where(post_type: post_type )}
	scope :with_tags, -> (tags) { joins(:tags).where("tags.name IN (?)",tags) }
	# Validations 
	validates :title, :body, presence: true



	def all_tags=(names)
		self.tags = names.split(",").map do |name|
		    Tag.where("name ILIKE ?",name.strip).first_or_create!(name: name.strip)
		end
	end

	def all_tags
	  self.tags.map(&:name).join(", ")
	end

	def area
		self.tags.map(&:name).first
	end

end
