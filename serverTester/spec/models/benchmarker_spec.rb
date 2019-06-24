require 'rails_helper'

RSpec.describe Benchmarker, type: :model do

  it "records a random uuid, request time, success, good status, elapsed time, and ok" do
    puts Pinger.new.measure_request("https://httpstat.us/200").join(", ")
  end

  it "records a random uuid, request time, failure, bad status, elapsed time, and ok" do
    puts Pinger.new.measure_request("https://httpstat.us/404").join(", ")
  end

  it "doesn't break on bad uri links" do
    expect{Pinger.new.measure_request("bad uri")}.not_to raise_error
  end

  it "records a random uuid, request time, failure, -1, elapsed time, and error message on bad uri links" do
    puts Pinger.new.measure_request("bad uri").join(", ")
  end

  it "doesn't break on invalid links" do
    expect{Pinger.new.measure_request("htttttp://wwvv.invalid.coom")}.not_to raise_error
    expect{Pinger.new.measure_request("http://wwvv.invalid.coom")}.not_to raise_error
  end

  it "records a random uuid, request time, failure, -2, elapsed time, and error message on non-http links" do
    puts Pinger.new.measure_request("htttttp://wwvv.not-http.com").join(", ")
  end

  it "records a random uuid, request time, failure, -2, elapsed time, and error message on invalid http links" do
    puts Pinger.new.measure_request("http://www.invalid.com").join(", ")
  end

  it "works on valid links" do
    data = Pinger.new.measure_request("https://www.google.com")
    expect(data[2]).to eq(true)
    expect(data[3]).to eq(200)
  end

  it "records the correct server status" do
    expect(Pinger.new.measure_request("https://httpstat.us/200")[3]).to eq(200)
    expect(Pinger.new.measure_request("https://httpstat.us/404")[3]).to eq(404)
    expect(Pinger.new.measure_request("https://httpstat.us/501")[3]).to eq(501)
  end

  it "correctly creates a new entry" do
    db = Benchmarker.new
    expect{db.ping_looper("https://www.google.com",1)}.to change{Benchmarker.count}.by(1)

  end

  it "correctly creates a new entry 10 times" do
    db = Benchmarker.new
    expect{db.ping_looper("https://www.google.com",10)}.to change{Benchmarker.count}.by(10)
  end


end
