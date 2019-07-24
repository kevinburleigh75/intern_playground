class ScalingLogic
  def initialize(asg_workers_min:,
                 asg_workers_max:,
                 asg_workers_desired:,
                 worker_capacity_rps:,
                 worker_launch_time_sec:,
                 max_growth_rate_rpsps:,
                 target_static_margin_rps:,
                 cur_workload_rps:,
                 cur_backlog_r:,
                 time_since_last_decrease_sec:)
  end

  def target_desired_capacity
  end
end

## R     = requests
## RPS   = requests/second
## RPSPS = RPS/second
RSpec.describe ScalingLogic do
  let(:scaling) {
    ScalingLogic.new(
      asg_workers_min:              asg_workers_min,
      asg_workers_max:              asg_workers_max,
      asg_workers_desired:          asg_workers_desired,
      worker_capacity_rps:          worker_capacity_rps,
      worker_launch_time_sec:       worker_launch_time_sec,
      max_growth_rate_rpsps:        max_growth_rate_rpsps,
      target_static_margin_rps:     target_static_margin_rps,
      cur_workload_rps:             cur_workload_rps,
      cur_backlog_r:                cur_backlog_r,
      time_since_last_decrease_sec: time_since_last_decrease_sec,
    )
  }

  let(:asg_workers_min)              {   0     }
  let(:asg_workers_max)              {  10     }
  let(:asg_workers_desired)          {   3     }
  let(:worker_capacity_rps)          {  20.0   }
  let(:worker_launch_time_sec)       {  60.0   }
  let(:max_growth_rate_rpsps)        {   1.001 }
  let(:target_static_margin_rps)     {  50.0   }
  let(:cur_workload_rps)             {  10.0   }
  let(:cur_backlog_r)                {   5     }
  let(:time_since_last_decrease_sec) { 300.0   }

  context 'when the current capacity matches the projected demand' do
    it 'does not change the desired capacity' do
      expect(scaling.target_desired_capacity).to eq(asg_workers_desired)
    end
  end

  context 'when the current capacity falls short of the projected demand' do
    context 'due to the static margin being violated' do
      it 'sets the target desired capacity to the correct number of workers'
    end
    context 'due to the projected growth exceeding the current capacity' do
      it 'sets the target desired capacity to the correct number of workers'
    end
    context 'due to a backlog of requests' do
      it 'sets the target desired capacity to the correct number of workers'
    end
    context 'due to a combination of factors' do
      it 'sets the target desired capacity to the correct number of workers'
    end
    context 'when the ideal desired capacity is greater than the ASG max' do
      it 'sets the target desired capacity to the ASG max'
    end
  end

  context 'when the current capacity exceeds the projected demand' do
    ## TODO
  end
end
