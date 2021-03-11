# frozen_string_literal: true

module ApplicationHelper
  def flash_message(type)
    return unless flash[type]

    content_tag :div, class: "alert #{message_type(type)} alert-dismissible fade show", role: 'alert' do
      content_tag(:span, flash[type]) +
        button_tag('', type: 'button', class: 'btn-close', data: { bs_dismiss: 'alert' }, aria: { label: 'Close' })
    end
  end

  def message_type(type)
    case type
    when 'notice' then 'alert-success'
    when 'alert' then 'alert-danger'
    else
      'alert-info'
    end
  end
end
