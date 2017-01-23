require 'rails_helper'

RSpec.describe "records/new", type: :view do
  before(:each) do
    assign(:record, Record.new(
      :type => "",
      :description => "MyText",
      :initial_hour => 1,
      :initial_minute => 1,
      :final_hour => 1,
      :final_minute => 1,
      :hours => 1,
      :minutes => 1,
      :project => nil
    ))
  end

  it "renders new record form" do
    render

    assert_select "form[action=?][method=?]", records_path, "post" do

      assert_select "input#record_type[name=?]", "record[type]"

      assert_select "textarea#record_description[name=?]", "record[description]"

      assert_select "input#record_initial_hour[name=?]", "record[initial_hour]"

      assert_select "input#record_initial_minute[name=?]", "record[initial_minute]"

      assert_select "input#record_final_hour[name=?]", "record[final_hour]"

      assert_select "input#record_final_minute[name=?]", "record[final_minute]"

      assert_select "input#record_hours[name=?]", "record[hours]"

      assert_select "input#record_minutes[name=?]", "record[minutes]"

      assert_select "input#record_project_id[name=?]", "record[project_id]"
    end
  end
end
