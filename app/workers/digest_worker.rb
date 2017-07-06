require 'sidekiq-scheduler'

class DigestWorker
  include Sidekiq::Worker

  def perform(*args)
  end
end
