class CreateViolations < ActiveRecord::Migration
  def change
    create_table :violations do |t|
      t.string :name
      t.string :description
      t.string :ordinance
      t.date :issue_date
      t.boolean :closed

      t.timestamps
    end
  end
end
