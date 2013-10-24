module RoundTrip
  class MatchedTicketUpdaterService
    attr_reader :project
    attr_reader :trello_list_map
    attr_reader :redmine_trackers
    attr_reader :redmine_statuses

    def initialize(project, trello_list_map, redmine_trackers, redmine_statuses)
      @project, @trello_list_map, @redmine_trackers, @redmine_statuses = project, trello_list_map, redmine_trackers, redmine_statuses
    end

    def run
      project_tickets = Ticket.for_project(project.id)
      project_tickets.redmine_newer.each do |ticket|
        update_trello_to_redmine ticket
      end
      project_tickets.trello_newer.each do |ticket|
        update_redmine_to_trello ticket
      end
    end

    private

    def update_trello_to_redmine(ticket)
      ticket.trello_name = ticket.redmine_subject
      ticket.trello_description = ticket.redmine_description
      ticket.save!
    end

    def update_redmine_to_trello(ticket)
      ticket.redmine_subject     = ticket.trello_name
      ticket.redmine_description = ticket.trello_description

      list    = trello_list_map.list_for_id(ticket.trello_list_id)
      area    = trello_list_map.list_to_area(list)
      tracker = redmine_trackers.area_to_tracker(area)

      case area
      when :ideas
        ticket.redmine_tracker_id = tracker.id
      when :backlog
        if redmine_tracker == :ideas
          ticket.redmine_tracker_id = tracker.id
        end
      else
        raise 'unhandled area'
      end

      ticket.save!
    end
  end
end

