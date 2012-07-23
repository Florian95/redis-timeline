require 'active_model'

module Timeline
  class Activity < Hashie::Mash
    extend ActiveModel::Naming

    def to_partial_path
      "timelines/#{verb}"
    end

    def ref_object
      eval(self[:class]).find(self[:id]) rescue nil
    end

  end
end