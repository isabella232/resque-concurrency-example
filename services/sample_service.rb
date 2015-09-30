require "#{ROOT_PATH}/lib/resque_concurrency_adapter"
require 'securerandom'

class SampleService
  include ResqueConcurrencyAdapter
  MONGODB_BATCH_SIZE = 5000

  def initialize(nr_of_documents)
    @nr_of_documents = nr_of_documents
  end

  def run_sequentially
    self.class.generate_documents(@nr_of_documents)
    nil
  end

  def run_concurrently
    total_documents = @nr_of_documents
    documents_per_job = MONGODB_BATCH_SIZE
    job_count = total_documents / documents_per_job

    arguments_array = job_count.times.map { documents_per_job }
    if total_documents % documents_per_job != 0
      arguments_array << total_documents % documents_per_job
    end

    execute_concurrently('SampleService', 'generate_documents', arguments_array)
    nil
  end

  def self.generate_documents(count)
    (0...count).each_slice(MONGODB_BATCH_SIZE) do |slice|
      SampleDocument.collection.insert_many(slice.map { { text: SecureRandom.base64(50) } })
    end
  end
end