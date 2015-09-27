require  "#{File.dirname(__FILE__)}/config/init"
require 'benchmark'

nr_of_documents_values = [5000, 10_000, 100_000, 1_000_000, 10_000_000]

nr_of_documents_values.each do |nr_of_documents|
  Benchmark.bm do |x|
    SampleDocument.delete_all
    x.report("sequential #{nr_of_documents}") { SampleService.new(nr_of_documents).run_sequentially }

    SampleDocument.delete_all
    x.report("parallel #{nr_of_documents}") { SampleService.new(nr_of_documents).run_concurrently }
  end
end