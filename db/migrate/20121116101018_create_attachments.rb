class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :challenge_id
      t.string :file

      t.timestamps
    end
  end
end
