class PostsController < ApplicationController
	
	before_action :authenticate_user!

	def index
		policy_scope(Post)
		@ptype = params[:post_type] 			
		
		case params[:tags_filter]
		when nil
			@tags_count = Tag.all.map{|_|  [_.name, _.posts.type(params[:post_type]).count] }
			@posts = Post.type(params[:post_type])
		else
			@posts = Post.type(params[:post_type]).with_tags([params[:tags_filter]])
			@area = params[:tags_filter].strip.split(',').first
			@tags_count = Tag.where(name: @area).map{|_|  [_.name, _.posts.type(params[:post_type]).count] }
		end
	end


	def new
		@post = Post.new
		authorize @post
		@post.post_type = params[:post_type]
		@post.all_tags=params[:area] if params[:area]
	end


	def create 
		@post = Post.new(post_params)
		authorize @post
		@post.creator_id = @current_user.id 
		if @post.save
			@posts = Post.type(params[:post][:post_type])
			@ptype = params[:post][:post_type]
			redirect_to "/posts?post_type=#{@ptype}"
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
  params.require(:post).permit(:title, :body, :all_tags,:post_type)
end

end
