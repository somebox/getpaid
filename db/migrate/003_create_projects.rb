class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.column "name", :string, :limit => 50
      t.column "start_date", :datetime
      t.column "contact_id", :integer
      t.column "company_id", :integer
      t.column "status", :string
    end
  end

  def self.down
    drop_table :projects
  end
end
