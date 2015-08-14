class ApkController < ApplicationController
  def download
  	ApkDownload.create(ip: request.remote_ip)
  	send_file('public/app-release.apk',:filename => "app-release.apk", :disposition =>'attachment', :encoding => 'utf-8', :stream => false)
  end

  def upgrade
  	send_data File.read('public/app-release.apk'), filename: "app-release.apk"
  end
end
