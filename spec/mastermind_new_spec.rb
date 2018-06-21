require 'mastermind_new'

RSpec.describe Mastermind, 'in terms of the' do
    context 'class GeneratedList, given' do
        it 'the list of generated possibile combinations the length should equal 1296' do
            expect(Mastermind::GeneratedList.new.get.length).to eq 1296
        end
    end

    context 'class Code, given' do
        it "the code '1, 2, 5, 3' to convert, it is converted to 'R G M Y'" do
            test_code = Mastermind::Code.new([1, 2, 5, 3])
            expect(test_code.convert).to eq ["R", "G", "M", "Y"]
        end
    
        it "the code 'r g m y' to convert, it is converted to '1, 2, 5, 3'" do
            expect(Mastermind::Code.new(["r", "g", "m", "y"]).value).to eq [1, 2, 5, 3]
        end
    end
end