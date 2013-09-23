module Rubulex
  class RegexpParser
    Struct.new("MatchRelation", :name, :text)

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
      @regex = Regexp.new("#{regex}", @options)
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
        @match_result = render_match_result(@data.dup)
        @match_groups = render_match_groups(@data.dup)
      end
    end

    def render_match_result(data)
      colors = ->() do
        (@colors ||= [:red, :green, :darkorange, :blue].cycle).next
      end
      data.gsub!(@regex) do |match|
        "<span class='#{colors.call}'>#{match}</span>"
      end

      data.gsub(/\n/,"<br />")
    end

    def render_match_groups(data)
      match_groups = []

      data.gsub(@regex) do |match_text|
        sub_match = match_text.match(@regex)
        match_group_count = sub_match.length - 1
        if match_group_count > 0
          sub_match_set = []

          match_group_count.times do |index|
            key = sub_match.names[index] || index + 1
            match_text = sub_match[key]

            sub_match_set << Struct::MatchRelation.new(key, match_text)
          end

          match_groups << sub_match_set
        end
      end

      match_groups.map.with_index { |sub_set, index| 
        group = "<dl><dt>Match #{index + 1}</dt>"
        group << sub_set.map { |match|
          "<dd>#{match.name}: #{match.text}</dd>"
        }.join 
        group << "</dl>"
      }.join("<br />")
    end

    def result
      {
        match_result: @match_result,
        match_groups: @match_groups
      }
    end
  end

end
