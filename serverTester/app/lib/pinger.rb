require 'time'
require 'httparty'
require 'securerandom'
require 'uri'

class Pinger

  def measure_request(url, timeout)

    request_time = Time.now.getutc
    url = URI.parse(url)
    start_time = Time.now
    response = HTTParty.get(url, timeout: timeout)
    elapsed_time = Time.now - start_time

      #Handle exceptions so code doesn't break on bad inputs
  rescue HTTParty::Error => msg
    return {uuid: SecureRandom.uuid.to_s,
            request_time: request_time,
            endpoint: url,
            success: false,
            status: nil,
            elapsed: nil
    }

  rescue StandardError => msg
    return {uuid: SecureRandom.uuid.to_s,
            request_time: request_time,
            endpoint: url,
            success: false,
            status: nil,
            elapsed: nil
    }


  else
    stat = response.code
    conn = response.success?
    return {uuid: SecureRandom.uuid.to_s,
            request_time: request_time,
            endpoint: url,
            success: conn,
            status: stat,
            elapsed: elapsed_time}
  end

  def ping_looper(url,count, timeout)
    x = 0
    until x == count do
      response = Pinger.new.measure_request(url, timeout)
      Benchmarker.create!(uuid: response[:uuid],
                          request_time: response[:request_time],
                          endpoint: response[:endpoint],
                          success: response[:success],
                          status: response[:status],
                          elapsed: response[:elapsed])
      x += 1
    end
  end

end


