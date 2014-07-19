class CreateDranksRelation < ActiveRecord::Migration
  def change
    create_table :dranks do |t|
      t.string  :drink_name
      t.float   :alcohol_content
      t.string  :drink_type
    end
  end
end