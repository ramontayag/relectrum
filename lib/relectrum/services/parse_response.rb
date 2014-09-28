module Relectrum
  class ParseResponse

    def self.execute(response, rep=0, set=0)
      total_lines = response.lines.count
      return self.execute(response, 0, set + 1) if rep > total_lines - set - 1
      to_line = total_lines - set - 1
      from_line = to_line - rep
      chosen_lines = response.lines[from_line..to_line]
      json = chosen_lines.join
      parse(json)
    rescue JSON::ParserError
      self.execute(response, rep+1, set)
    end

    private

    def self.parse(json)
      parsed_response = JSON.parse(json)

      if parsed_response.kind_of?(Array)
        parsed_response.map(&:with_indifferent_access)
      else
        parsed_response.with_indifferent_access
      end
    end

  end
end
