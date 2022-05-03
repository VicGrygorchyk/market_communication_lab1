class CreateResults < ActiveRecord::Migration[6.1]
  def change
    create_table :results do |t|
      t.string :text
      t.integer :score

      t.timestamps
    end
  end
end
