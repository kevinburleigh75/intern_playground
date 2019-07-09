class PingsController < ApplicationController
  def ping
    PingService.new.process
    render json: {}, status: 200
  end
end
