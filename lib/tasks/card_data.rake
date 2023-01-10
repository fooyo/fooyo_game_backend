require 'csv'
namespace :card_data do
  desc 'export data'
  task export: :environment do
    CSV.open('card.csv', 'w') do |csv|
      Card.where('id>28401').find_each do |card|
        csv << card.attributes.except('created_at', 'updated_at').values
      end
    end
  end

  desc 'import data'
  task import: :environment do
    File.open('card.csv', 'r').each_line do |line|
      array = line.chomp.split(',')
      c = Card.create(id: array[0], user_id: array[1], card_type: array[2], card_type_text: array[3], code: array[4], is_used: array[5])
      p "#{c.id} #{c.card_type}"
    end
  end
end