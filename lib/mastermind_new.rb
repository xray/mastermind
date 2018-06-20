class Game

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
end

class Input
    attr_reader :user_input, :input_valid, :output_code

    def initialize
        @input_valid = false
        @user_inuput = gets.chomp
    end

    def validate(check_me = @user_input)
        if /[\/]\w/ === check_me
            commands(check_me.tr('/', ''))
        elsif /[rgybmc]\s[rgybmc]\s[rgybmc]\s[rgybmc]/ === check_me
            # gotta change this to use Code.convert
            @user_input = check_me.split(" ")
        end
    end

    def commands(command)

    end
end

class Code
    def initialize(new_code)
        @value = new_code
    end

    def convert(input = @value)
        converted_code = []
        conversion_container = {
            1 => 'r',
            2 => 'g',
            3 => 'y',
            4 => 'b',
            5 => 'm',
            6 => 'c'
        }
        input.map do |v|
            if /[1-9]/ === input[0].to_s
                converted_code << conversion_container.invert.key(v).to_s
            elsif /[rgybmc]/ === input[0]
                converted_code << conversion_container.key(v).to_i
            end
        end
        return converted_code
    end
end