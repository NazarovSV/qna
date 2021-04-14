class CreateRewards < ActiveRecord::Migration[6.1]
  def change
    create_table :rewards do |t|
      t.string :name
      t.references :question, null: false, foreign_key: true
      t.references :recipient, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
