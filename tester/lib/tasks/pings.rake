namespace :pings do
  desc "check for timeouts on some website"
  task :ping, [:url,:min_sec_per_request,:timeout,:num_threads] => :environment do |t, args|
    url                 = String(args[:url])
    min_sec_per_request = Float(args[:min_sec_per_request])
    timeout             = Float(args[:timeout])
    num_threads         = Integer(args[:num_threads])

    threads = num_threads.times.map do |thread_idx|
      Thread.new do
        sleep(min_sec_per_request/num_threads*thread_idx)

        loop do
          start = Time.now
          puts "#{Time.now.utc.iso8601(6)} thread #{thread_idx}"

          result = Requester.request(
            http_verb:   :get,
            url:         url,
            timeout_sec: timeout,
          )

          msg = result.error? ? 'error' : 'success'
          puts "#{Time.now.utc.iso8601(6)} thread #{thread_idx}: #{msg}"
          finish = Time.now

          time_to_sleep = min_sec_per_request - (finish - start)
          if time_to_sleep > 0
            sleep(time_to_sleep)
          end
        end
      end
    end

    threads.each{|tt| tt.join}
  end
end
