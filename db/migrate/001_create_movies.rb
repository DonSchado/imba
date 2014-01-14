class CreateMovies < ActiveRecord::Migration
  def self.up
    create_table :movies do |t|
      t.integer :uniq_id
      t.string :name
      t.string :year
      t.text :genres
      t.float :rating
    end
  end

  def self.down
    drop_table :movies
  end
end

