class Api::V1::ConversationsController < ApplicationController
  def index
    # binding.irb
    conversations = current_user.conversations
      .includes(:users, :messages)
      .order(updated_at: :desc)

    conversations_data = conversations.map do |conversation|
      other_user = conversation.other_user(current_user)
      last_message = conversation.messages.order(created_at: :desc).first
      
      {
        id: conversation.id,
        other_user: other_user ? {
          id: other_user.id,
          username: other_user.username,
          first_name: other_user.first_name,
          last_name: other_user.last_name
        } : nil,
        last_message: last_message ? {
          body: last_message.body,
          sender: last_message.sender.first_name + ' ' + last_message.sender.last_name,
          # created_at: last_message.created_at,
          # sender_id: last_message.sender_id
        } : nil,
        unread_count: conversation.messages.where(receiver: current_user, read: false).count,
        # updated_at: conversation.updated_at
      }
    end
    # binding.irb
    render json: { conversations: conversations_data }, status: :ok
  end

  def show
    conversation = find_conversation(params[:id])
    
    if conversation
      other_user = conversation.other_user(current_user)
      messages = conversation.messages.order(created_at: :asc)
      
      # Mark messages as read
      conversation.messages.where(receiver: current_user, read: false).update_all(read: true)
      
      render json: {
        id: conversation.id,
        other_user: other_user ? {
          id: other_user.id,
          username: other_user.username,
          first_name: other_user.first_name,
          last_name: other_user.last_name
        } : nil,
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

    # Find existing conversation or create new one
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

