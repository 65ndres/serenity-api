class Api::V1::ConversationsController < ApplicationController
  def index

    conversations = current_user.conversations
      .includes(:users, :messages)
      .order(updated_at: :desc)

    conversations_data = conversations.map do |conversation|
      last_message = conversation.messages.order(created_at: :desc).first
      
      {
        id: conversation.id,
        last_message: last_message ? {
          verse: last_message.verse.address,
          sender: "lol"
        } : nil,
        unread_count: 0
      }
    end
    render json: { conversations: conversations_data }, status: :ok
  end

  def new
    conversation = find_conversation(params[:conversation_id])
    
    if conversation
      messages = conversation.messages.order(created_at: :asc)
      
      render json: {
        id: conversation.id,
        current_user_id: current_user.id, 
        messages: messages.map do |message|
          {
            id: message.id,
            sender_id: message.sender_id,
            address: message.verse.address,
            read: message.read,
            created_at: message.created_at
          }
        end
      }, status: :ok
    elsif conversation.nil?
      conversation = Conversation.create
      conversation.user_conversations.create(user: current_user)
      conversation.user_conversations.create(user: User.find(params[:other_user_id]))
      render json: {
        id: conversation.id,
        current_user_id: current_user.id, 
        messages: []
      }, status: :ok
    else
      render json: { error: 'Conversation not found' }, status: :not_found
    end
  end

  def create
    receiver = User.find_by(username: params[:receiver_username])
    
    unless receiver
      return render json: { error: 'User not found' }, status: :not_found
    end

    if receiver == current_user
      return render json: { error: 'Cannot create conversation with yourself' }, status: :unprocessable_entity
    end

    conversation = Conversation.between(current_user, receiver)
    
    unless conversation
      conversation = Conversation.create
      
      unless conversation.persisted?
        return render json: { errors: conversation.errors.full_messages }, status: :unprocessable_entity
      end
      
      # Add both users to the conversation
      conversation.user_conversations.create(user: current_user)
      conversation.user_conversations.create(user: receiver)
    end

    render json: {
      id: conversation.id,
      message: 'Conversation created successfully'
    }, status: :created
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

