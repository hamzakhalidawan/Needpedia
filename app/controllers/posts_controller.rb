class PostsController < ApplicationController
	
	before_action :authenticate_user!

	def index
		policy_scope(Post)
		if params[:post_type]
			@posts = Post.type(params[:post_type])
			@ptype = params[:post_type]
		else
			@posts = Post.all
		end
	end

	def new
		@post = Post.new
		authorize @post
		@post.post_type = params[:post_type]
	end


	def create 
		@post = Post.new(post_params)
		authorize @post
		@post.creator_id = @current_user.id 
		@post.save
		@posts = Post.type(params[:post][:post_type])
		@ptype = params[:post][:post_type]
		redirect_to "/posts?post_type=#{@ptype}"
	end

	def show
		@post  = Post.friendly.find(params[:id])
		authorize @post
	end



private
def post_params
  params.require(:post).permit(:title, :body, :all_tags,:post_type)
end

end
