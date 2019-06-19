require 'time'
require 'httparty'
require 'securerandom'

class Benchmarker < ApplicationRecord

  def requester(count,url)
    x = 0
    until x == count do
      measure_request(url)
      x += 1
    end
  end

  def measure_request(url)
    start_time = Time.now
    response = HTTParty.get(url)
    stat = response.code
    conn = response.success?
    elapsed_time = Time.now - start_time

    #save request data
    Benchmarker.create!(:uuid => SecureRandom.uuid,
                        :request_time => Time.now.getutc,
                        :success => conn,
                        :status => stat,
                        :elapsed => elapsed_time)
    return conn
  end
end
