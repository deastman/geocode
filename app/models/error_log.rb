class ErrorLog
  def self.debug(message=nil)
    @error_log ||= Logger.new("#{Rails.root}/log/error_log")
    @error_log.debug(message) unless message.nil?
  end
end
