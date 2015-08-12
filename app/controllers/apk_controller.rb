class ApkController < ApplicationController
  def download
  	send_file('files/app-release.apk',:filename => "app-release.apk", :disposition =>'attachment', :encoding => 'utf-8', :stream => false)
  end

  def upgrade
  	send_data File.read('files/app-release.apk'), filename: "app-release.apk"
  end
end
