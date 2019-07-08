class Api::V1::MessagesController < ApplicationController
  before_action :set_application_and_chat
  before_action :set_message, only: [:update]

  # GET /applications/:application_token/chats/:chat_number/messages
  def index
    @message = @chat.messages
    render json: @message, :except =>  [:id]
  end

  # POST /applications/:application_token/chats/:chat_number/messages
  def create
    # like create_by, except that if validations fail, raises a RecordInvalid error
    @message = @chat.messages.create!(chat_params)

    render json: @message, :except => [:id], status: :created
  end

  # PUT /applications/:application_token/chats/:chat_number/messages/:number
  def update
    if @message.update(chat_params)
      render json: @message, :except => [:id], status: :ok
    else
      render json: @message.errors, status: :bad_request
    end
  end


  private

    def chat_params
      params.permit(:content)
    end

    def set_application_and_chat
      @application = Application.find_by(token: params[:application_token])
      @chat = @application.chats.find_by!(number: params[:chat_number]) if @application
    end

    def set_message
      @message = @chat.messages.find_by!(number: params[:number]) if @chat
    end
end
