class SharingChannel < ApplicationCable::Channel
  def subscribed
    sharing = Sharing.find(params[:id])
    stream_for sharing
  end
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
