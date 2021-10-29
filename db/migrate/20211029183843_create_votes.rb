class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer :value, null: false

      t.references :user, foreign_key: true, index: { unique: true }

      t.references :votable, polymorphic: true

      t.index %i[user_id votable_type votable_id], unique: true

      t.timestamps
    end
  end
end
