class CreateCustomfields < ActiveRecord::Migration
  def self.up
    create_table :customfields, :force => true do |t|
      t.string      :uuid,        :limit => 36
      t.references  :user
      t.string      :field_name,  :limit => 64
      t.string      :field_type,  :limit => 32
      t.string      :field_label, :limit => 64
      t.string      :table_name,  :limit => 32
      t.integer     :display_sequence,    :limit => 4
      t.integer     :display_block,       :limit => 4
      t.integer     :display_width,       :limit => 4
      t.integer     :max_size,    :limit => 4
      t.boolean     :required
      t.boolean     :disabled
      t.timestamps
    end
    add_index :customfields,:field_name 
  end

  def self.down
    drop_table :customfields
  end
end
