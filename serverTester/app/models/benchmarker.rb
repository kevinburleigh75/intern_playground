class Benchmarker < ApplicationRecord

  def ping_looper(url,count, timeout)
    x = 0
    until x == count do
      response = Pinger.new.measure_request(url, timeout)
      Benchmarker.create!(uuid: response[0],
                          request_time: response[1],
                          success: response[2],
                          status: response[3],
                          elapsed: response[4],
                          error_msg: response[5])
      x += 1
    end
  end
end
