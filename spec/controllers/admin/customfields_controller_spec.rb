require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::CustomfieldsController do

  before(:each) do
    require_user(:admin => true)
    set_current_tab(:customfields)
  end

  # GET /customfields
  # GET /customfields.xml
  #----------------------------------------------------------------------------
  describe "responding to GET index" do

    it "should expose all customfields as @customfields and render [index] template" do
      @customfields = [ Factory(:customfield, :user => @current_user) ]

      get :index
      assigns[:customfields].should == @customfields
      response.should render_template("admin/customfields/index")
    end
    
    describe "AJAX pagination" do
      it "should pick up page number from params" do
        @customfields = [ Factory(:customfield, :user => @current_user) ]
        xhr :get, :index, :page => 42

        assigns[:current_page].to_i.should == 42
        assigns[:customfields].should == [] # page #42 should be empty if there's only one customfield ;-)
        session[:customfields_current_page].to_i.should == 42
        response.should render_template("admin/customfields/index")
      end
      
      it "should pick up saved page number from session" do
        session[:customfields_current_page] = 42
        @customfields = [ Factory(:customfield, :user => @current_user) ]
        xhr :get, :index

        assigns[:current_page].should == 42
        assigns[:customfields].should == []
        response.should render_template("admin/customfields/index")
      end
    end

    describe "with mime type of XML" do
      it "should render all customfields as xml" do
        @customfields = [ Factory(:customfield, :user => @current_user) ]
        request.env["HTTP_ACCEPT"] = "application/xml"
        get :index
        response.body.should == @customfields.to_xml
      end
    end
    describe "with mime type of XML" do
      it "should render all customfields as xml" do
        @customfields = [ Factory(:customfield, :user => @current_user) ]

        request.env["HTTP_ACCEPT"] = "application/xml"
        get :index
        response.body.should == @customfields.to_xml
      end
    end
  end

  # GET /customfields/1
  # GET /customfields/1.xml                                                    HTML
  #----------------------------------------------------------------------------
  describe "responding to GET show" do

    describe "with mime type of HTML" do
      before(:each) do
        @customfield = Factory(:customfield, :id => 42)
      end

      it "should expose the requested customfield as @customfield" do
        get :show, :id => 42
        assigns[:customfield].should == @customfield
        response.should render_template("admin/customfields/show")
      end

    end
  
    describe "with mime type of XML" do
      it "should render the requested customfield as xml" do
        @customfield = Factory(:customfield, :id => 42)

        request.env["HTTP_ACCEPT"] = "application/xml"
        get :show, :id => 42
        response.body.should == @customfield.to_xml
      end
    end

    describe "customfield got deleted or otherwise unavailable" do
      it "should redirect to customfield index if the customfield got deleted" do
        @customfield = Factory(:customfield, :user => @current_user).destroy
        get :show, :id => @customfield.id
        flash[:warning].should_not == nil
        response.should redirect_to(admin_customfields_path)
      end

      it "should return 404 (Not Found) XML error" do
        @customfield = Factory(:customfield, :user => @current_user).destroy
        request.env["HTTP_ACCEPT"] = "application/xml"
        get :show, :id => @customfield.id
        response.code.should == "404" # :not_found
      end
    end
   
  end

  # GET /customfields/new
  # GET /customfields/new.xml                                                  AJAX
  #----------------------------------------------------------------------------
  describe "responding to GET new" do
    it "should expose a new customfield as @customfield and render [new] template" do
      @customfield = Customfield.new(:user => @current_user)
      @users = [ Factory(:user) ]
      xhr :get, :new
      assigns[:customfield].attributes.should == @customfield.attributes
      response.should render_template("admin/customfields/new")
    end
  end

  # GET /customfields/1/edit                                                   AJAX
  #----------------------------------------------------------------------------
  describe "responding to GET edit" do
    it "should expose the requested customfield as @customfield and render [edit] template" do
      @customfield = Factory(:customfield, :id => 42, :user => @current_user)
      xhr :get, :edit, :id => 42
      assigns[:customfield].should == @customfield
      assigns[:previous].should == nil
      response.should render_template("admin/customfields/edit")
    end

    it "should expose the requested customfield as @customfield" do
      @customfield = Factory(:customfield, :id => 42, :user => @current_user)
      xhr :get, :edit, :id => 42
      assigns[:customfield].should == @customfield
    end

    it "should expose previous customfield as @previous when necessary" do
      @customfield = Factory(:customfield, :id => 42)
      @previous = Factory(:customfield, :id => 1992)

      xhr :get, :edit, :id => 42, :previous => 1992
      assigns[:previous].should == @previous
    end

    describe "(customfield got deleted or is otherwise unavailable)" do
      it "should reload current page with the flash message if the customfield got deleted" do
        @customfield = Factory(:customfield, :user => @current_user).destroy

        xhr :get, :edit, :id => @customfield.id
        flash[:warning].should_not == nil
        response.body.should == "window.location.reload();"
      end
    end

    describe "(previous customfield got deleted or is otherwise unavailable)" do
      before(:each) do
        @customfield = Factory(:customfield, :user => @current_user)
        @previous = Factory(:customfield, :user => Factory(:user))
      end

      it "should notify the view if previous customfield got deleted" do
        @previous.destroy

        xhr :get, :edit, :id => @customfield.id, :previous => @previous.id
        flash[:warning].should == nil
        assigns[:previous].should == @previous.id
        response.should render_template("admin/customfields/edit")
      end
    end
  end

  # POST /customfields
  # POST /customfields.xml                                                     AJAX
  #----------------------------------------------------------------------------
  describe "responding to POST create" do

    describe "with valid params" do

      it "should expose a newly created customfield as @customfield and render [create] template" do
        @customfield = Factory.build(:customfield, 
            :field_name => "skype_address", 
            :field_label => "Skype address", 
            :field_type => "String", 
            :max_size => 220, 
            :display_sequence => 10,
            :display_block => 10,
            :display_width => 250,
            :table_name => "Acccount"
        )
        Customfield.stub!(:new).and_return(@customfield)
        xhr :post, :create, :customfield => { 
            :field_name => "skype_address", 
            :field_label => "Skype address", 
            :field_type => "String", 
            :max_size => 220, 
            :display_sequence => 10,
            :display_block => 10,
            :display_width => 250,
            :table_name => "Acccount"}, :users => %w(1 2 3)
        assigns(:customfield).should == @customfield
        response.should render_template("admin/customfields/create")
      end

      it "should reload customfields to update pagination if called from customfields index" do
        @customfield = Factory.build(:customfield, :user => @current_user)
        Customfield.stub!(:new).and_return(@customfield)

        request.env["HTTP_REFERER"] = "http://localhost/customfields"
        xhr :post, :create, :customfield => {  
            :field_name => "skype_address", 
            :field_label => "Skype address", 
            :field_type => "String", 
            :max_size => 220, 
            :display_sequence => 10,
            :display_block => 10,
            :display_width => 250,
            :table_name => "Acccount" }, :users => %w(1 2 3)
        assigns[:customfields].should == [ @customfield ]
      end
    end
    
    
    describe "with invalid params" do
      before(:each) do
        @customfield = Factory.build(:customfield, :field_name => "222 aaaa bbb ccc", :user => @current_user)
        Customfield.stub!(:new).and_return(@customfield)
      end
      # Redraw [create] form 
      it "should redraw [Create Customfield] form with selected account" do
        # This redraws [create] form 
        xhr :post, :create, :customfield => {}
        assigns(:customfield).should == @customfield
        response.should render_template("admin/customfields/create")
      end
    end
  end  

  # PUT /customfields/1
  # PUT /customfields/1.xml                                                    AJAX
  #----------------------------------------------------------------------------
  describe "responding to PUT udpate" do

    describe "with valid params" do
      it "should update the requested customfield and render [update] template" do
        @customfield = Factory(:customfield, :id => 42,             
        	:field_name => "skype_address", 
            :field_label => "Skype address", 
            :field_type => "String", 
            :max_size => 220, 
            :display_sequence => 10,
            :display_block => 10,
            :display_width => 250,
            :table_name => "Account" )

        xhr :put, :update, :id => 42, :customfield => {             
        	:field_name => "skype_address", 
            :field_label => "Skype address", 
            :field_type => "String", 
            :max_size => 220, 
            :display_sequence => 10,
            :display_block => 10,
            :display_width => 250,
            :table_name => Account }
        @customfield.reload.field_name.should == "skype_address"
        @customfield.reload.field_label.should == "Skype address"
        @customfield.reload.field_type.should == "String"
        @customfield.reload.max_size.should == 220
        @customfield.reload.display_sequence.should == 10
        @customfield.reload.display_block.should == 10
        @customfield.reload.display_width.should == 250
        @customfield.reload.table_name.should == "Account"
        assigns(:customfield).should == @customfield
        response.should render_template("admin/customfields/update")
      end

      describe "customfield got deleted or otherwise unavailable" do
        it "should reload current page is the customfield got deleted" do
          @customfield = Factory(:customfield, :user => @current_user).destroy
          xhr :put, :update, :id => @customfield.id
          flash[:warning].should_not == nil
          response.body.should == "window.location.reload();"
        end
      end
    end

    describe "with invalid params" do
      it "should not update the customfield, but still expose it as @customfield and render [update] template" do
        @customfield = Factory(:customfield, :id => 42, :user => @current_user, :field_name => 'foo')
        xhr :put, :update, :id => 42, :customfield => { :field_name => nil }
        @customfield.reload.field_name.should == 'foo'
        assigns(:customfield).should == @customfield
        response.should render_template("admin/customfields/update")
      end
    end

  end

  ## TODO 

  # GET /customfields/search/query                                                AJAX
  #----------------------------------------------------------------------------
  #describe "responding to GET search" do
  #  before(:each) do
  #    @first  = Factory(:customfield, :user => @current_user, :field_label => "foo one")
  #    @second = Factory(:customfield, :user => @current_user, :field_label => "foo two")
  #    @customfields = [ @first, @second ]
  #  end

  #  it "should perform lookup using query string and redirect to index" do
  #    xhr :get, :search, :query => "two"

  #  assigns[:customfields].should == [ @second ]
  #  assigns[:current_query].should == "two"
  #    session[:customfields_current_query].should == "two"
  #    response.should render_template("admin/customfields/index")
  #  end

  #  describe "with mime type of XML" do
  #    it "should perform lookup using query string and render XML" do
  #      request.env["HTTP_ACCEPT"] = "application/xml"
  #      get :search, :query => "two?!"

  #      response.body.should == [ @second ].to_xml
  #    end
  #  end
  #end

  # POST /customfields/auto_complete/query                                     AJAX
  #----------------------------------------------------------------------------
  #describe "responding to POST auto_complete" do
  #  before(:each) do
  #    @auto_complete_matches = [ Factory(:customfield, :field_label => "foo", :user => @current_user) ]
  #  end

  #  it_should_behave_like("auto complete")
  #end


  ## GET /customfields/options                                                 AJAX
  ##----------------------------------------------------------------------------
  #describe "responding to GET options" do
  #  it "should set current user preferences when showing options" do
  #    @per_page = Factory(:preference, :user => @current_user, :name => "customfields_per_page", :value => Base64.encode64(Marshal.dump(42)))
  #    @outline  = Factory(:preference, :user => @current_user, :name => "customfields_outline",  :value => Base64.encode64(Marshal.dump("long")))
  #    @sort_by  = Factory(:preference, :user => @current_user, :name => "customfields_sort_by",  :value => Base64.encode64(Marshal.dump("customfields.field_name ASC")))

  #    xhr :get, :options
  #    assigns[:per_page].should == 42
  #    assigns[:outline].should  == "long"
  #    assigns[:sort_by].should  == "field_name"
  #  end

  #  it "should not assign instance variables when hiding options" do
  #    xhr :get, :options, :cancel => "true"
  #    assigns[:per_page].should == nil
  #    assigns[:outline].should  == nil
  #    assigns[:sort_by].should  == nil
  #  end
  #end

  ## POST /customfields/redraw                                                 AJAX
  ##----------------------------------------------------------------------------
  #describe "responding to POST redraw" do
  #  it "should save user selected customfield preference" do
  #    xhr :post, :redraw, :per_page => 42, :outline => "brief", :sort_by => "field_name"
  #    @current_user.preference[:customfields_per_page].should == "42"
  #    @current_user.preference[:customfields_outline].should  == "brief"
  #    @current_user.preference[:customfields_sort_by].should  == "customfields.field_name ASC"
  #  end

  #  it "should reset current page to 1" do
  #    xhr :post, :redraw, :per_page => 42, :outline => "brief", :sort_by => "field_name"
  #    session[:customfields_current_page].should == 1
  #  end

  #  it "should select @customfields and render [index] template" do
  #    @customfields = [
  #      Factory(:customfield, :field_name => "A", :user => @current_user),
  #      Factory(:customfield, :field_name => "B", :user => @current_user)
  #    ]

  #    xhr :post, :redraw, :per_page => 1, :sort_by => "field_name"
  #    assigns(:customfields).should == [ @customfields.first ]
  #    response.should render_template("admin/customfields/index")
  #  end
  #end

end
