class Api::V1::ApplicationsController < ApplicationController
    # GET /api/v1/applications
    def index
      @applications = fetch_applications_redis
      render json: @applications, :except =>  ["id"], status: :ok
     end

    # POST /api/v1/applications?name=app_name
    def create
      message = {
        "action":"createApplication",
        "attributes":{
          "name": params[:name]
        }
      }

      Publisher.publish("chat_system.worker", message)

      response = {
        "message":"created application with name: #{params[:name]}"
      }

      render json: response, :except =>  ["id"], status: :created
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
      Publisher.publish("chat_system.worker", message)

      response = {
        "message":"updated application #{params[:token]} with name: #{params[:name]}"
      }

      render json: response, status: :ok
    end

    def fetch_applications_redis
      applications = $redis.get("applications")  #This line requests redis-server to accepts any value associate with articles key
      if applications.nil?  #this condition will executes if any articles not available on redis server
        applications = Application.all.to_json
        $redis.set("applications", applications)
        $redis.expire("applications", 10.seconds.to_i)
      end

      JSON.load applications #This will converts JSON data to Ruby Hash
    end

end
