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
    return [SecureRandom.uuid, request_time, false, -2, request_time, msg.to_s]
  rescue StandardError => msg
    return [SecureRandom.uuid, request_time, false, -1, request_time, msg.to_s]


  else
    stat = response.code
    conn = response.success?
    [SecureRandom.uuid, request_time, conn, stat, elapsed_time, "client ok"]
  end

end


