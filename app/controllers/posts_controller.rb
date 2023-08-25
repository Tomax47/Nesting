class PostsController < ApplicationController
  def index
    @posts = Post.all.order("created_at DESC")
  end

  def show
    @post = Post.find(params[:id])
  end


  def new
    @post = Post.new
  end


  def create
    @post = Post.new(post_params)

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
    @post = set_post

    if @post.update(post_params)
      redirect_to post_url(@post)
    else
      redirect_to post_url(@post), notice: "Couldn't update the post!"
    end
  end


  def destroy
    @post = set_post

    if @post.destroy
      redirect_to posts_path, notice: "Post has been deleted!"
    else
      redirect_to post_url(@post), notice: "Couldn't delete the post!"
    end
  end


  private

  def set_post
    return Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end


end
