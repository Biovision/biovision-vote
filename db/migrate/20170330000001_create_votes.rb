class CreateVotes < ActiveRecord::Migration[5.1]
  def up
    unless Vote.table_exists?
      create_table :votes do |t|
        t.timestamps
        t.references :user, foreign_key: true, on_update: :cascade, on_delete: :cascade
        t.references :agent, foreign_key: true, on_update: :cascade, on_delete: :nullify
        t.inet :ip
        t.integer :delta, limit: 2, default: 0, null: false
        t.integer :votable_id, null: false
        t.string :votable_type, null: false
        t.string :slug, index: true
      end
    end
  end

  def down
    if Vote.table_exists?
      drop_table :votes
    end
  end
end
