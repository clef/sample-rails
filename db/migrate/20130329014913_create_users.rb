class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.integer :clef_id

      t.timestamps
    end
  end
end
