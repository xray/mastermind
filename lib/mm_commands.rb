require_relative 'mm_outputs'
require_relative 'mm_choice'

HELP = 'HELP'
RESTART = 'RESTART'
QUIT = 'QUIT'
EXIT = 'EXIT'
RULES = 'RULES'

class Commands
    def initialize(state, cmd, out = Outputs, choice = Choice)
        @out = out
        @state = state
        @command = cmd
        @choice = choice
        interpret(cmd)
    end

        private

    def interpret(cmd = @command)
        case cmd
        when HELP
            system "clear"
            @out.game_status(@state)
            @out.available_cmds
        when RESTART
            restart
        when QUIT, EXIT
            quit(cmd)
        when RULES
            @out.rules
        else
            unknown(cmd)
        end
    end

    def restart
        if @choice.create("Are you sure you'd like to restart?")
            @state.reset
            @out.game_status(@state)
        else
            system "clear"
            @out.game_status(@state)
            @out.confirm_cancel("restart")
        end
    end

    def quit(word)
        if @choice.create("Are you sure you want to #{word.downcase}?")
            system "clear"
            exit
        else
            system "clear"
            @out.game_status(@state)
            @out.confirm_cancel(word.downcase)
        end
    end

    def unknown(word)
        system "clear"
        @out.game_status(@state)
        @out.bad_cmd(word)
    end
end