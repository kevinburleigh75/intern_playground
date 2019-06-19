require 'rails_helper'

RSpec.describe Benchmarker, type: :model do

  let(:test_uuid)          { SecureRandom.uuid }
  let(:test_request_tiime)       { Time.now.getutc }
  let(:test_success)       { true }
  let(:test_status)       { 200 }
  let(:test_elapsed)       { Time.now }

  let(:action) {
    Benchmarker.create(
        group_uuid:    target_group_uuid,
        instance_uuid: target_instance_uuid,
        instance_desc: target_instance_desc,
        )
  }



  let!(:target_record) { :benchmarker, create(
      group_uuid:    target_group_uuid,
      instance_uuid: target_instance_uuid,
      instance_desc: target_instance_desc,
      ) }
  let!(:updated_after_time) { sleep 0.1; Time.now.utc }


  it "fails on invalid links" do
    expect{Benchmarker.new.measure_request("hfghg")}.to raise_error(Errno::ECONNREFUSED)

  end

  it "works on valid links" do
    expect(Benchmarker.new.measure_request("https://www.google.com")).to eq(true)
  end

  it "creates a new entry" do
    db = Benchmarker.new

    expect{db.measure_request("https://www.google.com")}.to change{Benchmarker.count}.by(1)

  end

  it "creates a new entry 10 times" do
    db = Benchmarker.new

    expect{db.requester(10,"https://www.google.com")}.to change{Benchmarker.count}.by(10)

  end


  it "records a random uuid" do

  end

  it "records timestamp" do

  end

  it "records correct status" do

  end

  it "records success" do

  end


end
