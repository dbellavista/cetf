class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.string 'name', :null => false
      t.text 'text', :null => false
      t.string 'solution', :null => false
      t.references 'participant'
      t.integer 'points', :null => false
      t.string 'category', :null => false

      t.timestamps
    end
    rename_column :challenges, :participant_id, :author_id
  end
end
