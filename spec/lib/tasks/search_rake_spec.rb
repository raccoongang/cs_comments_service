require 'spec_helper'
require 'elasticsearch'

describe "search:rebuild_indices" do
  include_context "rake"

  before do
    TaskHelpers::ElasticsearchHelper.stub(:rebuild_indices)
  end

  its(:prerequisites) { should include("environment") }

  it "calls rebuild_indices with defaults" do
    TaskHelpers::ElasticsearchHelper.should_receive(:rebuild_indices).with(500, 0, 5)

    subject.invoke
  end

  it "calls rebuild_indices with arguments" do
    # Rake calls receive arguments as strings.
    batch_size = '100'
    sleep_time = '2'
    extra_catchup_minutes = '10'
    TaskHelpers::ElasticsearchHelper.should_receive(:rebuild_indices).with(
          batch_size.to_i, sleep_time.to_i, extra_catchup_minutes.to_i
    )

    subject.invoke(batch_size, sleep_time, extra_catchup_minutes)
  end
end

describe "search:catchup" do
  include_context "rake"

  before do
    TaskHelpers::ElasticsearchHelper.stub(:catchup_indices)
  end

  its(:prerequisites) { should include("environment") }

  it "calls catchup with defaults" do
    TaskHelpers::ElasticsearchHelper.should_receive(:catchup_indices).with(
        anything, 500, 0
    ) do |start_time_arg|
      start_time_arg.should be_within(1.second).of Time.now
    end

    subject.invoke
  end

  it "calls catchup with arguments" do
    # Rake calls receive arguments as strings.
    minutes = '2'
    batch_size = '100'
    sleep_time = '2'
    TaskHelpers::ElasticsearchHelper.should_receive(:catchup_indices).with(
        anything, batch_size.to_i, sleep_time.to_i
    ) do |start_time_arg|
      start_time_arg.should be_within((60 * minutes.to_i + 1).second).of Time.now
    end

    subject.invoke(minutes, batch_size, sleep_time)
  end
end
