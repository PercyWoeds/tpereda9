#multi_file_zipper_download.rb
require 'zip'

class MultiFileZipperDownload
  ZIPPED_FILE_NAME = 'Archive.zip' # Same as Google drive :P

  def initialize(s3_keys, bucket)
    @s3_keys = s3_keys
    @bucket = bucket
  end

  def call
    zip_files(download_objects)
    build_zipped_s3_key
    upload_zip
    delete_tmp_file
    @zipped_s3_key
  end

  private

  def download_objects
    @s3_keys.map.each_with_index do |key, idx|
      # Avoid replacing files with same name by using the index, you can skip this if you like
      new_path = "#{tmp_dir}/#{idx} - #{key.split('/').last}"
      S3Service.download_file(key: key, to: new_path, bucket: @bucket)
      new_path
    end
  end

  def zip_files(files)
    ::Zip::File.open(zipped_file_path, Zip::File::CREATE) do |zipfile|
      files.each do |filepath|
        zipfile.add(filepath.split('/').last, filepath)
      end
    end
  end

  def tmp_dir
    @tmp_dir ||= Dir.mktmpdir
  end

  def zipped_file_path
    "#{tmp_dir}/#{ZIPPED_FILE_NAME}"
  end

  def build_zipped_s3_key
    # I use the hash of the file to avoid collisions, but you can change this to whatever you like
    hash = Digest::SHA256.file(zipped_file_path).to_s

    @zipped_s3_key = "multi_downloads/#{hash}/#{ZIPPED_FILE_NAME}"
  end

  def upload_zip
    # I upload the zipped file to S3 so we can send a link to tje file afterwards
    S3Service.upload_file(from: zipped_file_path, to: @zipped_s3_key, bucket: @bucket)
  end

  def delete_tmp_file
    # Remove all the files to avoid disk usage leaks
    FileUtils.rm_rf(tmp_dir)
  end
end