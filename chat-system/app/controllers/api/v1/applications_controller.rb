class Api::V1::ApplicationsController < ApplicationController
    # GET /api/v1/applications
    def index
      message = {
        "action":"getAllApplications",
        "attributes":{}
      }

      res = JSON.parse(Publisher.publish("chat_system.worker", message))
      render json: res['payload'], :except =>  ["id"], status: :ok
    end

    # POST /api/v1/applications?name=app_name
    def create
      message = {
        "action":"createApplication",
        "attributes":{
          "name": params[:name]
        }
      }
      res = JSON.parse(Publisher.publish("chat_system.worker", message))
      puts res
      puts res['success']
      if res['success']
        render json: res['payload'], :except =>  ["id"], status: :created
      else
        render json: res['payload'], status: :bad_request
      end

    end

    # PUT /api/v1/applications/:token
    def update
      message = {
        "action":"updateApplication",
        "attributes":{
          "token": params[:token],
          "name": params[:name]
        }
      }
      res = JSON.parse(Publisher.publish("chat_system.worker", message))

      if res['success']
        render json: res['payload'], :except =>  ["id"], status: :ok
      else
        render json: res['payload'], status: :bad_request
      end
    end

end
