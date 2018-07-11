require_relative 'mm_outputs'

class Choice
    class << self
        def create(query, default_state = true, out = Outputs)
            @out = out
            default_display = ""
            if default_state
                default_display = "(Y/n)"
            else
                default_display = "(y/N)"
            end
            question = "#{query} #{default_display}"
            return pose(question, default_state)
        end

            private

        def pose(question, default)
            valid_input = false
            valid_choice = nil
            system "clear"
            until valid_input do
                @out.ask_question(question)
                choice = gets.chomp.upcase
                if choice == "Y" || choice == "N" || choice == ""
                    if choice == "Y"
                        valid_choice = true
                        valid_input = true
                    elsif choice == "N"
                        valid_choice = false
                        valid_input = true
                    elsif choice == ""
                        valid_choice = default
                        valid_input = true
                    end
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