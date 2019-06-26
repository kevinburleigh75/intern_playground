class RequestController < ApplicationController
  def create_post
    req = request.request_parameters.deep_symbolize_keys[:request]
    debugger
    response_payload = HelloService.new.process(req)
    around_action :RequestHandler.new.record_request(req)
    # RequestHandler.new.validate_json(request)
    render json: response_payload, status: 200

  end

  def create_get
    # req = request.request_parameters.deep_symbolize_keys[:request]
    # response_payload = PingService.new.process(req)
    render json: response_payload, status: 200
  end

end