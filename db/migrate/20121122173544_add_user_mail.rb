class AddUserMail < ActiveRecord::Migration
  def up
    change_table :participants do |t|
      t.string :email
      t.boolean :policy_new_challenge
      t.boolean :policy_challenge_solved
    end
  end

  def down
    remove_column :participants, :policy_new_challenge
    remove_column :participants, :policy_challenge_solved
    remove_column :participants, :email
  end
end
