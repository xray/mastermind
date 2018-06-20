class String
    def black;          "\e[30m#{self}\e[0m" end
    def red;            "\e[31m#{self}\e[0m" end
    def green;          "\e[32m#{self}\e[0m" end
    def brown;          "\e[33m#{self}\e[0m" end
    def blue;           "\e[34m#{self}\e[0m" end
    def magenta;        "\e[35m#{self}\e[0m" end
    def cyan;           "\e[36m#{self}\e[0m" end
    def gray;           "\e[37m#{self}\e[0m" end
    
    def bg_black;       "\e[40m#{self}\e[0m" end
    def bg_red;         "\e[41m#{self}\e[0m" end
    def bg_green;       "\e[42m#{self}\e[0m" end
    def bg_brown;       "\e[43m#{self}\e[0m" end
    def bg_blue;        "\e[44m#{self}\e[0m" end
    def bg_magenta;     "\e[45m#{self}\e[0m" end
    def bg_cyan;        "\e[46m#{self}\e[0m" end
    def bg_gray;        "\e[47m#{self}\e[0m" end
end

class Mastermind
    @guess_count

    def initialize
        @guess_count = 10

    end
    def get_input(display = false)
        user_input = nil
        first_try = true

        until /[rgybmc]\s[rgybmc]\s[rgybmc]\s[rgybmc]/ === user_input || user_input == "/quit" || user_input == "/restart"
            unless first_try
                puts "Bad Input"
                puts ""
            end
            puts "Please enter a set of colors..."
            puts ""
            puts "the format is:"
            puts "x x x x"
            puts ""
            user_input = gets.chomp
            puts ""
            first_try = false
        end
        if user_input == "/quit"
            puts "you quit"
        elsif user_input == "/restart"
            puts "New game"
        else
            this_guess = Code.new(user_input)
            @guess_count -= 1
            puts "Guesses Remaining: " + @guess_count.to_s
            this_guess
        end
    end

    def get_remaining
        @guess_count
    end
end

class Options
    @@options_list

    def initialize
        all_options = []
        starting_point = { fourth: 1, third: 1, second: 1, first: 1 }
        until starting_point == { fourth: 6, third: 6, second: 6, first: 6 }
            all_options << starting_point.values
            starting_point[:first] += 1
            starting_point.keys.reverse.map.with_index do |pos, i|
                if starting_point[pos] > 6
                    starting_point[pos] = 1
                    nextval = starting_point.keys.reverse[i + 1]
                    starting_point[nextval] += 1
                end
            end
        end
        all_options << { fourth: 6, third: 6, second: 6, first: 6 }.values
        @@options_list = all_options
    end

    def get
        @@options_list
    end
end

class Code 
    @code_value
    @code_matched

    def initialize(code_data = false)
        if code_data
            split_code = code_data.split(" ")
            converted_code = []
            split_code.map do |v|
                conversion_container = {
                    1 => 'r',
                    2 => 'g',
                    3 => 'y',
                    4 => 'b',
                    5 => 'm',
                    6 => 'c'
                }
                converted_code << conversion_container.key(v).to_i
            end
            @code_value = converted_code
        else
            temp_options = Options.new
            @code_value = temp_options.get[rand(1296)]
        end
    end

    def compare(compare_code)
        red_pins = 0
        white_pins = 0

        editable_code = @code_value.clone

        if @code_value == compare_code
            @code_matched = true
            puts "You Win!"
            return true
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
            puts "Red Pins: " + red_pins.to_s
            puts "White Pins: " + white_pins.to_s
            return [red_pins, white_pins]
        end
    end

    def value(player_ver = false)
        if player_ver
            player_readable = ""
            @code_value.map do |v|
                conversion_container = {
                    'r' => 1,
                    'g' => 2,
                    'y' => 3,
                    'b' => 4,
                    'm' => 5,
                    'c' => 6
                }
                player_readable = player_readable + conversion_container.key(v).to_s + " "
            end
            player_readable
        else
            @code_value
        end
    end

    def matched
        @code_matched
    end
end

mm = Mastermind.new
comp_code = Code.new()
until comp_code.matched == true
    if mm.get_remaining == 5
        system "clear" or system "cls"
        puts "The code was: " + comp_code.value(true).to_s
        puts "Game Over!"
        break
    else
        comp_code.compare(mm.get_input.value)
    end
end