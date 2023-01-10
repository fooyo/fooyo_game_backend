namespace :gen_qrcode do
  task tiger: :environment do
    # Card.where('id>28401').tiger.each_with_index do |card, index|
    Card.where('id>68401').tiger.each_with_index do |card, index|
      path = "#{Rails.root}/qr_images/1.10新增虎15000/虎#{index+1}.png"
      content = card.code
      QrCode.generate_png(content, path)
      p index
    end
  end
  task rabbit: :environment do
    # Card.where('id>28401').rabbit.each_with_index do |card, index|
    Card.where('id>68401').rabbit.each_with_index do |card, index|
      path = "#{Rails.root}/qr_images/1.10新增兔15000/兔#{index+1}.png"
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