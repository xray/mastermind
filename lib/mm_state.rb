require_relative 'mm_gen_list'
require_relative 'mm_code'

class State
    DEFAULT_TRYS = 10

    def initialize(items = {}, list = GeneratedList, code = Code)
        @st_list = list
        @st_code = code
        @combos_list = @st_list.new
        @game_code = @st_code.new(@combos_list.random_code)
        @first_launch = true || items[:first_launch]
        @remaining_guesses = DEFAULT_TRYS || items[:rem_guesses]
        @previous_guesses = {} || items[:prev_guesses]
    end

    def update(info)
        @first_launch = false
        @remaining_guesses -= 1
        to_update = 10 - @remaining_guesses
        if info[:pins] == true
            info[:pins] = "Matched"
        end
        @previous_guesses[to_update] = {
            guess: info[:guess].join(" "),
            guess_color: info[:guess_color].join(" "),
            pins: {
                red: info[:pins][0],
                white: info[:pins][1]
            }
        }
    end

    def state()
        return {
            code: @game_code,
            remaining_guesses: @remaining_guesses,
            previous_guesses: @previous_guesses,
            first_launch: @first_launch
        }
    end

    def reset(new_list = @st_list.new, new_code = @st_code.new(new_list.random_code))
        @combos_list = new_list
        @game_code = new_code
        @remaining_guesses = DEFAULT_TRYS
        @previous_guesses = {}
        @first_launch = false
    end
end