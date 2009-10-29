CRM Customfields
============

**This plugin is under development, and is not yet ready for use!**

As it says, an admin module to allow you to add any type of field to any existing model on the fly.  It will 
allow the admin user to create the extra column types and then if the admin user has the rights, it will migrate the database
to reflect the changes.  Currently it allows you to add and rename customfields, for text/textarea (string, integer, text).  Later it
will include the full GUI to add the rest of the column types.  

Essentially it is a simple GUI that uses the rake tasks to create the migration files, it then checks what hasnt been done and then 
runs the rake task to peform the migration.  If you drop, or empty the database the customfields table will be empty, but the migration 
files found in db/migrate will still exist.  If you want to keep the customfield information, make a seperate rake task, or backup the 
customfields table before you empty or drop.
 
Later versions will re-read the migration files it created and re populate the customfields table, but for now its up to you!

Installation
============

The Customfields plugin can be installed by running:

    script/install plugin git://github.com/bkd/crm_customfields.git

Then run the following command:

    rake db:migrate:plugin NAME=crm_customfields

Then restart your web server.


A few others have tried this so for now some useful pointers, some quick fixes to make sure you can get it to work for now.  The whole plugin as been redeveloped and its coming along, this will be a quick solution, rather ugly but will work.

1. add this to _edit.html.haml in view/accounts  and modify then add to view/contacts, view/opportunities
= render :partial => "accounts/customfields", :locals => { :f => f, :edit => true }

2. also create a file called _customfields.html.haml in the view/accounts folder
add this to the file


- collapsed = session[:account_customfields].nil? # && @account.errors.empty?
= subtitle :account_customfields, collapsed, "Custom fields"
.section
  %small#account_customfields_intro{ hidden_if(!collapsed) }
    You can add custom information below, check with your administator if you need to add new fields here.
  #account_customfields{ hidden_if(collapsed) }
    %table{ :width => 500, :cellpadding => 0, :cellspacing => 0 }
      - @customfields.each_with_index do |cf,i| 
        - if i.even?
          %tr 
        %td{ :valign => :top }
          .label.top.req 
            =cf.field_label
          = f.text_field cf.field_name, :style => "width: #{cf.display_width}px" if cf.field_type=='Integer'
          = f.text_field cf.field_name, :style => "width: #{cf.display_width}px" if cf.field_type=='String'
          = f.textarea cf.field_name, :style => "width: #{cf.display_width}px" if cf.field_type=='Textarea'
            
      
3.  change common/_empty.html.haml to 

- assets = controller.controller_name
- asset = assets.singularize
- if controller.controller_name == 'customfields'
  - admin_link = "admin_" 
- else 
  - admin_link = ""
#empty
  - if @current_query.blank?
    == Couldn't find #{assets}. Feel free to #{link_to_remote("create a new " << asset, :url => send("new_" << admin_link << asset << "_path"))}.
  - else
    == Couldn't find #{assets} matching <span class="cool"><b>#{h @current_query}</b></span>; please try another query.



4. in application_helper change to

  #----------------------------------------------------------------------------
  def link_to_edit(model)
    name = model.class.name.downcase
    name=='customfield' ? admin_link="admin_" : admin_link=""
    link_to_remote("Edit",
      :method => :get,
      :url    => send("edit_#{admin_link}#{name}_path", model),
      :with   => "{ previous: crm.find_form('edit_#{admin_link}#{name}') }"
    )
  end

this should work!!
