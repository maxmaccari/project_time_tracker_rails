require "rails_helper"

describe ApplicationHelper, type: :helper do
  describe "#flash_messages" do
    it "include flash messages" do
      message = "My Message"
      flash[:notice] = message
      helper.flash_messages.should include(message)
    end
  end

  describe "#show_layout_flash?" do
    it "show_layout_flash? returns the value assigned by page_title" do
      helper.flash_messages(layout_flash: false)
      helper.show_layout_flash?.should be_falsey
    end
  end
end
