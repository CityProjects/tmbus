require "spec_helper"

describe Route do

  it "has a valid factory" do
    FactoryGirl.create(:route).should be_true
  end


  describe "validations" do

    it "validates type" do
      FactoryGirl.build(:route, type: nil).should_not be_valid
      FactoryGirl.build(:route, type: 0).should_not be_valid
    end

    it "validates number" do
      FactoryGirl.build(:route, number: nil).should_not be_valid
    end

    it "validates direction" do
      FactoryGirl.build(:route, direction: nil).should_not be_valid
      FactoryGirl.build(:route, direction: 0).should_not be_valid
    end

  end



  describe "#clean_outdated_routes" do
    it "deletes old outdated routes, but leaves recently updated ones" do
      num_updated_routes = 4
      num_outdated_routes = 2
      num_updated_routes.times do
        FactoryGirl.create(:route)
      end
      num_outdated_routes.times do
        FactoryGirl.create(:route, ratt_updated_at: (rand 10..20).days.ago )
      end

      Route.count.should == num_updated_routes + num_outdated_routes
      Route.clean_outdated_routes.should == num_outdated_routes
      Route.count.should == num_updated_routes
    end
  end


end
