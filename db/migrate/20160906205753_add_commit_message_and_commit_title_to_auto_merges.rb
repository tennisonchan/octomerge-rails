class AddCommitMessageAndCommitTitleToAutoMerges < ActiveRecord::Migration[5.0]
  def change
    add_column :auto_merges, :commit_message, :string
    add_column :auto_merges, :commit_title, :string
  end
end
