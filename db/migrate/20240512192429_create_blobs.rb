class CreateBlobs < ActiveRecord::Migration[7.1]
  def change
    create_table :blobs, id: :string do |t|
      t.jsonb :storage_metadata, null: false, default: {}
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
