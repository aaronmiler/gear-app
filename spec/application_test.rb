describe FrontEndController, "Testing the Application Funcionality" do 
	it "should redirect to index with a notice on successful save" do
	   MenuItem.any_instance.stubs(:valid?).returns(true)
	   post 'create'
	   assigns[:menu_item].should_not be_new_record
	   flash[:notice].should_not be_nil
	   response.should redirect_to(menu_items_path)
	 end
end