require "rails_helper"

RSpec.describe LearningsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/learnings").to route_to("learnings#index")
    end

    it "routes to #new" do
      expect(:get => "/learnings/new").to route_to("learnings#new")
    end

    it "routes to #show" do
      expect(:get => "/learnings/1").to route_to("learnings#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/learnings/1/edit").to route_to("learnings#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/learnings").to route_to("learnings#create")
    end

    it "routes to #update" do
      expect(:put => "/learnings/1").to route_to("learnings#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/learnings/1").to route_to("learnings#destroy", :id => "1")
    end

  end
end
