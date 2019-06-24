require 'rails_helper'
require 'time'
require 'httparty'
require 'securerandom'
require 'uri'

RSpec.describe Benchmarker, type: :model do

  let!(:bm) { Benchmarker.create!(uuid: SecureRandom.uuid,
                                  request_time: Time.now.utc,
                                  success: true,
                                  status: 200,
                                  elapsed: Time.now,
                                  error_msg: response[5]) }
  let!(:updated_after_time) { sleep 0.1; Time.now.utc }

  it "records a random uuid, request time, success, good status, elapsed time, and client ok" do
    puts Pinger.new.measure_request("https://httpstat.us/200", 2).join(", ")
  end

  it "records a random uuid, request time, failure, bad status, elapsed time, and client ok " do
    puts Pinger.new.measure_request("https://httpstat.us/404", 2).join(", ")
  end

  it "doesn't break on bad uri links" do
    expect{Pinger.new.measure_request("bad uri", 2)}.not_to raise_error
  end

  it "records a random uuid, request time, failure, nil, nil, and error message on bad uri links" do
    puts Pinger.new.measure_request("bad uri", 2).join(", ")
  end

  it "doesn't break on non-http links" do
    expect{Pinger.new.measure_request("htttttp://wwvv.not-http.com", 2)}.not_to raise_error
  end

  it "records a random uuid, request time, failure, nil, nil, and error message on non-http links" do
    puts Pinger.new.measure_request("htttttp://wwvv.not-http.com",2).join(", ")
  end

  it "connection timeout correctly ends request" do
    expect(Pinger.new.measure_request("https://www.google.com",2)[2]).to eq(true)
    expect(Pinger.new.measure_request("https://www.google.com",0.02)[2]).to eq(false)
  end

  it "records a random uuid, request time, failure, nil, nil, and error message on connection timeout" do
    puts Pinger.new.measure_request("https://www.google.com",0.02).join(", ")
  end

  it "records a random uuid, request time, failure, nil, nil, and error message on invalid http links" do
    puts Pinger.new.measure_request("http://www.invalid.cooom", 2).join(", ")
  end

  it "works on valid links" do
    data = Pinger.new.measure_request("https://www.google.com",2)
    expect(data[2]).to eq(true)
    expect(data[3]).to eq(200)
  end

  it "records the correct server status" do
    expect(Pinger.new.measure_request("https://httpstat.us/200", 2)[3]).to eq(200)
    expect(Pinger.new.measure_request("https://httpstat.us/404", 2)[3]).to eq(404)
    expect(Pinger.new.measure_request("https://httpstat.us/501", 2)[3]).to eq(501)
  end

  it "correctly creates a new entry with valid link" do
    expect{:bm.ping_looper("https://www.google.com",1, 2)}.to change{Benchmarker.count}.by(1)
  end

  it "correctly creates a new entry 10 times with valid link" do
    expect{:bm.ping_looper("https://www.google.com",10, 2)}.to change{Benchmarker.count}.by(10)
  end

  it "correctly creates a new entry with invalid link" do
    bm = Benchmarker.new
    expect{bm.ping_looper("httppps://www.gooooogle.com",1, 2)}.to change{Benchmarker.count}.by(1)
  end

  it "correctly creates a new entry 10 times with invalid link" do
    bm = Benchmarker.new
    expect{bm.ping_looper("httppps://www.gooooogle.com",10, 2)}.to change{Benchmarker.count}.by(10)
  end

  it "does things correctly" do
    hello = Benchmarker.new
    hello.ping_looper("https://www.google.com",10, 2)

    puts hello.inspect
    puts Benchmarker.count
  end

end
