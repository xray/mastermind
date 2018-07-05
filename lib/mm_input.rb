HELP = 'HELP'
QUIT = 'QUIT'
EXIT = 'EXIT'
RULES = 'RULES'

class Input
    attr_reader :user_input, :is_valid, :output_code, :restart_request, :show_help, :show_rules, :err_data

    def initialize
        @show_help = false
        @show_rules = false
        puts 'Please enter a code or command...'
        print "---> "
        validate(gets.chomp)
    end

    def validate(to_validate)
        @err_data = {
            err: false,
            bad_chars: [],
            too_long: [],
            too_short: []
        }
        to_validate = to_validate.gsub(/\s/, "").upcase
        bad_chars = to_validate.scan(/[^RGYBMC]/)
        if /[\/]\w/ === to_validate
            commands(to_validate.tr('/', '').upcase)
        end
        unless bad_chars == []
            if bad_chars.uniq.length == 1
                @err_data[:bad_chars] = [true, "\"#{bad_chars.uniq.join("")}\" is not one of the six vaild choices..."]
            else
                @err_data[:bad_chars] = [true, "\"#{bad_chars.uniq.join(", ")}\" are not any of the six vaild choices..."]
            end
            @err_data[:err] = true
        end
        if to_validate.length > 4
            @err_data[:too_long] = [true, "Your input contained #{to_validate.length - 4 } too many characters..."]
            @err_data[:err] = true
        end
        if to_validate.length < 4
            @err_data[:too_short] = [true, "Your input contained #{4 - to_validate.length} too few charactrs..."]
            @err_data[:err] = true
        end
        unless err_data[:err] == true
            @is_valid = true
            @user_input = to_validate.split(//)
        else
            return err_data
        end
    end

    def commands(command)
        if command == HELP
            @show_help = true
        elsif command == 'RESTART'
            @restart_request = true
        elsif command == QUIT || command == EXIT
            system "clear"
            puts "Are sure you want to #{command.downcase}? (Y/n)"
            confirm_quit = gets.chomp.upcase
            if confirm_quit == "" || confirm_quit == "Y"
                system "clear"
                exit
            else
                system "clear"
                puts "Ok, we won't #{command.downcase}."
            end
        elsif command == RULES
            @show_rules = true
        else
            system "clear"
            puts "The command \"#{command.downcase}\" is not valid."
            puts "Type \"/help\" for a list of commands."
            puts "========================================="
        end
    end
end