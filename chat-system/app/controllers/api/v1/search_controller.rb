class Api::V1::SearchController < ApplicationController

  def search
    if params[:q].nil?
      @messages = []
      render json: @messages, :except => ["_id"], status: :bad_request
    else
      message = {
        "action":"searchMessages",
        "attributes":{
          "q": params[:q],
          "application_token": params[:application_token],
          "chat_number": params[:chat_number],
        }
      }

      res = JSON.parse(Publisher.publish("chat_system.worker", message))
      render json: res['payload'], :except =>  ["_id"], status: :ok
    end
  end
end
