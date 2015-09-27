require 'mongoid'

ROOT_PATH = "#{File.dirname(__FILE__)}/.."
MONGOID_ENV = 'development'

Mongoid.load!("#{ROOT_PATH}/config/mongoid.yml", MONGOID_ENV)

Mongoid.logger.level = Logger::ERROR
Mongo::Logger.logger.level = Logger::ERROR

Dir.glob("#{ROOT_PATH}/jobs/*.rb").each { |f| require f }
Dir.glob("#{ROOT_PATH}/models/*.rb").each { |f| require f }
Dir.glob("#{ROOT_PATH}/lib/*.rb").each { |f| require f }
Dir.glob("#{ROOT_PATH}/services/*.rb").each { |f| require f }
