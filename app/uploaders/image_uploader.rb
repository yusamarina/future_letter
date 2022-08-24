class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  if Rails.env.development?
    storage :file
  elsif Rails.env.test?
    storage :file
  else
    storage :fog
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_allowlist
    %w[jpg jpeg gif png]
  end

  def size_range
    0..5.megabytes
  end

  def filename
    original_filename if original_filename
  end

  process resize_to_fill: [350, 350, 'Center']
end
