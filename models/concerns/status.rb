require 'enumize_mongoid'

class Status
  include EnumizeMongoid::Field

  enumize([:success, :failure])
end
