HELP = 'HELP'
QUIT = 'QUIT'
EXIT = 'EXIT'
RULES = 'RULES'

CONVERSION_CONTAINER = {
    1 => 'R',
    2 => 'G',
    3 => 'Y',
    4 => 'B',
    5 => 'M',
    6 => 'C'
}

COLOR_CONTAINER = {
    1 => "\e[91m●\e[0m",
    2 => "\e[92m●\e[0m",
    3 => "\e[93m●\e[0m",
    4 => "\e[94m●\e[0m",
    5 => "\e[95m●\e[0m",
    6 => "\e[96m●\e[0m"
}

module Mastermind
    def self.play(blank_list = [], new_list = GeneratedList.new, new_code = Code.new(new_list.random_code), is_new = true)
        previous_guesses = blank_list
        remaining_guesses = 10
        pins_out = blank_list
        gen_list = new_list
        game_code = new_code
        game_out = Outputs.new
        first_launch = is_new
        until game_code.matched do
            system "clear"
            if first_launch
                game_out.welcome
                first_launch = false
            end
            if remaining_guesses.zero?
                puts "You ran out of guesses..."
                break
            end
            game_out.remaining_guesses(remaining_guesses)
            if !previous_guesses.empty?
                game_out.old_guesses(previous_guesses)
            end
            puts "Your color choices are R, G, Y, B, M, and C."
            user_in = Input.new
            until user_in.is_valid do
                if user_in.restart_request == true
                    restart("Are you sure you'd like to restart?", true)
                elsif user_in.show_help
                    game_out.available_cmds
                elsif user_in.show_rules
                    game_out.rules
                end
                user_in = Input.new
            end
            current_code = Code.new(user_in.user_input)
            pins_out = game_code.compare(current_code.value)
            remaining_guesses -= 1
            previous_guesses << [(10 - remaining_guesses), current_code.convert_to_color, pins_out]
        end
        system "clear"
        if game_code.matched
            game_out.win
            puts ("You won in only #{(10 - remaining_guesses).to_s} guesses!")
        end
        puts "The code was: " + game_code.convert.join(' ')
        restart("Would you like to play again?", false)
    end

    def self.restart(string, cancel)
        puts "#{string} (Y/n)"
        confirm_restart = gets.chomp.upcase
        if confirm_restart == "" || confirm_restart == "Y"
            system "clear"
            new_list = GeneratedList.new
            new_code = Code.new(new_list.random_code)
            play([], new_list, new_code, false)
        elsif cancel == true
            return "Cancelled"
        else 
            system "clear"
            exit
        end
    end

    class GeneratedList
        attr_reader :get_list
    
        def initialize
            @get_list = []
            generate_list
        end

        def generate_list
            starting_point = { fourth: 1, third: 1, second: 1, first: 1 }
            until starting_point == { fourth: 6, third: 6, second: 6, first: 6 }
                @get_list << starting_point.values
                starting_point[:first] += 1
                starting_point.keys.reverse.map.with_index do |pos, i|
                    if starting_point[pos] > 6
                        starting_point[pos] = 1
                        nextval = starting_point.keys.reverse[i + 1]
                        starting_point[nextval] += 1
                    end
                end
            end
            @get_list << { fourth: 6, third: 6, second: 6, first: 6 }.values
        end
    
        def random_code
            @get_list[rand(1296)]
        end
    end
    
    class Input
        attr_reader :user_input, :is_valid, :output_code, :restart_request, :show_help, :show_rules
    
        def initialize
            @show_help = false
            @show_rules = false
            puts 'Please enter a code or command...'
            print "---> "
            validate(gets.chomp)
        end
    
        def validate(check_me)
            if /[\/]\w/ === check_me
                commands(check_me.tr('/', '').upcase)
            elsif /\A[rgybmcRGYBMC]{4}\z/ === check_me
                @user_input = check_me.split(//)
                @is_valid = true
            elsif /\A[rgybmcRGYBMC]\s[rgybmcRGYBMC]\s[rgybmcRGYBMC]\s[rgybmcRGYBMC]\z/ === check_me
                @user_input = check_me.split(' ')
                @is_valid = true
            else
                puts "Bad Input, make sure the code you enter follows the guidelines."
                @is_valid = false
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
    
    class Code
        attr_reader :value, :matched
    
        def initialize(new_code)
            if /[rgybmcRGYBMC]/ === new_code[0]
                new_code = new_code.join.upcase.split(//)
                @value = convert(new_code)
            else
                @value = new_code
            end
        end
    
        def convert(input = @value)
            input.map do |v|
                if v.to_i.positive?
                    CONVERSION_CONTAINER[v.to_i]
                else
                    CONVERSION_CONTAINER.key(v)
                end
            end
        end

        def convert_to_color(input = @value)
            input.map do |v|
                COLOR_CONTAINER[v.to_i]
            end
        end
    
        def compare(compare_code)
            red_pins = 0
            white_pins = 0
    
            editable_code = @value.clone
    
            if @value == compare_code
                @matched = true
            else
                edited_code = compare_code.collect.with_index do |v, i|
                    if editable_code[i] == v
                        editable_code[i] = 'x'
                        red_pins += 1
                        'x'
                    else
                        v
                    end
                end
                edited_code.map.with_index do |v, i|
                    if v.is_a? Numeric
                        if editable_code.include?(v)
                            editable_code[editable_code.find_index(v)] = 'x'
                            white_pins += 1
                        end
                    end
                end
                return [red_pins, white_pins]
            end
        end
    end

    class Outputs
        def welcome
            puts "╭────────────────────────╮"
            puts "│ Welcome to Mastermind! │"
            puts "├────────────────────────┴───────────────────────────╮"
            puts "│ Type \"/rules\" to view the rules or \"/help\" to view │"
            puts "│ any available commands!                            │"
            puts "╰────────────────────────────────────────────────────╯"
            puts "======================================================"

        end

        def old_guesses(guesses_list)
            puts "╭───────────────────────────╮"
            puts "│ Previous Guesses          │"
            puts "┝━━━┯━━━━━━━━━┯━━━━━┯━━━━━━━┥"
            puts "│ # │  Guess  │ Red │ White │"
            puts "├───┼─────────┼─────┼───────┤"
            guesses_list.each do |v|
                new_string = "│ " + v[0].to_s + " │ " + v[1].join(" ") + " │  " + v[2][0].to_s + "  │   " + v[2][1].to_s + "   │"
                puts new_string
            end
            puts "╰───┴─────────┴─────┴───────╯"
        end

        def rules
            system "clear"
            puts "╭───────╮"
            puts "│ Rules │"
            puts "├───────┴─────────────────────────────────────────────────────────╮"
            puts "│ Mastermind is a strategical guessing game. At the beginning of  │"
            puts "│ the game a code will be generated that you need to guess. Each  │"
            puts "│ generated code will be four colors long and can consist of any  │"
            puts "│ of the six available colors (red, green, yellow, blue, magenta, │"
            puts "│ and cyan). The generated code CAN contain duplicate colors. You │"
            puts "│ must crack this code within ten guesses or you will lose. After │"
            puts "│ each guess you will be given a response of white and red pins.  │"
            puts "│ A white pin indicates that your guess contains a correct color  │"
            puts "│ that is in the wrong position and a red pin indicates that your │"
            puts "│ guess has a correct color that is also in the correct position. │"
            puts "╰─────────────────────────────────────────────────────────────────╯"
        end

        def win
            puts "╔═══════════════════════════════════════════════════════════════════════════════╗"
            puts "║  ____    ____  ______    __    __     ____    __    ____  __  .__   __.  __   ║"
            puts "║  \\   \\  /   / /  __  \\  |  |  |  |    \\   \\  /  \\  /   / |  | |  \\ |  | |  |  ║"
            puts "║   \\   \\/   / |  |  |  | |  |  |  |     \\   \\/    \\/   /  |  | |   \\|  | |  |  ║"
            puts "║    \\_    _/  |  |  |  | |  |  |  |      \\            /   |  | |  . `  | |  |  ║"
            puts "║      |  |    |  `--'  | |  `--'  |       \\    /\\    /    |  | |  |\\   | |__|  ║"
            puts "║      |__|     \\______/   \\______/         \\__/  \\__/     |__| |__| \\__| (__)  ║"
            puts "║                                                                               ║"
            puts "╚═══════════════════════════════════════════════════════════════════════════════╝"
        end

        def remaining_guesses(count)
            line_chars = "─────────────────────"
            plural = "es"
            if count == 10
                line_chars = "──────────────────────"
            elsif count == 1
                plural = ""
                line_chars = "───────────────────"
            end
            puts "╭#{line_chars}╮"
            puts "│ #{count.to_s} Guess#{plural} Remaining │"
            puts "╰#{line_chars}╯"
        end

        def available_cmds
            system "clear"
            puts "╭─────────────────────────────────╮"
            puts "│ Available Commands              │"
            puts "┝━━━━━━━━━━┯━━━━━━━━━━━━━━━━━━━━━━┥"
            puts "│ Command  │ Function             │"
            puts "├──────────┼──────────────────────┤"
            puts "│ /restart │ Restarts the game.   │"
            puts "├──────────┼──────────────────────┤"
            puts "│ /quit    │ Quits the game.      │"
            puts "├──────────┼──────────────────────┤"
            puts "│ /rules   │ Displays the rules.  │"
            puts "├──────────┼──────────────────────┤"
            puts "│ /help    │ Brings up this page. │"
            puts "╰──────────┴──────────────────────╯"
        end
    end
end

Mastermind.play