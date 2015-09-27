require "#{ROOT_PATH}/models/concerns/status"

class JobSupervisor
  include Mongoid::Document

  field :status, type: Status
  field :work_done_at, type: DateTime
  field :enqueued_jobs_count, type: Integer
  field :job_statuses, type: Hash, default: {}

  has_many :job_infos

  def iterate_job_infos
    JobInfo.where({ job_supervisor_id: id, status: :success}).each do |job_info|
      yield job_info
    end
  end

  def mark_finished
    set({ work_done_at: Time.now })
  end

  def wait_for_completion
    while reload.jobs_in_progress? do
      mark_finished
      sleep 1
    end
  end

  def jobs_in_progress?
    job_statuses.keys.count != enqueued_jobs_count
  end

  def set_job_status(job_id, status)
    collection.find({'_id' => id}).update_one({'$set'=> {"job_statuses.#{job_id}" => status}})
  end

  def increase_enqueued_jobs_count
    inc(enqueued_jobs_count: 1)
  end
end
