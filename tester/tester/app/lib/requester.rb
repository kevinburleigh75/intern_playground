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

class DriverData
  def initialize()
    @internal_dict = nil
    self.pull_data()
  end

  def pull_data()
    # Look in db and get url, desired rate, and number of instances.
    pinger = PingerData.first

    if pinger.nil?
      raise "Database is empty!"
    end

    @internal_dict = {
        "desired_rate" => pinger.rate,
        "num_instances" =>pinger.num_instances
    }
    return @internal_dict
  end

  def return_data()
    return @internal_dict
  end
end

class Driver
  # Numthreads needs to be an os call with logic depending on the type of EC2 Instance
  def initialize(lambda, num_threads, driver_update_interval, thread_update_interval)

  end

  def run()

  end

  def controller_thread()
    
  end
end

# Need to inline code to make considerations for parallelism.
class DriverChild
  # Target_time in seconds
  def initialize(lambda, driver_data, num_threads, update_interval)
    @lambda = lambda
    @num_threads = num_threads
    @driver_data = driver_data
    @update_interval = update_interval
    @target_interval = nil
    @last_update = nil

    get_driver_data()
  end

  def get_driver_data()
    data = @driver_data.return_data()
    @last_update = Time.now

    desired_rate = data["desired_rate"]
    num_instances = data["num_instances"]

    @target_interval = 1.0 / ((desired_rate.to_f / @num_threads.to_f) / num_instances.to_f)
  end

  # Run lambda for the appropriate interval.
  def run_many(stop = False, num_iterations = 5)
    cur_debt = 0

    while true do
      beginning_time = Time.now
      @lambda.call()
      end_time = Time.now

      taken_time = (end_time - beginning_time).to_f
      spare_time = @target_interval - taken_time - cur_debt

      if spare_time >= 0
        sleep(spare_time)
      end

      # If spare time is negative, there is debt; if positive, we've slept for spare_time and have no debt.
      # We get the max of 0, and negative spare_time
      cur_debt =  0 > -spare_time ? 0 : -spare_time

      num_iterations -= 1
      # This is where we could randomize the target_interval; +- to debt randomly.

      # If end_time is too far from last_updated, we update.
      if end_time - @last_update > @update_interval
        self.get_driver_data()
      end

      # Code for debugging and testing; can remove in actual driver.
      if stop and num_iterations <= 0
        break
      end
    end
  end
end