# frozen_string_literal: true

module Fragment
  class ActivityItemsController < Fragment::ApplicationController
    before_action :authenticate_user!, only: %i[index]

    def index
      set_page_category params[:page_category]

      @activity_group = ActivityGroup.find(params[:activity_group_id])
    end
  end
end
