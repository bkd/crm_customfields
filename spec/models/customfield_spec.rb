# == Schema Information
# Schema version: 23
#
# Table name: customfields
#
#  id                   :integer(4)      not null, primary key
#  user_id              :integer(4)
#  field_name,          :string(64)
#  field_type,          :string(32)
#  field_label,         :string(64)
#  table_name,          :string(32)
#  display_sequence,    :integer(4)
#  display_block,       :integer(4)
#  display_width,       :integer(4)
#  max_size,            :integer(4)
#  disabled,            :boolean
#  required,            :boolean
#  created_at           :datetime
#  updated_at           :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Customfield do

  before(:each) do
    login
  end

  it "should create a new instance given valid attributes" do
    Customfield.create!(
            :field_name => "skype_address", 
            :field_label => "Skype address", 
            :field_type => "String", 
            :max_size => 220, 
            :display_sequence => 10,
            :display_block => 10,
            :display_width => 250,
            :table_name => "Account", :user => Factory(:user))
  end

end
