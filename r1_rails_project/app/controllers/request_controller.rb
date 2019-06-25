class RequestController < ApplicationController
  def create_post
    req = request.request_parameters.deep_symbolize_keys[:request]
    response_payload = HelloService.new.process(req)
    render json: response_payload, status: 200
  end

  def create_get
    req = request.request_parameters.deep_symbolize_keys[:request]
    response_payload = PingService.new.process(req)
    render json: response_payload, status: 200
  end

  # around_action :record_request
  #
  # def record_request
  #   start = Time.now
  #
  #   yield
  #
  #   elapsed = Time.now - start
  #
  #   instance_id = 'fake_instance_id'
  #   image_id = 'fake_image_id'
  #
  #   request_record = RequestRecord.new(
  #       uuid: SecureRandom.uuid.to_s,
  #       request_fullpath: request.fullpath,
  #       request_elapsed: elapsed,
  #       instance_id: instance_id,
  #       image_id: image_id,
  #       processed: false
  #   )
  #
  #   request_record.save!
  # end

end