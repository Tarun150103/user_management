class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.references :role, null: false, foreign_key: true
      t.string :image

      t.timestamps
    end
  end
end
