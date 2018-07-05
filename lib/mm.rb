require_relative 'mm_code'
require_relative 'mm_outputs'
require_relative 'mm_input'
require_relative 'mm_gen_list'

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
                elsif user_in.err_data[:err] == true
                    system "clear"
                    game_out.remaining_guesses(remaining_guesses)
                    puts ""
                    game_out.input_err(user_in.err_data)
                    puts ""
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
end

Mastermind.play