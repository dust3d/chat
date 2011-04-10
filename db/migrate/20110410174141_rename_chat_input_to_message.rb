class RenameChatInputToMessage < ActiveRecord::Migration
  def self.up
    rename_column :posts, :chat_input, :message
  end

  def self.down
    rename_column :posts, :message, :chat_input
  end
end
