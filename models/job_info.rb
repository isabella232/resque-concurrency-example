require "#{ROOT_PATH}/models/concerns/status"

class JobInfo
  include Mongoid::Document

  field :status, type: Status
  field :payload, type: Hash
  field :job_id, type: String

  belongs_to :job_supervisor

  def mark_failed(exception_message)
    status = :failure
    set(status: :failure, payload: { exception_message: exception_message })
    notify_supervisor(status)
  end

  def mark_successful(report)
    status = :success
    set(status: :success, payload: report)
    notify_supervisor(status)
  end

  def notify_supervisor(status)
    job_supervisor.set_job_status(job_id, status)
  end
end
