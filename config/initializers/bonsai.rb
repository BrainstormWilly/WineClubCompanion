require 'elasticsearch/model'

if ENV['BONSAI_ROSE_URL']
    Elasticsearch::Model.client = Elasticsearch::Client.new({url: ENV['BONSAI_ROSE_URL'], logs: true})
  end
