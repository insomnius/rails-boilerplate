# frozen_string_literal: true

class AddStateToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :state, :smallint, default: 1
  end
end
