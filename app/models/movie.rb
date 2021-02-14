class Movie < ActiveRecord::Base
    def self.all_ratings
        return Movie.distinct.pluck("rating")
    end
end
