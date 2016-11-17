require 'elasticsearch/model'

if ENV['BONSAI_ROSE_URL']
    Elasticsearch::Model.client = Elasticsearch::Clien.new({url: ENV['BONSAI_ROSE_URL'], logs: true})
  end
