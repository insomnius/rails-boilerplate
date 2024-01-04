# frozen_string_literal: true

class AddEmailAndNameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :email, :string
    add_column :users, :name, :string
  end
end
