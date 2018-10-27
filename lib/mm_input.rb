require_relative 'mm_outputs'

class Input
    attr_reader :user_input, :is_valid, :output_code, :restart_request, :show_help, :show_rules, :err_data, :cmd_run

    def initialize(out=Outputs)
        @out = out
        @show_help = false
        @show_rules = false
    end

    def get_input
        @out.in_prompt
        validate(gets.chomp)
    end

    def is_valid?
        return @is_valid
    end

    def validate(to_validate)
        @err_data = {
            err: false,
            bad_chars: [],
            too_long: [],
            too_short: []
        }
        to_validate = to_validate.gsub(/\s/, "").upcase
        bad_chars = to_validate.scan(/[^RGYBMC]/)
        if /[\/]\w/ === to_validate
            @cmd_run = to_validate.tr('/', '').upcase
        else
            check_for_valid_choices(bad_chars)
            check_too_long(to_validate)
            check_too_short(to_validate)
        end
        err_handle(to_validate, @cmd_run)
    end

    def check_for_valid_choices(bad_chars)
        unless bad_chars == []
            if bad_chars.uniq.length == 1
                @err_data[:bad_chars] = [true, "\"#{bad_chars.uniq.join("")}\" is not one of the six vaild choices..."]
            else
                @err_data[:bad_chars] = [true, "\"#{bad_chars.uniq.join(", ")}\" are not any of the six vaild choices..."]
            end
            @err_data[:err] = true
        end
    end

    def check_too_long(to_validate)
        if to_validate.length > 4
            @err_data[:too_long] = [true, "Your input contained #{to_validate.length - 4 } too many characters..."]
            @err_data[:err] = true
        end
    end

    def check_too_short(to_validate)
        if to_validate.length < 4
            @err_data[:too_short] = [true, "Your input contained #{4 - to_validate.length} too few charactrs..."]
            @err_data[:err] = true
        end
    end

    def err_handle(input, cmd)
        unless @err_data[:err] || cmd != nil
            @is_valid = true
            @user_input = input.split(//)
        else
            return err_data
        end
    end
end