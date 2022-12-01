class CreateCinemas < ActiveRecord::Migration[7.0]
  def change
    create_table :cinemas do |t|
      t.string :name
      t.string :location
      t.string :brand

      t.timestamps
    end
  end
end