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
    return {uuid: SecureRandom.uuid,
            request_time: request_time,
            success: false,
            status: nil,
            elapsed_time: nil,
            error_msg: msg.to_s}
  rescue StandardError => msg
    return {uuid: SecureRandom.uuid,
            request_time: request_time,
            success: false,
            status: nil,
            elapsed_time: nil,
            error_msg: msg.to_s}


  else
    stat = response.code
    conn = response.success?
    {uuid: SecureRandom.uuid,
     request_time: request_time,
     success: conn,
     status: stat,
     elapsed_time: elapsed_time,
     error_msg: "client ok"}
  end

end


