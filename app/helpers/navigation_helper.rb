module NavigationHelper
  # Показывает кнопку "Назад" (на главную), если мы не на главной
  def back_button
    return if current_page?(root_path)

    link_to "←", root_path, class: "btn-icon back-btn", title: "На главную"
  end
end
