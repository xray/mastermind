module Mastermind
    def self.play
        previous_guesses = []
        remaining_guesses = 10
        pins_out = []
        gen_list = GeneratedList.new
        game_code = Code.new(gen_list.random_code)
        until game_code.matched do
            system "clear"
            if remaining_guesses == 0
                puts "You ran out of guesses..."
                break
            end
            if previous_guesses != []
                puts "Previous Guesses:"
                previous_guesses.map do |v|
                    puts v.join(' ')
                end
            end
            if pins_out != []
                puts "Red Pins: " + pins_out[0].to_s
                puts "White Pins: " + pins_out[1].to_s
            end
            puts remaining_guesses.to_s + " Guesses Remaining..."
            puts "Your color choices are R, G, Y, B, M, and C."
            user_in = Input.new
            until user_in.is_valid do
                user_in = Input.new
            end
            current_code = Code.new(user_in.user_input)
            previous_guesses << current_code.convert
            pins_out = game_code.compare(current_code.value)
            remaining_guesses -= 1
        end
        puts "The code was: " + game_code.convert.join(' ')
    end

    class GeneratedList
        attr_reader :get
    
        def initialize
            @get = []
            starting_point = { fourth: 1, third: 1, second: 1, first: 1 }
            until starting_point == { fourth: 6, third: 6, second: 6, first: 6 }
                @get << starting_point.values
                starting_point[:first] += 1
                starting_point.keys.reverse.map.with_index do |pos, i|
                    if starting_point[pos] > 6
                        starting_point[pos] = 1
                        nextval = starting_point.keys.reverse[i + 1]
                        starting_point[nextval] += 1
                    end
                end
            end
            @get << { fourth: 6, third: 6, second: 6, first: 6 }.values
        end
    
        def random_code
            @get[rand(1296)]
        end
    end
    
    class Input
        attr_reader :user_input, :is_valid, :output_code
    
        def initialize
            puts 'Please enter a code or command...'
            print ">>> "
            validate(gets.chomp)
        end
    
        def validate(check_me)
            if /[\/]\w/ === check_me
                commands(check_me.tr('/', '').upcase)
            elsif /\A[rgybmcRGYBMC][rgybmcRGYBMC][rgybmcRGYBMC][rgybmcRGYBMC]\z/ === check_me
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
            if command == 'HELP'
                puts 'Help placeholder...'
            elsif command == 'RESTART'
                puts 'Restart placeholder...'
            elsif command == 'QUIT'
                puts 'Quit placeholder...'
            else
                puts 'Bad Command'
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
            converted_code = []
            conversion_container = {
                1 => 'R',
                2 => 'G',
                3 => 'Y',
                4 => 'B',
                5 => 'M',
                6 => 'C'
            }
            input.map do |v|
                if /[1-9]/ === input[0].to_s
                    converted_code << conversion_container.invert.key(v).to_s.upcase
                elsif /[rgybmcRGYBMC]/ === input[0]
                    converted_code << conversion_container.key(v).to_i
                end
            end
            return converted_code
        end
    
        def compare(compare_code)
            red_pins = 0
            white_pins = 0
    
            editable_code = @value.clone
    
            if @value == compare_code
                puts "YOU WIN!"
                @matched = true
            else
                compare_code.collect!.with_index do |v, i|
                    if editable_code[i] == v
                        editable_code[i] = 'x'
                        red_pins += 1
                        'x'
                    else
                        v
                    end
                end
                compare_code.map.with_index do |v, i|
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
end

Mastermind.play