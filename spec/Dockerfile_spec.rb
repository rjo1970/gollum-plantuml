require 'serverspec'
require 'docker'

describe 'Dockerfile' do
  before(:all) do
    image = Docker::Image.build_from_dir('.')

    set :os, family: :debian
    set :backend, :docker
    set :docker_image, image.id
  end

  it 'is based on a Stretch Debian distribution' do
    expect(os_version).to include('Debian GNU/Linux 9 (stretch)')
  end

  it 'has the expected version of Ruby installed' do
    expect(ruby_version).to include('ruby 2.5')
  end

  it 'has the rack environment set to production' do
    expect(rack_env).to include ('production')
  end

  it 'does not need database or odd rcs packages' do
    expect(package("bzr")).to_not be_installed
    expect(package("mercurial")).to_not be_installed
    expect(package("subversion")).to_not be_installed
    expect(package("libmysqlclient-dev")).to_not be_installed
    expect(package("libsqlite3-dev")).to_not be_installed
  end

  it 'requires plantUML build and run dependencies' do
    expect(package("default-jdk")).to be_installed
    expect(package("maven")).to be_installed
    expect(package("graphviz")).to be_installed
    expect(package("libicu-dev")).to be_installed
  end

  it 'uses HAProxy to share both Java and Ruby websites on a single port' do
    expect(package("haproxy")).to be_installed
  end

  # PlantUML should be checked out at tag v2017.11
  describe command('cd /plantuml-server && git branch') do
    its(:stdout) { should match /v2017.11/ }
  end

  # PlantUML should be compiled to a war file
  describe command('ls /plantuml-server/target') do
    its(:stdout) { should match /plantuml.war/ }
  end

  # Default to a gollum git repository with a Home.md file
  describe command('ls -al /gollum') do
    its(:stdout) { should match /Home.md/ }
    its(:stdout) { should match /\.git/ }
  end

  # gollum repository should have Created Home (markdown) commit
  describe command('git log') do
    its(:stdout) { should match /Created Home \(markdown\)/ }
  end

  # it should have puma and gollum installed
  describe command('gem list') do
    its(:stdout) { should match /puma/ }
    its(:stdout) { should match /gollum/ }
  end

  describe file('/config.rb') do
    its(:sha256sum) { should eq 'cf3d9732afbf71147dcc4f91bba832517dd18ac42ffda3d9f59600f1ab42e3a4' }
  end

  describe file('/etc/haproxy/haproxy.cfg') do
    its(:sha256sum) { should eq '8e86809eb75eb67fba528b5873e4706a4273b66697f6f1826145518fd8058c98' }
  end

  # HAProxy should be enabled
  describe command('cat /etc/default/haproxy') do
    its(:stdout) { should match /ENABLED=1/ }
  end

  describe file('/start.sh') do
    its(:sha256sum) { should eq '933bfd4f1f05a31a4ab665cb27fa3a451985768cdf94626688f9316bb2887e5d' }
  end

  def os_version
    command('cat /etc/os-release').stdout
  end

  def ruby_version
    command('ruby -v').stdout
  end

  def rack_env
    command('echo $RACK_ENV').stdout
  end
end
