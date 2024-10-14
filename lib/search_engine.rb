class SearchEngine
  def self.find_duplicates(data, field)
    entry_index = Hash.new { |hash, key| hash[key] = { entries: [], count: 0 } }

    data.each do |entry|
      next unless entry.key?(field)

      entry_index[entry[field]][:count] += 1
      entry_index[entry[field]][:entries].push(entry)
    end

    entry_index.select { |_key, entry| entry[:count] > 1 }
  end

  def self.partial_text_search(data, field, query)
    data.select { |entry| entry.key?(field) && entry[field].to_s.downcase.include?(query.downcase) }
  end
end
