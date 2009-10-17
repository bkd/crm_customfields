require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "admin/customfields/show.html.haml" do
  include Admin::CustomfieldsHelper

  before(:each) do
  login_and_assign(:admin => true)
    assigns[:customfield] = Factory(:customfield, :id => 42)
    assigns[:users] = [ @current_user ]
    
  end

  it "should render customfield landing page" do
    
    render "admin/customfields/show.html.haml"

    response.should have_tag("div[id=edit_customfield]")
  end

end

