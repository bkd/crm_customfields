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

