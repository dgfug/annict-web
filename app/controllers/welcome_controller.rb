# frozen_string_literal: true

class WelcomeController < ApplicationV6Controller
  layout "main_welcome"

  def show
    set_page_category PageCategory::WELCOME

    work_list = Work.only_kept.preload(:work_image)
    @seasonal_work_list = work_list.by_season(ENV.fetch("ANNICT_CURRENT_SEASON")).order(watchers_count: :desc).limit(6)
    cover_image_path = @seasonal_work_list.sample&.work_image&.uploaded_file_path(:image)
    @cover_image_url = cover_image_path ? helpers.ix_image_url(cover_image_path, blur: 60, height: 800, width: 600) : ""
  end
end
