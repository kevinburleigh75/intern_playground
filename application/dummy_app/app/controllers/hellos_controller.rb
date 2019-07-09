class HellosController < ApplicationController

  around_action :record_request

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

end
