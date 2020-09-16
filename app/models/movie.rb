class Movie < ActiveRecord::Base
    #used to have access to all the possible ratings of a movie
    @@all_ratings
    def self.all_ratings
        @@all_ratings = ["G","PG","PG-13","R"]
    end
end
