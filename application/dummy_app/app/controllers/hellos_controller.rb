class HellosController < ApplicationController
  def hello
    with_validations(input_schema: hello_input_schema, output_schema: hello_output_schema) do
      response_body = HelloService.new.process(request.request_parameters.deep_symbolize_keys)
      render json: response_body, status: 200
    end
  end

  def hello_input_schema
    {
        '$schema': 'http://json-schema.org/draft-07/schema#',
        '$id': 'hello/ input schema',
        'definitions': {},
        'type': 'object',
        'title': 'hello/ input schema',
        'required': [
            'uuid'
        ],
        'properties': {
            'uuid': {
                '$id': '#/properties/uuid',
                'type': 'string',
                'title': 'The Uuid Schema',
                'default': '',
                'examples': [
                    'c314de55-d7fa-49a3-9feb-ac8d0b27dbbd'
                ],
                'pattern': '^.{36}$'
            }
        }
    }
  end

  def hello_output_schema
    {
        '$schema': 'http://json-schema.org/draft-07/schema#',
        '$id': 'hello/ output schema',
        'type': 'object',
        'required': [
            'uuid',
            'instance_id',
            'image_id'
        ],
        'properties': {
            'uuid': {
                '$id': '#/properties/uuid',
                'type': 'string',
                'default': '',
                'examples': [
                    'c314de55-d7fa-49a3-9feb-ac8d0b27dbbd'
                ],
                'pattern': '^.{36}$'
            },
            'instance_id': {
                '$id': '#properties/instance_id',
                'type': 'string',
                'examples': [
                  'i-01f61e42a73670c18'
                ],
                'pattern': '^.{3,}$'
            },
            'image_id': {
                '$id': '#properties/image_id',
                'type': 'string',
                'examples': [
                  'ami-5fb8c835'
                ],
                'pattern': '^.{3,}$'
            }
        }
    }
  end

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
end
