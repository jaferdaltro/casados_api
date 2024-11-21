class HandleEventJob < ApplicationJob
  queue_as :default

  def perform
    asaas = Asaas::WebHook.new
    asaas.handle_weebhook
  end
end
