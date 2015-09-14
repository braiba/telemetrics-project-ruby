class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest

      t.timestamps null: false
    end

    User.new(username: 'floow', password: 'password', password_confirmation: 'password').save
  end
end
