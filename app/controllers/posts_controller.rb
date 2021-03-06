class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def show
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    this_post = Post.create!(user_id: current_user.id, message: params[:post][:message])
    if !(params[:post][:image].nil?)
      if !Album.default_album_exists?(current_user)
        Album.create(title: "#{current_user.first_name}'s Photos", user_id: current_user.id)
      end
      Photo.create!(post_id: this_post.id, image: params[:post][:image], album_id: Album.users_default_album(current_user).id, user_id: current_user.id)
    end
    redirect_to posts_url
  end

  def update
    current_user.posts.find(params[:id]).update(message: params[:post][:message])
    redirect_to posts_url
    rescue
      redirect_to posts_url, notice: "Not your post"
  end

  def index
    @post = Post.new
    @posts_with_users = Post.left_outer_joins(:user)
                        .select('posts.*', 'users.first_name', 'users.last_name')
                        .order("posts.created_at DESC")
  end

  def destroy
    current_user.posts.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
    rescue
      redirect_to posts_url, notice: "Not your post"
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def create_album
    end
end
