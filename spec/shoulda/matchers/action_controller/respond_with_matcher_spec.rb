require 'spec_helper'

describe Shoulda::Matchers::ActionController::RespondWithMatcher do
  statuses = { :success => 200, :redirect => 301, :missing => 404, :error => 500,
    :not_implemented => 501 }

  statuses.each do |human_name, numeric_code|
    context "a controller responding with #{human_name}" do
      let(:controller) do
        build_response do
          render :text => "text", :status => numeric_code
        end
      end

      it "accepts responding with a numeric response code" do
        controller.should respond_with(numeric_code)
      end

      it "accepts responding with a symbol response code" do
        controller.should respond_with(human_name)
      end

      it "rejects responding with another status" do
        another_status = statuses.except(human_name).keys.first

        controller.should_not respond_with(another_status)
      end
    end
  end
end
