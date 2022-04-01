defmodule ArslaneToNarniaWeb.EmailTestingView do
  use ArslaneToNarniaWeb, :view

  def menu_item_classes(is_active) do
    active_classes =
      if is_active do
        "bg-gray-100 text-gray-900 dark:bg-gray-900 dark:text-gray-100"
      else
        "text-gray-600 hover:bg-gray-50 hover:text-gray-900 dark:text-gray-400 dark:hover:bg-gray-900 dark:hover:text-gray-200"
      end

    active_classes <> " " <> "flex items-center px-2 py-2 text-sm font-medium rounded-md group"
  end
end
