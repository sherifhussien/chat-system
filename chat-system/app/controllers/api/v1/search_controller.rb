class Api::V1::SearchController < ApplicationController

  def search

    if params[:q].nil?
      @messages = []
      render json: @messages, :except => ["_id"], status: :bad_request
    else

      @application = Application.find_by(token: params[:application_token])
      @chat = @application.chats.find_by!(params[:chat_number]) if @application
      @messages = @chat.messages.search(params[:q])

      render json: @messages, :except =>  ["_id"], status: :ok
    end
  end
end
