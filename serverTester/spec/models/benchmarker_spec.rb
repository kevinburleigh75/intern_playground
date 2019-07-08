require 'rails_helper'
require 'time'
require 'httparty'
require 'securerandom'
require 'uri'

RSpec.describe Benchmarker, type: :model do
  pinger = Pinger.new

  it "returns a random uuid, request time, success, good status, elapsed time" do
    stat_200 = pinger.measure_request("httpstat.us","","200", 2)
    expect(stat_200[:uuid]).to be_a(String)
    expect(stat_200[:request_time]).to be_a(Time)
    expect(stat_200[:success]).to eq(true)
    expect(stat_200[:status]).to eq(200)
    expect(stat_200[:elapsed]).to be_a(Float)
  end

  it "returns a random uuid, request time, failure, bad status, elapsed time" do
    stat_404 = pinger.measure_request("httpstat.us","","404", 2)
    expect(stat_404[:uuid]).to be_a(String)
    expect(stat_404[:request_time]).to be_a(Time)
    expect(stat_404[:success]).to eq(false)
    expect(stat_404[:status]).to eq(404)
    expect(stat_404[:elapsed]).to be_a(Float)
  end

  it "doesn't break on bad uri links" do
    expect{pinger.measure_request("bad uri","","", 2)}.not_to raise_error
  end

  it "returns a random uuid, request time, failure, nil, nil on bad uri links" do
    bad_uri = pinger.measure_request("bad uri","","", 2)
    expect(bad_uri[:uuid]).to be_a(String)
    expect(bad_uri[:request_time]).to be_a(Time)
    expect(bad_uri[:success]).to eq(false)
    expect(bad_uri[:status]).to eq(nil)
    expect(bad_uri[:elapsed]).to eq(nil)
  end


  it "connection timeout correctly ends request" do
    expect(pinger.measure_request("httpstat.us","","200",2)[:success]).to eq(true)
    expect(pinger.measure_request("httpstat.us","","200",0.02)[:success]).to eq(false)
  end


  it "returns a random uuid, request time, failure, nil, nil on connection timeout" do
    conn_timeout = pinger.measure_request("httpstat.us","","200",0.02)
    expect(conn_timeout[:uuid]).to be_a(String)
    expect(conn_timeout[:request_time]).to be_a(Time)
    expect(conn_timeout[:success]).to eq(false)
    expect(conn_timeout[:status]).to eq(nil)
    expect(conn_timeout[:elapsed]).to eq(nil)
  end


  it "returns a random uuid, request time, failure, nil, nil on invalid http links" do
    invaild_http = pinger.measure_request("www.invalid.cooom","","", 0.02)
    expect(invaild_http[:uuid]).to be_a(String)
    expect(invaild_http[:request_time]).to be_a(Time)
    expect(invaild_http[:success]).to eq(false)
    expect(invaild_http[:status]).to eq(nil)
    expect(invaild_http[:elapsed]).to eq(nil)
  end


  it "creates the correct number of new entries" do
    expect{pinger.ping_looper("www.google.com","","",1, 2)}.to change{Benchmarker.count}.by(1)
    expect{pinger.ping_looper("www.google.com","","",10, 2)}.to change{Benchmarker.count}.by(10)
  end

  it "does things correctly" do
    pinger.ping_looper("www.google.com","","",1, 2)
    pinger.ping_looper("httpstat.us","","200",1, 2)
    pinger.ping_looper("httpstat.us","","404",1, 2)
    pinger.ping_looper("bad uri","","",1, 2)
    pinger.ping_looper("httpstat.us","","200",1, 0.002)

    for row in Benchmarker.all
      puts row.inspect
    end
  end

  it "returns the correct uuid after a POST request" do

  end
  end
