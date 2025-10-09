class RenameContentsToOptions < ActiveRecord::Migration[8.0]
  def change
    rename_table :contents, :options
  end
end
