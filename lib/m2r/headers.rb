require 'delegate'

module M2R
  class Headers < DelegateClass(Hash)

    def initialize(hash)
      downcased = hash.inject({}) do |headers,(header,value)|
        headers[header.downcase] = value
        headers
      end
      super(downcased)
    end

  end
end
