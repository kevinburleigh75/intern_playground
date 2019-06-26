require 'json-schema'

class RequestHandler

  #json_schema =  'http://json-schema.org/draft-07/schema#'

  def record_request(request:) # request is in the form {uuid: }
      start = Time.now

      yield

      elapsed = Time.now - start

      test_instance_id = "i-01f61e42a73670c18"
      test_image_id = "ami-5fb8c835"

      request_record = RequestRecord.new(
          uuid: req[:uuid],
          instance_id: test_instance_id,
          image_id: test_image_id,
          elapsed: elapsed
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