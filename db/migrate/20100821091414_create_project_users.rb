class CreateProjectUsers < ActiveRecord::Migration
  def self.up
    create_table :project_users do |t|
    end
  end

  def self.down
    drop_table :project_users
  end
end
