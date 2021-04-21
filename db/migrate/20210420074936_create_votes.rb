class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer :value
      t.belongs_to :votable, polymorphic: true
      t.references :user,null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
