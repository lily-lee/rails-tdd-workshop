require 'rails_helper'

RSpec.describe User, type: :model do
  before :each do
    # build :user 跟 factory :user 一致
    @user = build :user
  end

  subject {@user}

  it { should respond_to :email }
  it { should respond_to :password }
  it { should respond_to :password_confirmation}
  it { should be_valid }
end
