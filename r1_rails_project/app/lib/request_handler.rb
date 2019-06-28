require 'rj_schema'

class RequestHandler


  #json_schema =  'http://json-schema.org/draft-07/schema#'

  def record_request(req, endpoint) # request is in the form {uuid: }
      start = Time.now

      yield

      elapsed = Time.now - start

      ActiveRecord::Base.transaction(isolation: :repeatable_read, requires_new: true) do
        request_record = RequestRecord.new(
            uuid: req[:uuid],
            endpoint: endpoint,
            elapsed: elapsed
        )
        request_record.save!
      end
  end

  def validate_json(json_payload:)
    # RjSchema::Validator.new.validate()

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