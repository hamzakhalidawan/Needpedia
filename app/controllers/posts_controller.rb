class PostsController < ApplicationController
	
	before_action :authenticate_user!

	def index
		policy_scope(Post)
		@ptype = params[:post_type] 			
		case params[:tags_filter]
		when nil
				@posts = []
				@all_tags = Tag.all.map do |_| 
				[ _.name, 
					_.posts.type('Problem').count,
					_.posts.type('Idea').count,
					_.posts.type('Proposal').count
				]
			end
		when 'search'
			term = @area = params[:term]
			@all_tags = Tag.where("name ILIKE ?","%#{term}%").map do |_| 
				[ _.name, 
					_.posts.type('Problem').count,
					_.posts.type('Idea').count,
					_.posts.type('Proposal').count
				]
			end 
			render :search_index
		else
			if params[:parent_id]
				@parent_id = params[:parent_id].to_i
				@parent_post = Post.find_by_id @parent_id
				@has_parent = true 	
				@posts = Post.type(params[:post_type]).with_tags([params[:tags_filter]]).where(parent_post_id: params[:parent_id].to_i)
				@tags_count = [[ @parent_post.title , @posts.count]]
			else
				@tags_count = Tag.where(name: @area).map{|_|  [_.name, _.posts.type(params[:post_type]).count] }
				@posts = Post.type(params[:post_type]).with_tags([params[:tags_filter]])
			end
			@area = params[:tags_filter].strip.split(',').first
		end
	end


	def search_index
	end

	def new
		@post = Post.new
		authorize @post
		@post.post_type = params[:post_type]
		@post.all_tags=params[:area] if params[:area]
		@post.parent_post_id = params[:parent_post_id].to_i if params[:parent_post_id]
	end


	def create 
		@post = Post.new(post_params)
		authorize @post
		@post.creator_id = @current_user.id  
		if @post.save
			redirect_to post_path @post
		else 
			render :new
		end
	end

	def show
		@post  = Post.friendly.find(params[:id])
		authorize @post
	end

	# def search
	# 	term = params[:term]
	# 	@posts_array = Tag.where("name ILIKE ?","%#{term}%").includes(:posts).map {|t| [t.name, t.posts_count, t.posts] unless t.posts.empty?}.compact
	# 	# [ tag_name, total_posts, posts_array ]

	# 	byebug 
	# end




private
def post_params
  params.require(:post).permit(:title, :body, :all_tags,:post_type, :parent_post_id)
end


end
