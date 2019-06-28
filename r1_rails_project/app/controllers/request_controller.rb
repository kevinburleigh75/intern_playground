class RequestController < ApplicationController

  around_action :record_request

  def create_post
    req = request.request_parameters.deep_symbolize_keys[:request]
    response_payload = HelloService.new.process(req)
    # RequestHandler.new.validate_json(request)
    render json: response_payload, status: 200

  end

  def create_get
    req = request.request_parameters.deep_symbolize_keys[:request]
    response_payload = PingService.new.process(req)
    render json: response_payload, status: 200
  end



  def record_request # request is in the form {uuid: }
    req = request.request_parameters.deep_symbolize_keys[:request]
    start = Time.now

    yield

    elapsed = Time.now - start

    ActiveRecord::Base.transaction(isolation: :repeatable_read, requires_new: true) do
      request_record = RequestRecord.new(
          uuid: req[:uuid],
          endpoint: request.fullpath,
          elapsed: elapsed
      )
      request_record.save!
    end
  end


end