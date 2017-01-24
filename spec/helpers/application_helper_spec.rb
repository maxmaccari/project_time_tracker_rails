require "spec_helper"

describe ApplicationHelper do
  describe "#flash_messages" do
    it "include flash messages" do
      byebug
      helper.flash_messages.should include('')
    end
  end
end
