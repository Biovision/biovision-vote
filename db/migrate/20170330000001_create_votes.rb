# frozen_string_literal: true

# Create table and component for votes
class CreateVotes < ActiveRecord::Migration[5.2]
  def up
    create_component
    create_votes unless Vote.table_exists?
  end

  def down
    drop_table :votes if Vote.table_exists?
  end

  private

  def create_votes
    create_table :votes, comment: 'Vote' do |t|
      t.references :user, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.inet :ip
      t.timestamps
      t.integer :delta, limit: 2, default: 0, null: false
      t.integer :votable_id, null: false
      t.string :votable_type, null: false
      t.string :slug, index: true
    end
  end

  def create_component
    BiovisionComponent.create(slug: Biovision::Components::VoteComponent::SLUG)
  end
end
