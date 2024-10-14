require 'search_cli'

RSpec.describe SearchCli do
  describe '.run' do
    let(:command) { 'search' }

    before do
      stub_const('ARGV', [command])

      allow(SearchCli).to receive(:find_duplicates)
      allow(SearchCli).to receive(:search)
    end

    context 'when search command is used' do
      let(:command) { 'search' }

      it 'should call search' do
        expect(SearchCli).to receive(:search)

        SearchCli.run
      end
    end

    context 'when duplicates command is used' do
      let(:command) { 'duplicates' }

      it 'should call find_duplicates' do
        expect(SearchCli).to receive(:find_duplicates)

        SearchCli.run
      end
    end

    context 'when an invalid command is used' do
      let(:command) { 'invalid_command' }

      it 'should output an error message' do
        expect { SearchCli.run }.to raise_error(SystemExit)
          .and output("Invalid command. Run ./search_cli --help for details.\n").to_stderr
      end
    end
  end

  describe '.load_data' do
    let(:filename) { 'filename.json' }
    let(:file_content) { double }
    let(:parsed_json) { double }

    before do
      allow(File).to receive(:read).with(filename).and_return(file_content)
      allow(JSON).to receive(:parse).with(file_content).and_return(parsed_json)
    end

    it 'should return an array of data entries' do
      expect(SearchCli.load_data(filename)).to eq(parsed_json)
    end
  end

  describe '.parse_options' do
    context 'when query option is used and an argument is provided' do
      before do
        stub_const('ARGV', ['-q', 'test_query'])
      end

      it 'should return the option as part of a hash' do
        expect(SearchCli.parse_options).to eq({ query: 'test_query' })
      end
    end

    context 'when field option is used and an argument is provided' do
      before do
        stub_const('ARGV', ['-f', 'test_field'])
      end

      it 'should return the option as part of a hash' do
        expect(SearchCli.parse_options).to eq({ field: 'test_field' })
      end
    end

    context 'when an argument is missing' do
      before do
        stub_const('ARGV', ['-q'])
      end

      it 'should return the option as part of a hash' do
        expect { SearchCli.parse_options }.to raise_error(SystemExit)
          .and output("Missing argument: -q. Run ./search_cli --help for details.\n").to_stderr
      end
    end
  end

  describe '.search' do
    let(:data) { double }
    let(:field) { 'field' }
    let(:query) { 'query' }

    before do
      allow(SearchEngine).to receive(:partial_text_search).with(data, field, query).and_return(search_results)
    end

    context 'when matches are found' do
      let(:entry_1) { double }
      let(:entry_2) { double }
      let(:search_results) { [entry_1, entry_2] }

      it 'should output the matches' do
        expect { SearchCli.search(data, field, query) }.to output("2 matches found:\n#{entry_1}\n#{entry_2}\n").to_stdout
      end
    end

    context 'when no matches are found' do
      let(:search_results) { {} }

      it 'should output a no duplicates message' do
        expect { SearchCli.search(data, field, query) }.to output("No matches found.\n").to_stdout
      end
    end
  end

  describe '.find_duplicates' do
    let(:data) { double }
    let(:field) { 'field' }

    before do
      allow(SearchEngine).to receive(:find_duplicates).with(data, field).and_return(duplicates)
    end

    context 'when duplicates are found' do
      let(:entries) { double }
      let(:duplicates) { { 'sample_key' => { entries: [entries], count: 2 } } }

      it 'should output the duplicates' do
        expect { SearchCli.find_duplicates(data, field) }.to output("2 entries with field: sample_key\n#{entries}\n\n").to_stdout
      end
    end

    context 'when no duplicates are found' do
      let(:duplicates) { {} }

      it 'should output a no duplicates message' do
        expect { SearchCli.find_duplicates(data, field) }.to output("No duplicates found.\n").to_stdout
      end
    end
  end
end
