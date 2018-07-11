require_relative 'mm_outputs'

class Input
    attr_reader :user_input, :is_valid, :output_code, :restart_request, :show_help, :show_rules, :err_data, :cmd_run

    def initialize(out = Outputs)
        @out = Outputs
        @show_help = false
        @show_rules = false
        @out.in_prompt
        validate(gets.chomp)
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
            unless bad_chars == []
                if bad_chars.uniq.length == 1
                    @err_data[:bad_chars] = [true, "\"#{bad_chars.uniq.join("")}\" is not one of the six vaild choices..."]
                else
                    @err_data[:bad_chars] = [true, "\"#{bad_chars.uniq.join(", ")}\" are not any of the six vaild choices..."]
                end
                @err_data[:err] = true
            end
            if to_validate.length > 4
                @err_data[:too_long] = [true, "Your input contained #{to_validate.length - 4 } too many characters..."]
                @err_data[:err] = true
            end
            if to_validate.length < 4
                @err_data[:too_short] = [true, "Your input contained #{4 - to_validate.length} too few charactrs..."]
                @err_data[:err] = true
            end
        end
        err_handle(to_validate, @cmd_run)
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