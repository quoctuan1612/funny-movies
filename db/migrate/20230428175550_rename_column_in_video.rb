class RenameColumnInVideo < ActiveRecord::Migration[7.0]
  def change
    rename_column :videos, :url, :video_id
  end
end
