require 'test_helper'

describe Rating do
  subject { Rating.new }

  describe "model attributes" do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
    it { subject.must_respond_to :rating }
    it { subject.must_respond_to :rated_user_id }
    it { subject.must_respond_to :text }
    it { subject.must_respond_to :business_transaction_id }
  end

  describe "associations" do
    it { subject.must belong_to :business_transaction }
    it { subject.must belong_to :rated_user  }
  end

  # describe "enumerization" do # see business_transaction_test
  #   it { subject.must enumerize(:rating).in(:positive, :neutral, :negative) }
  # end
end
