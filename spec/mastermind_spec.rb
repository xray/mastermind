require 'mastermind'

RSpec.describe Options, "generate options" do
    opt = Options.new

    it "given the generated list of options 1296 unique options are returned" do 
		expect(opt.get.length).to eq 1296  
	end
end

RSpec.describe Code, "when comparing" do

  it "the code 'r y b g' to the code 'r b y g' the result should be two red pins and two white pins" do
    expect(Code.new("r y b g").compare(Code.new("r b y g").value)).to eq [2, 2]
  end

  it "the code 'r y y y' to the code 'r g y b' the result should be two red pins and zero white pins" do
    expect(Code.new("r y y y").compare(Code.new("r g y b").value)).to eq [2, 0]
  end

  it "the code 'r y b b' to the code 'r b y y' the result should be one red pin and two white pins" do
    expect(Code.new("r y b b").compare(Code.new("r b y y").value)).to eq [1, 2]
  end

  it "the code 'g g r r' to the code 'r r g g' the result should be zero red pins and four white pins" do
    expect(Code.new("g g r r").compare(Code.new("r r g g").value)).to eq [0, 4]
  end

  it "the code 'g g g r' to the code 'g g g b' the result should be three red pins and zero white pins" do
    expect(Code.new("g g g r").compare(Code.new("g g g b").value)).to eq [3, 0]
  end
end


