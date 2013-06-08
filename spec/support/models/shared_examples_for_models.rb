module SharedExamplesForModels
  shared_examples_for 'a class with construtor arity' do |count|
    if count > 0
      it "raises an error unless #{count} #{count == 1? 'parameter is' : 'parameters are'} supplied" do
        expect {
          described_class.new
        }.to raise_error(ArgumentError, "wrong number of arguments (0 for #{count})")
      end
    else
      it "raises an error parameters are supplied" do
        expect {
          described_class.new('foo')
        }.to raise_error(ArgumentError, "wrong number of arguments(1 for 0)")
      end
    end
  end
end

