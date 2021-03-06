# frozen_string_literal: true

class AddQuestionToAnswers < ActiveRecord::Migration[6.1]
  def change
    add_reference :answers, :question, null: false, foreign_key: true, on_delete: :cascade
  end
end
