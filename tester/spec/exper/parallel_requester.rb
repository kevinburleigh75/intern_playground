require 'rails_helper'

RSpec.describe 'parallel requesters' do
  it 'works' do
    threads = 3.times.map do |thread_idx|
      Thread.new do
        loop do
          url = 'http://www.google.com'
          timeout_sec = (rand() < 0.95) ? 2.0 : 0.0001

          result = Requester.request(
            http_verb: :get,
            url: url,
            timeout_sec: timeout_sec,
          )

          if result.error?
            puts "thread #{thread_idx}: error"
          else
            puts "thread #{thread_idx}: success"
          end

          sleep(0.25*rand())
        end
      end
    end
    threads.each{|tt| tt.join }
  end
end
