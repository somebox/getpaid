class RemoveProjects < ActiveRecord::Migration
  def self.up
    drop_table :projects
  end

  def self.down
    create_table :projects do |t|
      t.column "name", :string, :limit => 50
      t.column "start_date", :datetime
      t.column "customer_id", :integer
      t.column "status", :string
    end
    
  end
end
