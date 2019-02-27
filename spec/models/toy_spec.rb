require 'rails_helper'

RSpec.describe Toy, type: :model do
  before :each do
    # build :toy 跟 factory :toy 一致
    @toy = build :toy
  end

  subject { @toy }

  it { should respond_to :title }
  it { should respond_to :price }
  it { should respond_to :published }
  it { should respond_to :user_id }
  it { should be_valid }

  it { should validate_presence_of :title }
  it { should validate_presence_of :price }
  it { should validate_presence_of :user_id }
  it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }

  it { should belong_to :user }

  describe '#filter_by_title to search toys match title keyword' do
    before :each do
      @toy1 = create :toy, title: 'Ruby boy'
      @toy2 = create :toy, title: 'Elixir girl'
      @toy3 = create :toy, title: 'Redis man'
      @toy4 = create :toy, title: 'Ruby on Rails'
    end

    it 'search toys with keyword' do
      expect(Toy.filter_by_title('Ruby')).to match_array([@toy4, @toy1])
    end
  end

  describe '#above_or_equal_to_price' do
    before :each do
      @toy1 = create :toy, price: 100
      @toy2 = create :toy, price: 50
      @toy3 = create :toy, price: 150
      @toy4 = create :toy, price: 99
    end

    it 'search toys above or equal to price' do
      expect(Toy.above_or_equal_to_price(100)).to match_array([@toy3, @toy1])
    end
  end

  describe '#blow_or_equal_to_price' do
    before :each do
      @toy1 = create :toy, price: 100
      @toy2 = create :toy, price: 50
      @toy3 = create :toy, price: 150
      @toy4 = create :toy, price: 99
    end

    it 'search toys below or equal to price' do
      expect(Toy.below_or_equal_to_price(100)).to match_array([@toy4, @toy2, @toy1])
    end
  end

  describe '#recent' do
    before :each do
      @toy1 = create :toy
      @toy2 = create :toy
      @toy3 = create :toy
      @toy4 = create :toy
      @toy2.touch
      @toy3.touch
    end

    it 'should return toys order by updated_at desc' do
      expect(Toy.recent()).to eq [@toy3, @toy2, @toy4, @toy1]
    end
  end

  describe '#search' do
    before :each do
      @toy1 = create :toy, title: 'Ruby boy', price: 100
      @toy2 = create :toy, title: 'Elixir girl', price: 50
      @toy3 = create :toy, title: 'Redis man', price: 150
      @toy4 = create :toy, title: 'Ruby on Rails', price: 99
      @toy2.touch
      @toy3.touch
      @toy1.touch
    end

    it 'when just have keyword and min_price' do
      params = { keyword: 'man', min_price: 100 }
      expect(Toy.search_by_params(params)).to eq [@toy3]
    end

    it 'when keyword, min_price, max_price, order' do
      params = { keyword: 'R', min_price: 99, max_price: 100, desc_order: true }
      expect(Toy.search_by_params(params)).to eq [@toy1, @toy4]
    end

    it 'when params is empty' do
      params = {}
      # expect(Toy.search_by_params(params)).to eq [@toy1, @toy2, @toy3, @toy4]
      expect(Toy.search_by_params(params)).to match_array([@toy1, @toy2, @toy3, @toy4])
    end
  end
end
