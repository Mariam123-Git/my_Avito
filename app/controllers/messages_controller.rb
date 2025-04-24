class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = Message
  .select("DISTINCT ON (LEAST(sender_id, recipient_id), GREATEST(sender_id, recipient_id)) *")
  .where("sender_id = ? OR recipient_id = ?", current_user.id, current_user.id)
  .order(Arel.sql("LEAST(sender_id, recipient_id), GREATEST(sender_id, recipient_id), created_at DESC"))
  .includes(:sender, :recipient, :listing)
  end

  def show
    @other_user = User.find(params[:id])
    @messages = Message.between(current_user, @other_user)
                      .order(created_at: :asc)
                      .includes(:listing)

    # Mark messages as read
    @messages.where(recipient: current_user, read: false).update_all(read: true)

    @message = Message.new
    @listings = @other_user.listings.active.recent
  end

  def create
    @message = current_user.sent_messages.build(message_params)

    if @message.save
      redirect_to message_path(@message.recipient), notice: "Message envoyé avec succès."
    else
      redirect_back fallback_location: messages_path, alert: "Erreur lors de l'envoi du message."
    end
  end
  def new
    @message = Message.new
    @recipient = User.find(params[:recipient_id])  # Par exemple, vous récupérez l'utilisateur destinataire
    @listing = Listing.find(params[:listing_id])   # Si le message est associé à une annonce
  end
  private
    def message_params
      params.require(:message).permit(:content, :sender_id, :recipient_id, :listing_id)
    end
end
