require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Harvest::TimeEntry do
  describe "#to_xml" do
    it "should build a valid request xml" do
      entry = Harvest::TimeEntry.new(:notes => 'the notes', :project_id => 1, :task_id => 2, :hours => 8.5, :spent_at => '28 Dec 2009')
      entry.to_xml.should == '<request><notes>the notes</notes><hours>8.5</hours><project_id>1</project_id><task_id>2</task_id><spent_at>2009-12-28 00:00:00 -0500</spent_at></request>'
    end
  end

  describe "#spent_at" do
    it "should parse strings" do
      entry = Harvest::TimeEntry.new(:spent_at => "12/01/2009")
      entry.spent_at.should == Time.parse("12/01/2009")
    end

    it "should accept times" do
      entry = Harvest::TimeEntry.new(:spent_at => Time.parse("12/01/2009"))
      entry.spent_at.should == Time.parse("12/01/2009")
    end
  end
end
