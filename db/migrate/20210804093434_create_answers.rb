class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.text :text

      t.references :question, index: true, foreign_key: true

      t.timestamps
    end
  end
end
