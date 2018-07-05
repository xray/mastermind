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

    def input_err(err_info)
        err_info.each do |key, value|
            unless key == :err
                if value[0] == true
                    puts value[1]
                end
            end
        end
    end
end