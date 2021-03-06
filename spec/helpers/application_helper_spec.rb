# frozen_string_literal: true

require 'rails_helper'

describe ApplicationHelper, type: :helper do
  describe '#flash_messages' do
    it 'include flash messages' do
      message = 'My Message'
      flash[:notice] = message
      expect(helper.flash_messages).to include(message)
    end
  end

  describe '#show_layout_flash?' do
    it 'show_layout_flash? returns the value assigned by page_title' do
      helper.flash_messages(layout_flash: false)
      expect(helper).not_to be_show_layout_flash
    end
  end
end
