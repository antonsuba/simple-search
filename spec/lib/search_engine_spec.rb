require 'search_engine'

RSpec.describe SearchEngine do
  let(:entry_1) { { email: 'entry1@email.com', full_name: 'Entry_1' } }
  let(:entry_2) { { email: 'entry2@email.com', full_name: 'Entry_2' } }
  let(:entry_3) { { email: 'entry3@email.com', full_name: 'Random_3', last_name: 'Random_3_Last_Name'} }
  let(:entry_1_duplicate) { { email: 'entry1@email.com', full_name: 'Another_Entry_1' } }

  let(:data) do
    [
      entry_1,
      entry_2,
      entry_3,
      entry_1_duplicate
    ]
  end

  describe '.find_duplicates' do
    it 'should return entries with duplicates from a specific field' do
      expect(SearchEngine.find_duplicates(data, :email)).to eq({
        entry_1[:email] => { entries: [entry_1, entry_1_duplicate], count: 2 }
    })
    end
  end

  describe '.partial_text_search' do
    it 'should return entries that partially match the given substring' do
      expect(SearchEngine.partial_text_search(data, :full_name, 'try')).to eq([
        entry_1,
        entry_2,
        entry_1_duplicate
      ])
    end

    it 'should only return entries that has the given field' do
      expect(SearchEngine.partial_text_search(data, :last_name, 'ran')).to eq([
        entry_3
      ])
    end
  end
end
