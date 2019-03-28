class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :address_type
      t.string :line1
      t.string :line2
      t.string :postal_code
      t.string :city
      t.string :country_id, limit: 2

      # TODO: latitude, longitude 

      t.timestamps
    end

    # add_index :addresses, [:address_type, :line1, :line2, :postal_code, :town, :country_id], unique: true, name: 'index_addresses_on_all_columns'
  end
end
