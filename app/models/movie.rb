class Movie < ActiveRecord::Base
    def self.get_all_ratings
        return Movie.distinct.pluck("rating")
    end
end
