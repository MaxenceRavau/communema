class MessagesController < ApplicationController

  def new
    @message = Message.new
    authorize @message
  end

  def create
    @sharing = Sharing.find(params[:chatroom_id])
    @message = Message.new(message_params)
    @message.sharing = @sharing
    @message.user = current_user
    if @message.save
      redirect_to sharing_path(@sharing)
    else
      render "sharings/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:comment)
  end
end




# @message = Message.new(message_params)
# @message.sharing = @sharing
# @message.user = current_user
# authorize @message
# if @message.save
#   redirect_to messages_path
# else
#   render :new
# end
