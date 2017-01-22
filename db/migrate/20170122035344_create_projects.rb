class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :title, null: false, index: true
      t.text :description

      t.integer :estimated_hours
      t.date :initial_date
      t.date :final_date

      t.boolean :active, null: false, default: true, index: true
      t.references :parent, index: true, foreign_key: { to_table: :projects }

      t.timestamps
    end
    add_index :projects, [:parent_id, :title]
  end
end
