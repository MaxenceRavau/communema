class MessagesController < ApplicationController

  def new
    @message = Message.new
    authorize @message
  end

  def create
    @message = Message.new(message_params)
    @message.sharing = @sharing
    @message.user = current_user
    authorize @message
    if @message.save
      redirect_to messages_path
    else
      render :new
    end
  end

  private

  def message_params
    params.require(:message).permit(:comment)
  end
end
