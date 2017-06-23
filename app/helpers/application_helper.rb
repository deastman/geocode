module ApplicationHelper
  def flash_name_to_bootstrap_alert(name)
    case name.to_s
    when 'notice'
      'success'
    when 'error'
      'danger'
    else
      'info'
    end
  end
end
