class AvatarUploader < CarrierWave::Uploader::Base
  CarrierWave::SanitizedFile.sanitize_regexp = /[^a-zA-Zа-яА-ЯёЁ0-9\.\-\+_]/u
  include CarrierWave::MiniMagick

  process :resize_to_fit => [100, 100]

  def store_dir
    'avatar'
  end


  def default_url
    'default/' + [thumb, "default.png"].compact.join('_')
  end

  version :thumb do
    process :resize_to_fill => [50, 50]
  end

  version :small_thumb, :from_version => :thumb do
    process resize_to_fill: [25, 25]
  end

  def cache_dir
    '/tmp/cache'
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
