class HellosController < ApplicationController
  def hello
    response_body = HelloService.new.process(request.request_parameters.deep_symbolize_keys)
    render json: response_body, status: 200
  end
end
