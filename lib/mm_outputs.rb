class Outputs
    class << self
        def old_guesses(guesses_list, color = true)
            puts "╭───────────────────────────╮"
            puts "│ Previous Guesses          │"
            puts "┝━━━┯━━━━━━━━━┯━━━━━┯━━━━━━━┥"
            puts "│ # │  Guess  │ Red │ White │"
            puts "├───┼─────────┼─────┼───────┤"
            guesses_list.each do |list|
                g_info = list[1]
                g_number = list[0].to_s
                if color then g_guess = g_info[:guess_color] else g_guess = g_info[:guess] end
                g_pins_red = g_info[:pins][:red].to_s
                g_pins_white = g_info[:pins][:white].to_s
                new_string = "│ #{g_number} │ #{g_guess} │  #{g_pins_red}  │   #{g_pins_white}   │"
                puts new_string
            end
            puts "╰───┴─────────┴─────┴───────╯"
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
            puts ""
        end

        def game_status(game_state, clear = true)
            if clear
                system "clear"
            end
            if !game_state.state[:previous_guesses].empty?
                old_guesses(game_state.state[:previous_guesses])
            end
            remaining_guesses(game_state.state[:remaining_guesses])
        end

        def welcome
            system "clear"
            puts "╭────────────────────────╮"
            puts "│ Welcome to Mastermind! │"
            puts "├────────────────────────┴───────────────────────────╮"
            puts "│ Type \"/rules\" to view the rules or \"/help\" to view │"
            puts "│ any available commands!                            │"
            puts "╰────────────────────────────────────────────────────╯"
            puts "======================================================"
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

        def win(game_state)
            system "clear"
            puts "╔═══════════════════════════════════════════════════════════════════════════════╗"
            puts "║  ____    ____  ______    __    __     ____    __    ____  __  .__   __.  __   ║"
            puts "║  \\   \\  /   / /  __  \\  |  |  |  |    \\   \\  /  \\  /   / |  | |  \\ |  | |  |  ║"
            puts "║   \\   \\/   / |  |  |  | |  |  |  |     \\   \\/    \\/   /  |  | |   \\|  | |  |  ║"
            puts "║    \\_    _/  |  |  |  | |  |  |  |      \\            /   |  | |  . `  | |  |  ║"
            puts "║      |  |    |  `--'  | |  `--'  |       \\    /\\    /    |  | |  |\\   | |__|  ║"
            puts "║      |__|     \\______/   \\______/         \\__/  \\__/     |__| |__| \\__| (__)  ║"
            puts "║                                                                               ║"
            puts "╚═══════════════════════════════════════════════════════════════════════════════╝"
            puts ("You won in only #{(10 - game_state.state[:remaining_guesses]).to_s} guesses!")
        end

        def available_cmds
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
            puts ""
        end

        def input_err(err_info, clear_line = false)
            if clear_line then system "clear" end
            err_info.each do |key, value|
                unless key == :err
                    if value[0] == true
                        puts value[1]
                    end
                end
            end
            puts ""
            puts "Please try again."
            puts ""
        end

        def continue_prompt
            puts "Press enter to continue..."
            gets.chomp
        end

        def ask_question(question)
            puts question
        end

        def confirm_cancel(message)
            puts "Ok we won't #{message}!"
            puts ""
        end

        def bad_cmd(cmd)
            puts "========================================="
            puts "The command \"#{cmd.downcase}\" is not valid."
            puts "Type \"/help\" for a list of commands."
            puts "========================================="
            puts ""
        end

        def in_prompt
            puts "Your color choices are R, G, Y, B, M, and C."
            puts 'Please enter a code or command...'
            print "━━━⫸ "
        end

        def show_code(game_state)
            puts "The code was: " + game_state.state[:code].convert.join(' ')
        end

        def lost_game
            puts "You ran out of guesses, better luck next time!"
        end
    end
end