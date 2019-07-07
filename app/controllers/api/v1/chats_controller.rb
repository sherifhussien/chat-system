class Api::V1::ChatsController < ApplicationController
  before_action :set_application
  before_action :set_chat, only: [:update]


  # GET /applications/:application_token/chats
  def index
    @chats = @application.chats
    render json: @chats, :except =>  [:id]
  end

  # POST /applications/:application_token/chats
  def create
    # like create_by, except that if validations fail, raises a RecordInvalid error
    @chat = @application.chats.create!()
    render json: @chat, :except => [:id], status: :created
  end

  # PUT /applications/:applicationn_token/chats/:number
  def update
    if @chat.update(chat_params)
      render json: @chat, :except => [:id], status: :ok
    else
      render json: @chat.errors, status: :bad_request
    end
  end


  private

    # no need but implemented as required to show the update action
    def chat_params
      params.permit(:number)
    end

    def set_application
      @application = Application.find_by(token: params[:application_token])
    end

    def set_chat
      # like find_by, except that if no record is found, raises an ActiveRecord::RecordNotFound error
      @chat = @application.chats.find_by!(number: params[:number]) if @application
    end
end
