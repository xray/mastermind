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