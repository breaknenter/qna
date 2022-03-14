class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer :value, null: false

      t.references :user, foreign_key: true, null: false

      t.references :voteable, polymorphic: true, null: false

      t.index %i[user_id voteable_type voteable_id], unique: true

      t.timestamps
    end
  end
end
