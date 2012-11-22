class Attachment < ActiveRecord::Base
  belongs_to :challenge

  def self.save(id, upload)
    return nil if upload.blank?

    name = sanitize_filename(upload.original_filename)
    path = filename name

    i = 0
    ext = "." + name.split('.').last
    basen = File.basename(name, ext)
    while File.exists? path
      i += 1
      namei = basen + "_" + i.to_s + ext
      path = filename namei
    end
    File.open(path, "wb") { |f| f.write(upload.read) }
    return {:name => name, :file => path}
  end

  def self.remove(path)
    File.delete(path) if File.exists? path
  end

  def destroy
    Attachment.remove Attachment.find(id).file
    super.delete
  end

  private

  def self.sanitize_filename(filename)
    return filename.gsub(/[^0-9A-z.\-]/, '_')
  end

  def self.filename(name)
    return File.join(Rails.root.join('public', 'uploads', name))
  end

end
