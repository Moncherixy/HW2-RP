class Movie < ActiveRecord::Base
    def self.all_ratings
        return self.select("DISTINCT rating").map(&:rating)
    end
end
