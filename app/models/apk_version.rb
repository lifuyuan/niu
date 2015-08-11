class ApkVersion
  include Mongoid::Document
  include Mongoid::Timestamps

  field :version, type: String
end
