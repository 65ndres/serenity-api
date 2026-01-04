class Api::V1::ConversationsController < ApplicationController
  def index

    conversations = current_user.conversations
      .includes(:users, :messages)
      .order(updated_at: :desc)

    conversations_data = conversations.map do |conversation|
      last_message = conversation.messages.includes(:verse).order(created_at: :desc).first
      unread_count = conversation.messages.where.not(sender: current_user).where(read: false).count
      
      {
        id: conversation.id,
        conversation_name: conversation.name,
        read: conversation.read,
        last_message: last_message ? {
          verse: last_message.verse.address,
          time: last_message.created_at.strftime("%d %b %Y"),
          read: last_message.read
        } : nil,
        unread_count: unread_count
      }
    end
    render json: { conversations: conversations_data }, status: :ok
  end

  def new
    conversation = find_conversation

    if conversation
      messages = conversation.messages.includes(:verse, :sender).order(created_at: :asc)
      
      # Mark messages as read when viewing them (mark messages sent by others as read)
      conversation.messages.where.not(sender: current_user).where(read: false).update_all(read: true)
      conversation.update(read: true)
      render json: {
        id: conversation.id,
        current_user_id: current_user.id,
        conversation_name: conversation.name,
        messages: messages.map do |message|
          {
            id: message.id,
            sender_id: message.sender_id,
            address: message.verse.address,
            created_at: message.created_at
          }
        end
      }, status: :ok
    elsif conversation.nil?
      other_user = User.find(params[:other_user_id]) 
      conversation = Conversation.create(name: other_user.username)
      conversation.user_conversations.create(user: current_user)
      conversation.user_conversations.create(user: other_user)
      conversation.update(read: true)
      render json: {
        id: conversation.id,
        current_user_id: current_user.id, 
        conversation_name: conversation.name,
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


  def find_conversation
    conversation = nil
    if params[:conversation_id]
      conversation = Conversation.find_by(id: params[:conversation_id])
    elsif params[:other_user_id]
      conversation = Conversation.between(current_user, User.find(params[:other_user_id]))
    end
    conversation
  end
end

