class CreateTrustedApps < ActiveRecord::Migration
  def change
    create_table :trusted_apps do |t|
      t.string :app_name
      t.string :description
      t.string :sha_hash
      t.integer :max_daily_posts, :default => 10

      t.timestamps
    end
  end
end
