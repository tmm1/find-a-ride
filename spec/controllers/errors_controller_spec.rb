require 'spec_helper'

describe ErrorsController do
  describe "not found" do
    it "should render not found " do      
      get 'not_found'
      response.should render_template(:not_found)      
    end
  end
  describe "internal server error" do
    it "should render internal server error page " do
      get 'internal_server_error'
      response.should render_template(:internal_server_error)
    end
  end
  describe "method not allowed" do
    it "should render method not allowed page" do
      get 'method_not_allowed'
      response.should render_template(:method_not_allowed)
    end
  end
  describe "unprocessable entity" do
    it "should render unprocessable entity page" do
      get 'unprocessable_entity'
      response.should render_template(:unprocessable_entity)
    end
  end
end
