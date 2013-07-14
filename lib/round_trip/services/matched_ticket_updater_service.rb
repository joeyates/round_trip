module RoundTrip
  class MatchedTicketUpdaterService
    attr_reader :project
    attr_reader :list_map

    def initialize(project, list_map)
      @project, @list_map = project, list_map
    end

    def run
      redmine_newer
      trello_newer
    end

    private

    def redmine_newer
      project_tickets = Ticket.for_project(project.id)

      project_tickets.redmine_newer.each do |t|
        list = list_map.list_for_id(t.trello_list_id)
        area = list_map.list_to_area(list)

        t.trello_name = t.redmine_subject
        t.trello_description = t.redmine_description
        t.save!
      end
    end

    def trello_newer
      project_tickets = Ticket.for_project(project.id)

      project_tickets.trello_newer.each do |t|
        t.redmine_subject = t.trello_name
        t.redmine_description = t.trello_description
        t.save!
      end
    end
  end
end

