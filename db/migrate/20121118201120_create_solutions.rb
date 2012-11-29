class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.references :challenge
      t.references :participant

      t.timestamps
    end
  end
end
