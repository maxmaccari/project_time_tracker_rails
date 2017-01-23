require 'rails_helper'

RSpec.describe "records/index", type: :view do
  before(:each) do
    assign(:records, [
      Record.create!(
        :type => "Type",
        :description => "MyText",
        :initial_hour => 2,
        :initial_minute => 3,
        :final_hour => 4,
        :final_minute => 5,
        :hours => 6,
        :minutes => 7,
        :project => nil
      ),
      Record.create!(
        :type => "Type",
        :description => "MyText",
        :initial_hour => 2,
        :initial_minute => 3,
        :final_hour => 4,
        :final_minute => 5,
        :hours => 6,
        :minutes => 7,
        :project => nil
      )
    ])
  end

  it "renders a list of records" do
    render
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
