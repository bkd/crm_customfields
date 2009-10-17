# Install hook code here

puts <<-EOF
The Customfields plugin for Fat Free CRM is designed to  be a simple GUI that 
uses the rake tasks to create the migration files, it then checks what hasnt 
been done and then runs the rake task to peform the migration.  If you drop, 
or empty the database the customfields table will be empty, but the migration 
files found in db/migrate will still exist.  If you want to keep the customfield 
information, make a seperate rake task, or backup the customfields table before 
you empty or drop.  This plugin isnt finished - a mere concept in progress!!

Once the plugin is installed run the following command:

  rake db:migrate:plugin NAME=crm_customfields

EOF