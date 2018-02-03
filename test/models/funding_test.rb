require 'test_helper'

describe Funding do
  describe :to_csv do
    before do
      @csv_lines = Funding.all.to_csv.split("\n")
    end

    it 'has a header line' do
      @csv_lines[0].must_match /date.*amount/
    end

    it 'outputs the records' do
      @csv_lines[1].must_match /1,true/
      end
  end
end
