class CreateMovies < ActiveRecord::Migration[7.0]
  def change
    create_table :movies do |t|
      t.string :title
      t.text :synopsis
      t.string :genre
      t.integer :release_date
      t.integer :duration
      t.string :director
      t.float :market_rating

      t.timestamps
    end
  end
end
