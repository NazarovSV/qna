class AddBestAnswerToQuestion < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :best_answer_id, :integer, index: true
    add_foreign_key :questions, :answers, column: :best_answer_id, null: true
  end
end
