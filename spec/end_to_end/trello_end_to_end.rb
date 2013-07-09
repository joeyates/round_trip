require 'yaml'
require 'trello'
require 'active_support/core_ext/string'

describe 'Trello API' do
  before :all do
    root_path           = File.expand_path('../..', File.dirname(__FILE__))
    @end_to_end_config  = YAML.load_file(File.join(root_path, 'config', 'end_to_end.yml'))
    @client             = Trello::Client.new(@end_to_end_config[:trello][:authentication])
  end

  describe 'client' do
    describe '#find' do
      context ':members' do
        it "'me' gets current user's data" do
          member = @client.find(:members, 'me')

          expect(member.attributes).to eq(@end_to_end_config[:trello][:user])
        end

        it "id retrieves user data" do
          member = @client.find(:members, @end_to_end_config[:trello][:user][:id])

          expect(member.attributes).to eq(@end_to_end_config[:trello][:user])
        end
      end

      context ':boards' do
        it "id retrieves board data" do
          board = @client.find(:boards, @end_to_end_config[:trello][:board][:id])

          config = @end_to_end_config[:trello][:board]
          config.each do |k, v|
            expect(board.attributes[k]).to eq(config[k])
          end
        end
      end

      context ':cards' do
        it "id retrieves card data" do
          card = @client.find(:cards, @end_to_end_config[:trello][:card][:id])

          config = @end_to_end_config[:trello][:card]
          config.each do |k, v|
            expect(card.attributes[k]).to eq(config[k])
          end
        end
      end
    end
  end

  describe 'member' do
    before :all do
      @member = @client.find(:members, 'me')
    end

    describe '#boards' do
      it "gets the user's boards" do
        boards = @member.boards

        expect(boards.size).to be > 0
        expect(boards[0]).to be_a(Trello::Board)
      end
    end
  end

  describe 'board' do
    before :all do
      @board = @client.find(:boards, @end_to_end_config[:trello][:board][:id])
    end

    describe '#cards' do
      it "gets the board's cards" do
        cards = @board.cards

        expect(cards.size).to be > 0
        expect(cards[0]).to be_a(Trello::Card)
      end
    end
  end
end

