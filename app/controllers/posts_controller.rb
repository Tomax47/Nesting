class PostsController < ApplicationController

  before_action :ensure_user
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @posts = Post.all.order("created_at DESC")
  end

  def show
    @post = Post.find(params[:id])
  end


  def new
    @post = current_user.posts.new
  end


  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to post_url(@post)
    else
      render 'new', notice: "Couldn't create the post!"
    end

  end

  def edit
    @post = set_post
  end

  def update
    @post = current_user.posts.find(params[:id])

    if @post.update(post_params)
      redirect_to post_url(@post)
    else
      redirect_to post_url(@post), notice: "Couldn't update the post!"
    end
  end


  def destroy
    @post = current_user.posts.find(params[:id])
    #TODO: FIND A WAY TO DELETE THE COMMENTS AND THE LIKES ASSOCIATED WITH THE POST WHEN DELETING THE POST ITSELF!
    # WHAT'S CAUSING THE PROBLEM, IT THAT WHEN DELETING THE POST, THE COMMENTS AND THE LIKES ASSOCIATED WITH IT AIN'T GETTING DELETED, SO IT SHOWS A SQLLITE NOTNULLVIOLATION ERROR, AS THE COMMENTS AND LIKES POST_ID CAN'T BE NULL!!!

    if @post.destroy
      redirect_to posts_path, notice: "Post has been successfully deleted!"
    else
      redirect_to @post
      flash[:notice] = "Can't delete the post!"
    end
  end


  private

  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to root_path, notice: "You are not authorized to edit this post!" if @post.nil?
  end

  def set_post
    return Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end


end
