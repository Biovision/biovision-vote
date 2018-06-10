class AddSlugToVotes < ActiveRecord::Migration[5.2]
  def up
    unless column_exists?(:votes, :slug)
      add_column :votes, :slug, :string, index: true

      Vote.order('id asc').each do |vote|
        vote.update! slug: vote.current_slug
      end
    end
  end

  def down
    # No need to rollback
  end
end
