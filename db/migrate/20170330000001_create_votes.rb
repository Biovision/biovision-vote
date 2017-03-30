class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.timestamps
      t.references :user, foreign_key: true, on_update: :cascade, on_delete: :cascade
      t.references :agent, foreign_key: true, on_update: :cascade, on_delete: :nullify
      t.inet :ip
      t.integer :delta, limit: 2, default: 0, null: false
      t.integer :votable_id, null: false
      t.string :votable_type, null: false
    end
  end
end
