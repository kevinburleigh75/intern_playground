require 'rj_schema'

class JsonVerifier

  def validate_json(json_payload)
    errors = RjSchema::Validator.new.validate(schema, json_payload)
    return errors
  end

  def schema
    {
        "definitions": {},
        "$schema": "http://json-schema.org/draft-07/schema#",
        "$id": "http://example.com/root.json",
        "type": "object",
        "title": "The Root Schema",
        "required": [
            "uuid"
        ],
        "properties": {
            "uuid": {
                "$id": "#/properties/uuid",
                "type": "string",
                "title": "The Uuid Schema",
                "default": "",
                "examples": [
                    "c314de55-d7fa-49a3-9feb-ac8d0b27dbbd"
                ],
                "pattern": "^(.*)$"
            }
        }
    }
  end

end