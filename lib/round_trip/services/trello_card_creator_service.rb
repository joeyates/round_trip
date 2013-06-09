module RoundTrip
  class TrelloCardCreatorService
    attr_reader :project

    def initialize(project)
      @project = project
    end

    def run
      Ticket.for_project(project.id).without_trello.all.each do |t|
        attributes = card_attributes(t)
        authorizer.client.create(:cards, attributes)
      end
    end

    private

    def authorizer
      @authorizer ||= Trello::Authorizer.new(
        project.config[:trello_key],
        project.config[:trello_secret],
        project.config[:trello_token],
      )
    end

    def card_attributes(ticket)
      {
        'name' => ticket.trello_name,
        'desc' => ticket.trello_description,
        'idList' => '',
      }
    end
  end
end

