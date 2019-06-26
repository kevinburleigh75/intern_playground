require 'json-schema'

class RequestHandler

  #json_schema =  'http://json-schema.org/draft-07/schema#'

  # rescue_from Errors::AppReqValError, with: :render_app_req_val_error
  def record_request(request:)
      start = Time.now

      yield

      elapsed = Time.now - start

      instance_id = 'fake_instance_id'
      image_id = 'fake_image_id'

      request_record = RequestRecord.new(
          uuid: SecureRandom.uuid.to_s,
          request_elapsed: elapsed,
          instance_id: instance_id,
          image_id: image_id,
      )
      request_record.save!
    end


  def validate_json(json_payload:)

  end

  ######################### Helpers ##############################

  def with_json_apis(input_schema: nil, output_schema: nil, &block)

  end

  def validate_and_parse_request(input_schema)
    return {} if input_schema.nil?

    if request.content_type != 'application/json'
      # fail Errors::AppReqValError('must have content-type application/json')
    end


  end

  def render_app_req_val_error(exception)
    request.body.rewind
    request_body = request.body.read
    payload = {
        errors: exception.errors,
        request: request_body
    }
    render json: payload, status: 400
  end

end