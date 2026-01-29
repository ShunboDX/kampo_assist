module ApplicationHelper
    def search_step_current
        case controller.action_name
        when "step1"
        1
        when "step2"
        2
        when "results"
        3
        else
        1
        end
    end
end
