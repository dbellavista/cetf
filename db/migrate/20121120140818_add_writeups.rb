class AddWriteups < ActiveRecord::Migration
  def up
    change_table :solutions do |t|
      t.text :writeup, :default => "", :null => false
    end
  end

  def down
    remove_column :solutions, :writeup
  end
end
