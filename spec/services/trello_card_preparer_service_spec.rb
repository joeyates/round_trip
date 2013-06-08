require 'spec_helper'

module RoundTrip
  describe TrelloCardPreparerService do
    it_behaves_like 'a class with construtor arity', 1

    describe '.initialize' do
      it 'expects a project'
    end

    describe '#run' do
      it 'selects non-united tickets'
      it 'copies redmine data to trello'
      it 'saves'
    end
  end
end

