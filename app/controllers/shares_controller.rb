class SharesController < ApplicationController
  before_action :authenticate, only: %i[new create]

  def create
    video = Video.find_or_initialize_by(video_id: video_id)
    
    if video.persisted?
      flash[:danger] = "Video was shared!"
      return redirect_to new_shares_path
    end

    video_info = get_video_info

    if video_info.blank?
      flash[:danger] = "Video not found!"
      return redirect_to new_shares_path
    end

    if save_video(video, video_info)
      flash[:success] = "Successfully shared!"
      return redirect_to root_path
    else
      flash[:danger] = "Save failed!"
      redirect_to new_shares_path
    end
  end

  private
  
  def save_video video, video_info
    video.video_id = video_id
    video.title = video_info.title
    video.description = video_info.description
    video.user_id = session[:user_id]
    video.save
  end

  def get_video_info
    response = RestClient.get("https://www.googleapis.com/youtube/v3/videos", {
      params: {
        id: video_id,
        key: ENV["API_KEY"],
        part: "snippet"
      }
    })
    JSON.parse(response.body, object_class: OpenStruct).items&.first&.snippet
  end

  def video_id
    if params[:url]&.include?("=")
      params[:url]&.split("=")&.last
    else
      params[:url]&.split("/")&.last
    end
  end
end
