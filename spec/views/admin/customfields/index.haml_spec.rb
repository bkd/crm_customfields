require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "admin/customfields/index.html.erb" do
  include Admin::CustomfieldsHelper
  
  before(:each) do
    login_and_assign(:admin => true)
  end

  it "should render a list of customfields if it's not empty" do
    assigns[:customfields] = [ Factory(:customfield) ].paginate
    template.should_receive(:render).with(hash_including(:partial => "customfield"))
    template.should_receive(:render).with(:partial => "common/paginate")
    render "admin/customfields/index.html.haml"
  end

  it "should render a message if there're no customfields" do
    assigns[:customfields] = [].paginate
    template.should_not_receive(:render).with(hash_including(:partial => "customfield"))
    template.should_receive(:render).with(:partial => "common/empty")
    template.should_receive(:render).with(:partial => "common/paginate")
    render "admin/customfields/index.html.haml"
  end

end

