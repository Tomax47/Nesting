class CommentsController < ApplicationController

  before_action :correct_User, only: [:destroy]

  def new
    @comment = current_user.comments.new
  end


  def create
    @comment = current_user.comments.new(comment_params)

    if @comment.save
      redirect_to post_comments_path
    else
      flash.now[:notice] = "Couldn't create the comment!"
    end
  end


  def destroy
   @comment = current_user.comments.find(params[:id])

  if @comment.destroy
      redirect_to post_comments_path
      else
      flash[:notice] = "Couldn't delete the comment!"
       end
  end


  private

  def correct_User
    @comment = current_user.comments.find_by(id: params[:id])
    redirect_to post_comments_path, notice: "You are not authorized to delete this comment!" if @comment.nil?
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_id).merge(post_id: params[:post_id])
  end
end
