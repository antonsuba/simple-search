require 'json'
require 'optparse'
require_relative 'search_engine'

class SearchCli
  DEFAULT_DATASET = './data/clients.json'
  DEFAULT_DUPLICATES_FIELD = 'email'
  DEFAULT_SEARCH_FIELD = 'full_name'

  def self.run
    ARGV << '-h' if ARGV.empty?

    options = parse_options
    data = load_data(DEFAULT_DATASET)

    case ARGV.first
    when 'search'
      search(data, options.fetch(:field, DEFAULT_SEARCH_FIELD), options[:query])
    when 'duplicates'
      find_duplicates(data, options.fetch(:field, DEFAULT_DUPLICATES_FIELD))
    else
      $stderr.puts 'Invalid command. Run ./search_cli --help for details.'
      exit 1
    end
  end

  def self.load_data(filename)
    file_content = File.read(filename)
    JSON.parse(file_content)
  end

  def self.parse_options
    options = {}

    parser = OptionParser.new do |opt|
      opt.on('-q value', '--query value', 'Specify the search query.', String) 

      opt.on('-f value', '--field value', 'Specify the field in which to perform the operation.', String)

      opt.on('-h', '--help', 'Show help message.') do |date|
        puts opt
        exit
      end
    end

    begin
      parser.parse!(into: options)
    rescue OptionParser::MissingArgument => e
      $stderr.puts "#{e.message.capitalize}. Run ./search_cli --help for details."
      exit 1
    end

    options
  end

  def self.search(data, field, query)
    search_results = SearchEngine.partial_text_search(data, field, query)

    if search_results.length > 0
      puts "#{search_results.length} matches found:"
      search_results.each { |entry| puts entry }
    else
      puts 'No matches found.'
    end
  end

  def self.find_duplicates(data, field)
    duplicates = SearchEngine.find_duplicates(data, field)

    if duplicates.length > 0
      duplicates.each do |key, val|
        puts "#{val[:count]} entries with #{field}: #{key}"
        puts val[:entries]
        puts "\n"
      end
    else
      puts 'No duplicates found.'
    end
  end
end