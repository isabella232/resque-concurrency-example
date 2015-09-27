require 'resque'

module ResqueConcurrencyAdapter

  def execute_concurrently(klass, method, arguments_array)
    supervisor = JobSupervisor.create

    arguments_array.each_with_index do |arguments, i|
      Resque.enqueue(JobProcessor, {
        klass: klass,
        method: method,
        method_arguments: arguments,
        job_id: i,
        supervisor_id: supervisor.id.to_s
      })
      supervisor.increase_enqueued_jobs_count
    end

    supervisor.wait_for_completion

    supervisor
  end
end