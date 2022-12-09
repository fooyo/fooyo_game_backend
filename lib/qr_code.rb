require "rqrcode"
class QrCode
  class << self
    def generate_png(content, path, text = nil)
      qrcode = RQRCode::QRCode.new(content)
      # NOTE: showing with default options specified explicitly
      png = qrcode.as_png(
        bit_depth: 1,
        border_modules: 4,
        color_mode: ChunkyPNG::COLOR_GRAYSCALE,
        color: "black",
        file: nil,
        fill: "white",
        module_px_size: 6,
        resize_exactly_to: false,
        resize_gte_to: false,
        size: 400
      )

      IO.binwrite(path, png.to_s)
    end
  end
end
