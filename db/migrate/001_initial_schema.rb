class InitialSchema < ActiveRecord::Migration
  def self.up
        
    create_table "contacts" do |t|
      t.column "first_name", :string, :limit => 40
      t.column "last_name", :string, :limit => 60
      t.column "email", :string, :limit => 60
      t.column "phone", :string, :limit => 30
      t.column "alt_phone", :string, :limit => 30
      t.column "address", :string, :limit => 80
      t.column "address_2", :string, :limit => 80
      t.column "city", :string, :limit => 60
      t.column "state", :string, :limit => 30
      t.column "postal", :string, :limit => 30
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end

    create_table "customers" do |t|
      t.column "name", :string, :limit => 40, :default => "somebox", :null => false
      t.column "tag", :string, :limit => 10
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "contact_id", :integer
    end

    create_table "invoices" do |t|
      t.column "customer_id", :integer
      t.column "status", :string, :limit => 20
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "balance_due", :float
    end

    create_table "line_items" do |t|
      t.column "invoice_id", :integer
      t.column "service_id", :integer
      t.column "date_performed", :date
      t.column "quantity", :integer
      t.column "rate", :float
      t.column "unit", :string, :limit => 10, :default => "hours"
    end

    create_table "services" do |t|
      t.column "name", :string, :limit => 40
      t.column "default_rate", :float
      t.column "description", :text
    end

  end

  def self.down
    drop_table "contacts"    
    drop_table "customers"
    drop_table "invoices"    
    drop_table "line_items"
    drop_table "services"
  end
end
