require_relative 'mm_state'
require_relative 'mm_outputs'
require_relative 'mm_choice'
require_relative 'mm_input'
require_relative 'mm_code'
require_relative 'mm_commands'

DEFAULT = {
    state: State,
    game_in: Input,
    game_out: Outputs,
    choice: Choice,
    code: Code,
    commands: Commands
}

class Game
    def initialize(options = {})
        options = DEFAULT.merge(options)
        @status = options[:state].new
        @in = options[:game_in]
        @out = options[:game_out]
        @choice = options[:choice]
        @code = options[:code]
        @cmds = options[:commands]
        @input_code = nil
        @stop_game = false
        @game_complete = false
        play
    end

    def play
        until @stop_game do
            @game_complete = false
            gameplay_loop
        end
        exit
    end

    def gameplay_loop
        until @game_complete do
            welcome_user
            display_game_status
            set_input_code(input_loop)
            update_game_state
            check_code_match
            check_remaining_guesses
        end
    end

    def welcome_user
        if @status.state[:first_launch]
            @out.welcome
        end
    end

    def input_loop
        user_in = @in.new
        until user_in.is_valid? do
            user_in.get_input
            if user_in.cmd_run
                commands = @cmds.new(@status, user_in.cmd_run)
            elsif user_in.err_data[:err]
                display_input_error(user_in)
            end
        end
        return user_in
    end

    def check_code_match
        unless @game_complete
            if @status.state[:code].matched
                @out.win(@status)
                @game_complete = true
                ending_sequence
            end
        end
    end

    def check_remaining_guesses
        unless @game_complete
            if @status.state[:remaining_guesses].zero?
                @game_complete = true
                @out.lost_game
                ending_sequence
            end
        end
    end

    def set_input_code(input_instance)
        @input_code = @code.new(input_instance.user_input)
    end

    def update_game_state(in_code = @input_code)
        @status.update({
            guess: in_code.convert,
            guess_color: in_code.convert_to_color,
            pins: @status.state[:code].compare(in_code.value)
        })
    end

    def display_game_status
        if @status.state[:first_launch]
            @out.game_status(@status, false)
        else
            @out.game_status(@status)
        end
    end

    def display_input_error(input)
        system "clear"
        @out.game_status(@status)
        @out.input_err(input.err_data)
    end

    def ending_sequence
        @out.show_code(@status)
        @out.continue_prompt
        if @choice.create("Would you like to play again?")
            @status.reset
        else
            @stop_game = true
        end
    end
end