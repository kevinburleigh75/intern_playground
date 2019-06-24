require 'time'
require 'httparty'
require 'securerandom'
require 'uri'

class Pinger

  def measure_request(url)

    request_time = Time.now.getutc
    uri = URI.parse(url)
    start_time = Time.now
    response = HTTParty.get(uri, timeout: 2)

  #Handle exceptions so code doesn't break on bad inputs
  rescue HTTParty::Error => msg
    return [SecureRandom.uuid,request_time,false,-2,Time.now,msg]
  rescue StandardError => msg
    return [SecureRandom.uuid,request_time,false,-1,Time.now,msg]


  else
    stat = response.code
    conn = response.success?
    elapsed_time = Time.now - start_time
    [SecureRandom.uuid,request_time,conn,stat,elapsed_time,"ok"]
  end

end


