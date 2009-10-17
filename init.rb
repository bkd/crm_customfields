require "fat_free_crm"

FatFreeCRM::Plugin.register(:crm_customfields, initializer) do
          name "Fat Free Customfields"
        author "Brett Dawkins"
       version "0.1"
   description "Basic admin module for custom fields"
  dependencies :haml, :simple_column_search
           tab :main, :text => "Customfields", :url => { :controller => "admin/customfields" }
end

