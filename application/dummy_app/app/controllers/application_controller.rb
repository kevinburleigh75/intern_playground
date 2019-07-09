class ApplicationController < ActionController::Base

  def with_validations(input_schema: nil, output_schema: nil)
    unless input_schema.nil?
      request.body.rewind
      JSON.parse(request.body.read).tap do |request_payload|
        validation_errors = RjSchema::Validator.new.validate(input_schema, request_payload)
        if validation_errors.any?
          render json: {errors: validation_errors}, status: 400

          ## We need to return immediately to prevent a double-render error.
          return
        end
      end
    end

    yield

    unless output_schema.nil?
      JSON.parse(response.body).tap do |response_payload|
        validation_errors = RjSchema::Validator.new.validate(output_schema, response_payload)
        if validation_errors.any?
          ## We cannot call render here, since the yielded block
          ## will have already done that - so modify the response
          ## attributes directly.
          response.body   = JSON.generate({errors: validation_errors})
          response.status = 500
        end
      end
    end
  end


  def record_request
    start = Time.now.utc
    yield
    elapsed = Time.now.utc - start

    ActiveRecord::Base.transaction(isolation: :read_committed, requires_new: true) do
      RequestRecord.create!(
        uuid:       SecureRandom.uuid,
        endpoint:   request.fullpath,
        start_time: start,
        elapsed:    elapsed,
        status:     response.status,
      )
    end
  end
end
