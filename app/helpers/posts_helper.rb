module PostsHelper
	def can_edit? post
		current_user.id == post.creator_id || current_user.admin?
	end
end
