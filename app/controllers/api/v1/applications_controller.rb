class Api::V1::ApplicationsController < ApplicationController
    before_action :set_application, only: [:update]

    # GET /applications
    def index
     @apps = Application.all
     render json: @apps, :except =>  [:id], status: :ok
    end

    # POST /applications
    def create
      @application = Application.new(application_params)


      if @application.save
        render json: @application, :except =>  [:id], status: :created
      else
        render json: @application.errors, status: :bad_request
      end

    end

    # PUT /applications/:token
    def update
      if @application.update(application_params)
        render json: @application, :except => [:id], status: :ok
      else
        render json: @application.errors, status: :bad_request
      end
    end


    private

      def application_params
        params.permit(:name)
      end

      def set_application
        @application = Application.find_by(token: params[:token])
      end

end