class HelloService
  def process(payload)
    test_instance_id = "i-01f61e42a73670c18"
    test_image_id = "ami-5fb8c835"
    return {uuid: payload[:uuid],
            instance_id: test_instance_id,
            image_id: test_image_id}
  end
end