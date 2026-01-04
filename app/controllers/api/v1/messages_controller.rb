class Api::V1::MessagesController < ApplicationController
  def index
    conversation = find_conversation(params[:conversation_id])
    
    unless conversation
      return render json: { error: 'Conversation not found' }, status: :not_found
    end

    messages = conversation.messages.includes(:sender, :verse).order(created_at: :asc)
    
    # Mark messages as read when viewing them (mark messages sent by others as read)
    conversation.messages.where.not(sender: current_user).where(read: false).update_all(read: true)
    
    render json: {
      messages: messages.map do |message|
        {
          id: message.id,
          sender: {
            id: message.sender.id,
            username: message.sender.username,
            first_name: message.sender.first_name,
            last_name: message.sender.last_name
          },
          address: message.verse&.address,
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

    message = conversation.messages.new(verse_id: params[:verse_id], sender: current_user)


    if message.save
      render json: {
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

