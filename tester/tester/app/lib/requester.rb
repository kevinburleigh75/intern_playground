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

class Driver
  def initialize()
    @desired_rate   = nil
    @num_instances  = nil

    self.get_pinger_data()
  end

  def desired_rate
    @desired_rate
  end

  def num_instances
    @num_instances
  end

  def get_pinger_data()
    # Look in db and get url, desired rate, and number of instances.
    pinger = PingerData.first

    if pinger.nil?
      raise "Database is empty!"
    end

    @desired_rate = pinger.rate
    @num_instances = pinger.num_instances
  end
end

class DriverChild
  # Target_time in seconds
  def initialize(lambda, target_amount, target_time)
    @lambda = lambda
    @target_amount = target_amount
    @target_time = target_time

    @target_interval = target_time.to_f / target_amount.to_f
  end

  # Run the lambda, and return the time in seconds.
  def run_lambda_timed()
    beginning_time = Time.now
    @lambda.call()
    end_time = Time.now
    return (end_time - beginning_time).to_f
  end

  # Run lambda, targeting a certain total time in seconds
  # If it takes more time than inputted, returns the
  # "time debt"; the amount of time lost from target.
  # If normal, returns 0.
  def run_lambda_target_time(target_interval)
    run_time = self.run_lambda_timed()

    spare_time = target_interval - run_time

    if spare_time >= 0
      sleep(spare_time)
      return 0
    else
      return -spare_time
    end
  end

  # Run lambda for the appropriate interval.
  def run_many(stop = False, num_iterations = 5)
    cur_debt = 0

    while true do
      # Small adjustment to account for other operations; constant.
      # Will drift over time.
      cur_debt = run_lambda_target_time(@target_interval - cur_debt)
      num_iterations -= 1

      # This is where we could randomize the target_interval; +- to debt randomly.
      if stop and num_iterations <= 0
        break
      end

    end

  end
end