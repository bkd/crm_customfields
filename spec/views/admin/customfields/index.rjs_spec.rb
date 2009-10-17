require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "admin/customfields/index.js.rjs" do
  include Admin::CustomfieldsHelper
  
  before(:each) do
    login_and_assign(:admin => true)
  end

  it "should render [customfield] template with @customfields collection if there are customfields" do
    assigns[:customfields] = [ Factory(:customfield, :id => 42) ].paginate

    render "admin/customfields/index.js.rjs"
    response.should have_rjs("customfields") do |rjs|
      with_tag("li[id=customfield_#{42}]")
    end
    response.should have_rjs("paginate")
  end

  it "should render [empty] template if @customfields collection if there are no customfields" do
    assigns[:customfields] = [].paginate

    render "admin/customfields/index.js.rjs"
    response.should have_rjs("customfields") do |rjs|
      with_tag("div[id=empty]")
    end
    response.should have_rjs("paginate")
  end

end