class HomepageController < ApplicationController
  def index
    @most_recent = Tweet.newest_first.first
  end
end
