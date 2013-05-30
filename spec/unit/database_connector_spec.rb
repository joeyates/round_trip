require 'spec_helper'

describe RoundTrip::DatabaseConnector do
  let(:database_path) { 'foo' }
  let(:database_pathname) { File.join(database_path, 'bar.sqlite3') }
  let(:db_config) do
    {
      :adapter => 'sqlite3',
      :database => database_pathname,
    }
  end

  before do
    File.stubs(:writable?).with(database_path).returns(true)
    File.stubs(:exist?).with(database_pathname).returns(true)
    File.stubs(:writable?).with(database_pathname).returns(true)
    ActiveRecord::Base.stubs(:establish_connection).with(db_config)
  end

  subject { RoundTrip::DatabaseConnector.new(database_pathname) }

  describe '#connect' do
    context 'permissions' do
      it 'checks the database path is writable' do
        subject.connect
        expect(File).to have_received(:writable?).with(database_path)
      end

      it 'throws an error unless the database path is writable' do
        File.stubs(:writable?).with(database_path).returns(false)

        expect {
          subject.connect
        }.to raise_error(Errno::EACCES, "Permission denied - #{database_path}")
      end

      it 'checks if the database file exists' do
        subject.connect
        expect(File).to have_received(:exist?).with(database_pathname)
      end

      it 'checks the database is writable if it exists' do
        subject.connect
        expect(File).to have_received(:writable?).with(database_pathname)
      end

      it "doesn't check if the database is writable if it doesn't exist" do
        File.stubs(:exist?).with(database_pathname).returns(false)
        subject.connect
        expect(File).to have_received(:writable?).with(database_pathname).never
      end

      it 'throws an error if the database file exists, but is not writable' do
        File.stubs(:writable?).with(database_pathname).returns(false)

        expect {
          subject.connect
        }.to raise_error(Errno::EACCES, "Permission denied - #{database_pathname}")
      end
    end

    it 'opens the database' do
      subject.connect
      expect(ActiveRecord::Base).to have_received(:establish_connection).with(db_config)
    end
  end
end

