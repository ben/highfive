require 'test_helper'

describe HighfiveRecord do
  describe :to_csv do
    before do
      mock_users_list
      @csv_lines = HighfiveRecord.all.to_csv.split("\n")
    end

    it 'has a header line' do
      @csv_lines[0].must_match /date.*amount/
    end

    it 'outputs the records' do
      @csv_lines[1].must_match /dunno,\$20/
      end
  end
end
