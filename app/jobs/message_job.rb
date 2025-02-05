class MessageJob < ApplicationJob
  queue_as :default


  def perform(message)
    Evo::Base.new.create(message)
  end
end
