class AddLogin < ActiveRecord::Migration

  def up
    change_table :participants do |t|
      t.string :provider
      t.string :uid
    end
  end

  def down
    remove_column :participants, :provider
    remove_column :participants, :uid
  end

end
