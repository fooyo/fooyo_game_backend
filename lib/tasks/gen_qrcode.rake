namespace :gen_qrcode do
  task tiger: :environment do
    Card.tiger.each_with_index do |card, index|
      path = "#{Rails.root}/qr_images/虎/虎#{index+1}.png"
      content = card.code
      QrCode.generate_png(content, path)
      p index
    end
  end
  task rabbit: :environment do
    Card.rabbit.each_with_index do |card, index|
      path = "#{Rails.root}/qr_images/兔/兔#{index+1}.png"
      content = card.code
      QrCode.generate_png(content, path)
      p index
    end
  end

  task ths: :environment do
    Card.ths.each_with_index do |card, index|
      path = "#{Rails.root}/qr_images/谢谢.png"
      content = card.code
      QrCode.generate_png(content, path)
      p index
    end
  end
end