class KumquatReportInterceptor

  def self.delivering_email(mail)
    return unless mail['X-KUMQUAT']
    interceptor = new(mail)
    interceptor.process
  end

  attr_reader :mail

  def initialize(mail)
    @images = {}
    @mail = mail
    @content = @mail.html_part.decoded
  end

  def process
    mail['X-KUMQUAT'] = nil
    mail.html_part.body = extract_images

    mail['X-SIG'] = 'bypass'

    m = mail # Need a local variable so that we don't fight with the mail object

    mixed_part = Mail::Part.new do
      content_type 'multipart/alternative'
      m.parts.delete_if { |p| add_part p }
    end
    mail.add_part mixed_part

    # Set the message content-type to be 'multipart/mixed'
    mail.content_type 'multipart/related'
    mail.header['content-type'].parameters[:boundary] = mail.body.boundary

    @images.each do |key, image|
      mail.attachments.inline[key] = image
    end
    mail
  end

  def extract_images
    cleaned = @content.dup
    ts = Time.now.to_f
    @content.scan(/img src="(.+?)"/).flatten.each.with_index do |img_data, index|
      (type, b64) = img_data.split(',', 2)
      name = "image_#{index}"
      cid = "#{ts}_#{name}@kumquat.magic"
      @images[name] = {
        mime_type: type[%r|\w+/\w+|],
        content: Base64.decode64(b64),
        cid: cid,
        content_id: "<#{cid}>"
      }
      cleaned.gsub!(img_data, "cid:#{URI.escape(cid)}")
    end
    cleaned
  end

end
