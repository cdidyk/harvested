require 'spec_helper'
require File.join(File.expand_path(File.dirname(__FILE__)), "../../lib/harvest/api/reports")

describe Harvest::API::Reports do
  describe "#time_by_project" do
    let(:creds) { Harvest::Credentials.new 'subdomain', 'user', 'password' }
    let(:project) { double Harvest::Project, :to_i => 43 }
    let(:response) { double "Response", :code => 200, :body => "body" }

    before :each do
      Harvest::TimeEntry.stub!(:parse)
    end

    it "should include the updated_since filter as a URL-encoded UTC date time value if supplied" do
      HTTParty.
        should_receive(:send).
        with(:get, anything, hash_including(:query => {:from => "20101101", :to => "20101110", :updated_since => "2010-12-01T00%3A00%3A00%2B00%3A00"})).
        and_return response

      report =
        Harvest::API::Reports.new(creds).
          time_by_project(project, DateTime.parse("1 Nov 2010"), DateTime.parse("10 Nov 2010"), :updated_since => "1 Dec 2010")
    end

    it "should include the user_id query parameter if a :user filter is supplied" do
      user = double Harvest::User, :to_i => 9

      HTTParty.
        should_receive(:send).
        with(:get, anything, hash_including(:query => {:from => "20101101", :to => "20101110", :user_id => 9})).
        and_return response

      report =
        Harvest::API::Reports.new(creds).
          time_by_project(project, DateTime.parse("1 Nov 2010"), DateTime.parse("10 Nov 2010"), :user => user)
    end

    it "should include the billable filter set to 'yes' if it's supplied as true" do
      HTTParty.
        should_receive(:send).
        with(:get, anything, hash_including(:query => {:from => "20101101", :to => "20101110", :billable => "yes"})).
        and_return response

      report =
        Harvest::API::Reports.new(creds).
          time_by_project(project, DateTime.parse("1 Nov 2010"), DateTime.parse("10 Nov 2010"), :billable => true)
    end

    it "should include the billable filter set to 'no' if it's supplied as false" do
      HTTParty.
        should_receive(:send).
        with(:get, anything, hash_including(:query => {:from => "20101101", :to => "20101110", :billable => "no"})).
        and_return response

      report =
        Harvest::API::Reports.new(creds).
          time_by_project(project, DateTime.parse("1 Nov 2010"), DateTime.parse("10 Nov 2010"), :billable => false)
    end
  end

end
