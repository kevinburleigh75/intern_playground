class Requester
  class Result
    def initialize(request_uuid:,
                   request_time:,
                   elapsed_sec:      nil,
                   http_response:    nil,
                   connection_error: false,
                   timeout_error:    false)
      if !connection_error && !timeout_error && !http_response
        raise ArgumentError('if there was no error, a response must be given')
      end

      @request_uuid     = request_uuid
      @request_time     = request_time
      @elapsed_sec      = elapsed_sec
      @http_response    = http_response
      @connection_error = connection_error
      @timeout_error    = timeout_error
    end

    def request_uuid
      @request_uuid
    end

    def request_time
      @request_time
    end

    def elapsed_sec
      @elapsed_sec
    end

    def http_response
      @http_response
    end

    def error?
      timeout_error? || connection_error?
    end

    def timeout_error?
      @timeout_error
    end

    def connection_error?
      @connection_error
    end
  end

  def self.request(http_verb:, url:, params: nil, timeout_sec: 1.0)
    request_uuid = SecureRandom.uuid

    start = Time.now
    response = HTTP.timeout(timeout_sec).send(http_verb, url, params: params)
    elapsed = Time.now - start

    Result.new(
      request_uuid:  request_uuid,
      request_time:  start,
      elapsed_sec:   elapsed,
      http_response: response,
    )
  rescue HTTP::ConnectionError => error
    Result.new(
      request_uuid:     request_uuid,
      request_time:     start,
      connection_error: true,
    )
  rescue HTTP::TimeoutError => error
    Result.new(
      request_uuid:   request_uuid,
      request_time:   start,
      timeout_error:  true,
    )
  end
end
