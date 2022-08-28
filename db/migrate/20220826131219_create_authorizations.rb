class CreateAuthorizations < ActiveRecord::Migration[6.1]
  def change
    create_table :authorizations do |t|
      t.string :provider
      t.string :uid

      t.references :user, null: false

      t.timestamps
    end
  end
end
