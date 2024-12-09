# frozen_string_literal: true

class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :name
end
