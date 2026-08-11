# The dummy app has no migrations; the schema is recreated on every boot.
ActiveSupport.on_load(:active_record) do
  ActiveRecord::Schema.verbose = false
  ActiveRecord::Schema.define do
    create_table :widgets, force: true do |t|
      t.string :name
      t.timestamps
    end
  end
end
