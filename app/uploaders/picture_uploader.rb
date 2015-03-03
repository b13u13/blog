# encoding: utf-8

class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  process :resize_to_limit => [800, 800]


  def store_dir
    'picture/'
  end



  version :thumb do
    process :resize_to_limit => [400, 400]
  end



  def cache_dir
    '/tmp/cache'
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end



end
