class ApkController < ApplicationController
  def download
  	send_file('files/app-release.apk',:type => 'charset=utf-8; header=present',:filename => "app-release.apk", :disposition =>'attachment', :encoding => 'utf-8')
  end
end
