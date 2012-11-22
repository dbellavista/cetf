class AttachmentsImprovement < ActiveRecord::Migration
  def up
    change_table :attachments do |t|
      t.string :name
    end
  end

  def down
    remove_column :attachments, :name
  end
end
