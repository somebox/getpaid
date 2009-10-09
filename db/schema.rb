# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20) do

  create_table "contacts", :force => true do |t|
    t.string   "first_name",    :limit => 40
    t.string   "last_name",     :limit => 60
    t.string   "email",         :limit => 60
    t.string   "phone",         :limit => 30
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subcontractor"
    t.float    "commission"
  end

  create_table "customers", :force => true do |t|
    t.string   "name",       :limit => 40, :default => "somebox", :null => false
    t.string   "short_name", :limit => 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "postal"
    t.integer  "contact_id"
  end

  create_table "invoices", :force => true do |t|
    t.integer  "customer_id"
    t.string   "status",            :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "balance_due"
    t.date     "date"
    t.integer  "number"
    t.float    "discount"
    t.float    "adjustment"
    t.string   "note"
    t.string   "adjustment_reason"
    t.string   "discount_reason"
  end

  create_table "line_items", :force => true do |t|
    t.integer "invoice_id"
    t.integer "service_id"
    t.date    "date_performed"
    t.float   "quantity"
    t.float   "rate"
    t.string  "description"
    t.integer "contact_id"
  end

  add_index "line_items", ["invoice_id"], :name => "invoice_id"

  create_table "schema_info", :id => false, :force => true do |t|
    t.integer "version"
  end

  create_table "services", :force => true do |t|
    t.string "name",         :limit => 40
    t.float  "default_rate"
    t.text   "description"
    t.string "unit"
  end

  create_table "timeslips", :force => true do |t|
    t.date     "date_performed"
    t.float    "time"
    t.string   "description"
    t.integer  "contact_id"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "service_id"
  end

end
