require 'net/https'
require 'nokogiri'
require 'yaml'

# http://www.redmine.org/projects/redmine/wiki/Rest_api

describe 'Redmine API' do
  before :all do
    root_path           = File.expand_path('../..', File.dirname(__FILE__))
    @end_to_end_config  = YAML.load_file(File.join(root_path, 'config', 'end_to_end.yml'))
    @redmine            = @end_to_end_config[:redmine]
  end

  def get(path)
    url     = URI.parse(@redmine[:authentication][:url])
    use_ssl = url.scheme == 'https'
    Net::HTTP.start(url.host, use_ssl: use_ssl, verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|
      http.get(path, 'X-Redmine-API-Key' => @redmine[:authentication][:api_key])
    end
  end

  def parse(response)
    Nokogiri::XML(response.body)
  end

  describe 'projects' do
    it 'lists projects' do
      doc = parse(get('/projects.xml'))
      projects = doc.xpath('//project')
      
      expect(projects.size).to be > 0
    end

    it 'indicates the total count' do
      doc = parse(get('/projects.xml'))
      expect(doc.root.attributes).to include('total_count')
    end

    it 'defaults to 25 results' do
      doc = parse(get('/projects.xml'))
      projects = doc.xpath('//project')
      
      expect(doc.root['limit']).to eq('25')
      expect(projects.size).to eq(25)
    end

    it 'allows setting result count' do
      doc = parse(get('/projects.xml?limit=3'))
      projects = doc.xpath('//project')
      
      expect(doc.root['limit']).to eq('3')
      expect(projects.size).to eq(3)
    end

    it 'allows pagination' do
      doc = parse(get('/projects.xml?offset=2'))

      expect(doc.root['offset']).to eq('2')
    end
  end
end

