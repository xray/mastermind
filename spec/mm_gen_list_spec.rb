require 'mm_gen_list'

RSpec.describe GeneratedList, 'in terms of the' do
    context 'class GeneratedList, given' do
        it 'the list of generated possible combinations the lenght should equal 1296' do
            expect(GeneratedList.new.get_list.length).to eq 1296
        end
    end
end