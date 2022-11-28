class CreateSharings < ActiveRecord::Migration[7.0]
  def change
    create_table :sharings do |t|
      t.text :description
      t.boolean :cancelled
      t.references :session, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
