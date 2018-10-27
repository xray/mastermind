require_relative 'mm_outputs'

class Choice
    class << self
        def create(query, default_state = true, out = Outputs)
            @out = out
            default_display = configure_default_display(default_state)
            question = "#{query} #{default_display}"
            return pose(question, default_state)
        end

            private

        def configure_default_display(default)
            if default
                return "(Y/n)"
            else
                return "(y/N)"
            end
        end

        def pose(question, default)
            valid_input = false
            valid_choice = nil
            system "clear"
            until valid_input do
                @out.ask_question(question)
                choice = gets.chomp.upcase
                if choice == "Y"
                    valid_choice = true
                    valid_input = true
                elsif choice == "N"
                    valid_choice = false
                    valid_input = true
                elsif choice == ""
                    valid_choice = default
                    valid_input = true
                else
                    err_data = {
                        err: true,
                        bad_input: [true, "\"#{choice.downcase}\" is not either \"y\", \"n\" or blank..."]
                    }
                    @out.input_err(err_data, true)
                end
            end
            return valid_choice
        end
    end
end