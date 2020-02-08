# frozen_string_literal: true

# Add UUID column to votes and rename component to "votes"
class AddUuidToVotes < ActiveRecord::Migration[5.2]
  def up
    criteria = { slug: Biovision::Components::VotesComponent.slug }

    return if BiovisionComponent.where(criteria).exists?

    BiovisionComponent['vote']&.update!(criteria) || BiovisionComponent.create(criteria)

    add_column :votes, :uuid, :uuid
    add_index :votes, :uuid, unique: true

    Vote.order('id asc').each(&:save!)
  end

  def down
    # No rollback needed
  end
end
