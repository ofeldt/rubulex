module Rubulex
  class RegexpParser
    def initialize(regex, options, data)
      self.options = options
      self.regex = regex
      self.data = data
      @match_result = nil
      @match_groups = nil

      parse
    end

    def data=(data)
      @data = data[0..4095] || "" 
    end

    def regex=(regex)
      @regex = Regexp.new(/#{regex}/, @options)
    rescue RegexpError => error
      @regex = //
    end

    def options=(options)
      options = options.match(/(?<options>(?<option>[imxo]){,4})/)[:options].split(//)

      options_lookup_table = Hash.new(0) 
      options_lookup_table["i"] = Regexp::IGNORECASE
      options_lookup_table["m"] = Regexp::MULTILINE
      options_lookup_table["x"] = Regexp::EXTENDED

      @options = options.inject(0) do |result, option| 
        result | options_lookup_table[option]
      end
    end

    def parse
      @data.match(@regex) do |match|
        colors = ->() do
          (@colors ||= [:red, :green, :darkorange, :blue].cycle).next
        end
        @match_result = @data.dup
        @match_result.gsub!(@regex) do |match|
          "<span class='#{colors.call}'>#{match}</span>"
        end
        @match_result.gsub!(/\n/,"<br />")

        @match_groups = if match.names.length > 0
          match.names.each_with_object([]) { |match_name, memo|
            memo << { match_name.to_sym => match[match_name] }
          }
        elsif match.length > 0
          match.to_a[1..-1].map.with_index { |match, index| { index => match } }
        end
      end
    end

    def result
      {
        match_result: @match_result,
        match_groups: @match_groups.join("<br />")
      }
    end
  end

end
