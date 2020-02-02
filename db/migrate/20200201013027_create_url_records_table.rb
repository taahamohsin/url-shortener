class CreateUrlRecordsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :url_records do |t|
      t.string :path
      t.string :shortened_url
      t.integer :num_visits
      t.timestamps
    end
  end
end
