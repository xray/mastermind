require 'mastermind_new'

RSpec.describe GeneratedList, "given" do
    it "something about generating the list" do
        expect(GeneratedList.new.get.length).to eq 1296
    end
end

RSpec.describe Code, "given" do

    it "the code '1, 2, 5, 3' to convert, it is converted to 'r g m y'" do
      expect(Code.new([1, 2, 5, 3]).convert).to eq ["r", "g", "m", "y"]
    end

    it "the code 'r g m y' to convert, it is converted to '1, 2, 5, 3'" do
        expect(Code.new(["r", "g", "m", "y"]).convert).to eq [1, 2, 5, 3]
    end

end