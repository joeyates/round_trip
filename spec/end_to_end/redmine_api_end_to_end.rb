require 'json'
require 'net/https'
require 'nokogiri'
require 'yaml'
require 'pp'

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

  def parse_xml(response)
    Nokogiri::XML(response.body)
  end

  def parse_json(response)
    JSON.parse(response.body)
  end

  describe 'projects' do
    context 'xml' do
      it 'lists projects' do
        doc = parse_xml(get('/projects.xml'))
        projects = doc.xpath('//project')
        
        expect(projects.size).to be > 0
      end

      it 'indicates the total count' do
        doc = parse_xml(get('/projects.xml'))
        expect(doc.root.attributes).to include('total_count')
      end

      it 'defaults to 25 results' do
        doc = parse_xml(get('/projects.xml'))
        projects = doc.xpath('//project')
        
        expect(doc.root['limit']).to eq('25')
        expect(projects.size).to eq(25)
      end

      it 'allows setting result count' do
        doc = parse_xml(get('/projects.xml?limit=3'))
        projects = doc.xpath('//project')
        
        expect(doc.root['limit']).to eq('3')
        expect(projects.size).to eq(3)
      end

      it 'allows pagination' do
        doc = parse_xml(get('/projects.xml?offset=2'))

        expect(doc.root['offset']).to eq('2')
      end
    end

    context 'json' do
      before :all do
        @full = parse_json(get('/projects.json'))
      end

      it 'lists projects' do
        projects = @full['projects']

        expect(projects.size).to be > 0
      end

      ['total_count', 'offset', 'limit'].each do |attribute|
        it "indicates the '#{attribute}'" do
          result = parse_json(get('/projects.json'))

          expect(@full).to include(attribute)
        end
      end
    end
  end

  describe 'project' do
    it 'gets a project' do
      doc = parse_xml(get("/projects/#{@redmine[:project][:id]}.xml"))

      @redmine[:project].each do |name, value|
        expect(doc.root.at(name.to_s).inner_text).to eq(value.to_s)
      end
    end
  end

  describe 'issues' do
    it 'gets project issues' do
      doc = parse_xml(get("/issues.xml?project_id=#{@redmine[:project][:id]}"))

      issues = doc.xpath('//issue')

      expect(issues.size).to be > 0
    end
  end

  describe 'issue' do
    it 'gets an issue' do
      doc = parse_xml(get("/issues/#{@redmine[:issue][:id]}.xml"))

      @redmine[:issue].each do |name, value|
        expect(doc.root.at(name.to_s).inner_text).to eq(value.to_s)
      end
    end
  end

  describe 'issue_statuses' do
    it 'gets issues statuses' do
      doc = parse_xml(get("/issue_statuses.xml"))

      pp doc.root
    end
  end

  describe 'issue_status' do
    it 'gets an issue status' do
      pending 'Not yet implemented in Redmine API'
      doc = parse_xml(get("/issue_statuses/#{@redmine[:status][:id]}.xml"))
    end
  end

  describe 'tracker' do
    it 'gets a tracker' do
      pending 'Not yet implemented in Redmine API'
      doc = parse_xml(get("/trackers/#{@redmine[:tracker][:id]}.xml"))
    end
  end
end

