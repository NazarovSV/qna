# frozen_string_literal: true

class AddUserToAnswer < ActiveRecord::Migration[6.1]
  def change
    add_reference :answers, :user, null: false, foreign_key: true
  end
end
