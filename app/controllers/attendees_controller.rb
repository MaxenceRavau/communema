class AttendeesController < ApplicationController
  # skip_before_action :verify_authenticity_token, only: [:create]

  def create
    @sharing = Sharing.find(params[:sharing_id])
    @attendee = Attendee.new
    @attendee.sharing = @sharing
    @attendee.user = current_user
    authorize @attendee
    if @attendee.save
      render json: {
        sharing_card_html: render_to_string(partial: "sharings/sharing_card", locals: { sharing: @sharing }, layout: false, formats: :html)
      }.to_json
    else
    end
  end

end
