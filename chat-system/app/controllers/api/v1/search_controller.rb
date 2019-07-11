class Api::V1::SearchController < ApplicationController

  def search
    if params[:q].nil?
      @messages = []
      render json: @messages, :except => [:id], status: :bad_request
    else
      @messages = Message.search(params[:q])
      render json: @messages, :except => [:_id], status: :ok
    end
  end
end
