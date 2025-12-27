class Api::V1::MessagesController < ApplicationController
  def index
    conversation = find_conversation(params[:conversation_id])
    
    unless conversation
      return render json: { error: 'Conversation not found' }, status: :not_found
    end

    messages = conversation.messages.order(created_at: :asc)
    
    render json: {
      messages: messages.map do |message|
        {
          id: message.id,
          body: message.body,
          sender_id: message.sender_id,
          receiver_id: message.receiver_id,
          read: message.read,
          created_at: message.created_at
        }
      end
    }, status: :ok
  end

  def create
    conversation = find_conversation(params[:conversation_id])
    
    unless conversation
      return render json: { error: 'Conversation not found' }, status: :not_found
    end

    # For now, assume 2-person conversations. Get the other user as receiver
    receiver = conversation.other_user(current_user)
    
    unless receiver
      return render json: { error: 'Cannot determine receiver for this conversation' }, status: :unprocessable_entity
    end
    
    message = conversation.messages.build(
      sender: current_user,
      receiver: receiver,
      body: params[:body]
    )

    if message.save
      render json: {
        id: message.id,
        body: message.body,
        sender_id: message.sender_id,
        receiver_id: message.receiver_id,
        read: message.read,
        created_at: message.created_at,
        message: 'Message sent successfully'
      }, status: :created
    else
      render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def find_conversation(id)
    conversation = Conversation.find_by(id: id)
    return nil unless conversation
    
    # Ensure current user is part of this conversation
    if conversation.users.include?(current_user)
      conversation
    else
      nil
    end
  end
end

