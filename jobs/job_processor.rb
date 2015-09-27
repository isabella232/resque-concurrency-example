require 'mongoid'

class JobProcessor
  @queue = :default

  def self.perform(args)
    result = args['klass'].constantize.send(args['method'], args['method_arguments'])
    get_or_create_job_info(args).mark_successful(result)
  rescue => ex
    handle_exception(ex, args)
  end

  def self.get_or_create_job_info(args)
    supervisor = JobSupervisor.find(args['supervisor_id'])
    job_info = JobInfo.where(job_supervisor: supervisor, job_id: args[get_unique_property]).first
    job_info || JobInfo.create(job_supervisor: supervisor, job_id: args[get_unique_property])
  end

  def self.handle_exception(ex, args)
    get_or_create_job_info(args).mark_failed(ex.message)
  end

  def self.get_unique_property
    'job_id'
  end
end
