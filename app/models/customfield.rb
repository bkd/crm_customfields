# Fat Free CRM
# Copyright (C) 2008-2009 by Michael Dvorkin
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#------------------------------------------------------------------------------

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

class Customfield < ActiveRecord::Base
  
  belongs_to  :user

  ## Default validations for model
  #
  validates_presence_of :field_name, :message => "^Please enter a Field name."
  validates_format_of :field_name, :with => /\A[A-Za-z_]+\z/,:message => "^Please specify Field name without any special characters or numbers, spaces are not allowed - use [A-Za-z_] ", :if => :field_name_given?
  validates_length_of :field_name, :maximum=>64, :message => "^The Field name must be less than 64 characters in length"
  
  validates_presence_of :field_label, :message => "^Please enter a Field label."
  validates_length_of :field_label, :maximum=>64, :message => "^The Field name must be less than 64 characters in length"
  
  validates_presence_of :field_type, :message => "^Please specify a Field type."
  validates_inclusion_of :field_type, :in => %w(Integer Decimal Float String Date Text), :message => "^Hack alert::Field type Please dont change the HTML source of this application."
  
  validates_presence_of :table_name, :message => "^Please specify a Table to attach the custom field to."
  validates_inclusion_of :table_name, :in => %w(Account Contact Opportunity), :message => "^Hack alert::Table Please dont change the HTML source of this application."
  
  validates_presence_of :display_sequence, :message => "^Please enter a Sequence."
  validates_presence_of :display_block, :message => "^Please enter a Block."
  validates_presence_of :display_width, :message => "^Please enter a Width."
  validates_presence_of :max_size, :message => "^Please enter a Max Size."
  
  validates_numericality_of :display_sequence, :only_integer => true, :message => "^Sequence can only be whole number.", :if => :display_sequence_given?
  validates_numericality_of :display_block, :only_integer => true, :message => "^Block can only be whole number.", :if => :display_block_given?
  validates_numericality_of :display_width, :only_integer => true, :message => "^Width can only be whole number.", :if => :display_width_given?
  validates_numericality_of :max_size, :only_integer => true, :message => "^Max size can only be whole number.", :if => :max_size_given?
  
  validates_length_of :display_sequence, :maximum=>4, :message => "^Sequence can be 4 numbers long", :if => :display_sequence_given?
  validates_length_of :display_block, :maximum=>4, :message => "^Block can be 4 numbers long", :if => :display_block_given?
  validates_length_of :display_width, :maximum=>4, :message => "^Width can be 4 numbers long", :if => :display_width_given?
  validates_length_of :max_size, :maximum=>4, :message => "^Max size can be 4 numbers long", :if => :max_size_given?

  ## TODO - Added for now but need to get simple_column_search working later
  simple_column_search :field_name, :field_label, :table_name, :escape => lambda { |query| query.gsub(/[^\w\s\-\.']/, "").strip }
  
  SORT_BY = {
    "field name"         => "customfields.field_name ASC",
    "field label"        => "customfields.field_label DESC",
    "field type"         => "customfields.field_type DESC",
    "table"              => "customfields.table_name DESC",
    "display sequence"   => "customfields.display_sequence DESC",
    "display block"      => "customfields.display_block_on DESC",
    "display width"      => "customfields.display_width DESC",
    "max size"           => "customfields.max_size DESC",
    "date created"       => "customfields.created_at DESC",
    "date updated"       => "customfields.updated_at DESC"
  }

  after_validation_on_update :make_rake_changes
  after_create :make_db_rake
  
  ## TODO - quick solution for now, later move this into Rake::Task[].invoke, and execute in background 
  # when doing tests this takes alooooooong time to run, comment out if needed
  def runrake
    %x{rake.bat db:migrate} #windows only - remove .bat for linux/unix
  end

  def make_rake_changes
    `ruby script/generate migration rename_#{self.table_name.downcase.pluralize}_#{self.field_name_was}_to_#{self.field_name}`  if self.field_name_changed? 
    runrake
  end

  def make_db_rake
    `ruby script/generate migration add_#{self.field_name}_to_#{self.table_name.downcase.pluralize} #{self.field_name}:#{self.field_type.downcase}`
    runrake
  end

  # Default values provided through class methods.
  #----------------------------------------------------------------------------
  def self.per_page ;  20                         ; end
  def self.outline  ;  "long"                      ; end
  def self.sort_by  ;  "customfields.created_at DESC" ; end

  #----------------------------------------------------------------------------
  def name
    self.field_name
  end

  def field_name_given?
    !field_name.blank?
  end

  def field_label_given?
    !field_label.blank?
  end

  def display_sequence_given?
    !display_sequence.blank?
  end

  def display_block_given?
    !display_block.blank?
  end

  def display_width_given?
    !display_width.blank?
  end

  def max_size_given?
    !max_size.blank?
  end

end
