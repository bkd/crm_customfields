require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::CustomfieldsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "admin/customfields", :action => "index").should == "admin/customfields"
    end
  
    it "maps #new" do
      route_for(:controller => "admin/customfields", :action => "new").should == "admin/customfields/new"
    end
  
    it "maps #show" do
      route_for(:controller => "admin/customfields", :action => "show", :id => "1").should == "admin/customfields/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "admin/customfields", :action => "edit", :id => "1").should == "admin/customfields/1/edit"
    end
  
    it "maps #create" do
      route_for(:controller => "admin/customfields", :action => "create").should == { :path => "admin/customfields", :method => :post }
    end 

    it "maps #update" do
      route_for(:controller => "admin/customfields", :action => "update", :id => "1").should == { :path => "admin/customfields/1", :method => :put }
    end
  
    it "maps #destroy" do
      route_for(:controller => "admin/customfields", :action => "destroy", :id => "1").should == { :path => "admin/customfields/1", :method => :delete }
    end

    it "maps #search" do
      route_for(:controller => "admin/customfields", :action => "search", :id => "1").should == "admin/customfields/search/1"
    end

    it "maps #auto_complete" do
      route_for(:controller => "admin/customfields", :action => "auto_complete", :id => "1").should == "admin/customfields/auto_complete/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/admin/customfields").should == {:controller => "admin/customfields", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/admin/customfields/new").should == {:controller => "admin/customfields", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/admin/customfields").should == {:controller => "admin/customfields", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/admin/customfields/1").should == {:controller => "admin/customfields", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/admin/customfields/1/edit").should == {:controller => "admin/customfields", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/admin/customfields/1").should == {:controller => "admin/customfields", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/admin/customfields/1").should == {:controller => "admin/customfields", :action => "destroy", :id => "1"}
    end

    it "should generate params for #search" do
      params_from(:get, "/admin/customfields/search/1").should == {:controller => "admin/customfields", :action => "search", :id => "1"}
    end

    it "should generate params for #auto_complete" do
      params_from(:post, "/admin/customfields/auto_complete/1").should == {:controller => "admin/customfields", :action => "auto_complete", :id => "1"}
    end
  end
end
