class CreateResults < ActiveRecord::Migration[6.1]
  def change
    create_table :results do |t|
      t.string :text
      t.integer :min
      t.integer :max

      t.timestamps
    end
  end
end
