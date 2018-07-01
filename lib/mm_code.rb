CONVERSION_CONTAINER = {
    1 => 'R',
    2 => 'G',
    3 => 'Y',
    4 => 'B',
    5 => 'M',
    6 => 'C'
}

COLOR_CONTAINER = {
    1 => "\e[91m●\e[0m",
    2 => "\e[92m●\e[0m",
    3 => "\e[93m●\e[0m",
    4 => "\e[94m●\e[0m",
    5 => "\e[95m●\e[0m",
    6 => "\e[96m●\e[0m"
}

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
        input.map do |v|
            if v.to_i.positive?
                CONVERSION_CONTAINER[v.to_i]
            else
                CONVERSION_CONTAINER.key(v)
            end
        end
    end

    def convert_to_color(input = @value)
        input.map do |v|
            COLOR_CONTAINER[v.to_i]
        end
    end

    def compare(compare_code)
        red_pins = 0
        white_pins = 0

        editable_code = @value.clone

        if @value == compare_code
            puts "YOU WIN!"
            @matched = true
        else
            edited_code = compare_code.collect.with_index do |v, i|
                if editable_code[i] == v
                    editable_code[i] = 'x'
                    red_pins += 1
                    'x'
                else
                    v
                end
            end
            edited_code.map.with_index do |v, i|
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

class CodeNew
    attr_reader :value
    def initialize(new_code)

    end

    def sanitize(code_input)
        len_code = "4"
        if code_input.is_a? Code

        elsif code_input.is_a? String
            good_chars = code_input.upcase.gsub(/[^RGBYMC123456]/, "")
            if (good_chars.gsub(/\d/, "").length || good_chars.gsub(/[RGBYMC]/, "").length) >= len_code
                if good_chars.gsub(/\d/, "").length >= good_chars.gsub(/[RGBYMC]/, "").length
                    good_chars.gsub()
            else
            end

        elsif code_input.is_a? Hash

        elsif code_input.is_a? Array

        else

        end
    end
end