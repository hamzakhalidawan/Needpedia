class PostsController < ApplicationController
	
	before_action :authenticate_user!

	def index
		policy_scope(Post)
		if params[:post_type]
			@posts = Post.type(params[:post_type])
		else
			@posts = Post.all
		end
	end

	def new
		@post = Post.new
		authorize @post
		@post_type = "Problem"
	end


	def create 
		@post = Post.new
		authorize @post
		@post.title = params[:post][:title]
		@post.body = params[:post][:body]
		@post.post_type = params[:post][:post_type]
		@post.creator_id = @current_user.id 
		@post.save
		@posts = Post.all
		render :index
	end

	def show
		@post  = Post.friendly.find(params[:id])
		authorize @post
	end

end
