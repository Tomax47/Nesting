class LikesController < ApplicationController


  def create
    @like = current_user.likes.new(like_params)

    if @like.save
      redirect_to @like.post
    else
      flash[:notice] = @like.errors.full_messages.to_sentence
    end
  end



  def destroy
    @like = current_user.likes.find(params[:id])
    @post = @like.post
    if @like.destroy
      redirect_to post_url(@post)
    else
      flash[:notice] = "Something went wrong!"
    end
  end



  private

  def like_params
    params.require(:like).permit(:post_id)
  end
end
