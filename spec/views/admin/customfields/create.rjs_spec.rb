require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "admin/customfields/create.js.rjs" do
  include Admin::CustomfieldsHelper

  before(:each) do
    login_and_assign(:admin => true)
  end

  describe "create success" do
    before(:each) do
      assigns[:customfield] = @customfield = Factory(:customfield)
      assigns[:customfields] = [ @customfield ].paginate
    end

    it "should hide [Create Customfield] form and insert customfield partial" do
      render "admin/customfields/create.js.rjs"

      response.should have_rjs(:insert, :top) do |rjs|
        with_tag("li[id=customfield_#{@customfield.id}]")
      end
      response.should include_text(%Q/$("customfield_#{@customfield.id}").visualEffect("highlight"/)
    end

    it "should update pagination when called from customfields index" do
      request.env["HTTP_REFERER"] = "http://localhost/customfields"
      render "admin/customfields/create.js.rjs"

      response.should have_rjs("paginate")
    end
 end
  
  describe "create failure" do
    it "create (failure): should re-render [create.html.haml] template in :create_customfield div" do
      assigns[:customfield] = Factory.build(:customfield, :field_name => nil) # make it invalid
      @current_user = Factory(:user)
      assigns[:table_name]=%w(Account Contact Opportunity)
      assigns[:type]=%w(Integer String Text)
      assigns[:users] = [ @current_user ]
      
      render "admin/customfields/create.js.rjs"

      response.should have_rjs("create_customfield") do |rjs|
        with_tag("form[class=new_customfield]")
      end
      response.should include_text('visualEffect("shake"')
    end
  end

end


