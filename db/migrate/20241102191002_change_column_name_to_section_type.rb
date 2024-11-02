class ChangeColumnNameToSectionType < ActiveRecord::Migration[7.0]
  def change
    rename_column :sections, :type, :section_type
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
