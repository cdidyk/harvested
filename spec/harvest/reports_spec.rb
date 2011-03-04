require 'spec_helper'
require File.join(File.expand_path(File.dirname(__FILE__)), "../../lib/harvest/api/reports")

describe Harvest::API::Reports do
  describe "#time_by_project" do
    it "should include the updated_since filter as a URL-encoded UTC date time value if supplied" do
      Harvest::TimeEntry.stub!(:parse)

      HTTParty.
        should_receive(:send).
        with(:get, anything, hash_including(:query => {:from => "20101101", :to => "20101110", :updated_since => "2010-12-01T00%3A00%3A00%2B00%3A00"})).
        and_return double("Response", :code => 200, :body => "body")

      creds = Harvest::Credentials.new 'subdomain', 'user', 'password'
      report =
        Harvest::API::Reports.new(creds).
          time_by_project(Harvest::Project.new, DateTime.parse("1 Nov 2010"), DateTime.parse("10 Nov 2010"), nil, :updated_since => "1 Dec 2010")
    end
  end
end
