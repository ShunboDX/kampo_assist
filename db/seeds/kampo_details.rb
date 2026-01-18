# db/seeds/kampo_details.rb
require "csv"

path = Rails.root.join("db", "data", "kampo_details.csv")
raise "CSV not found: #{path}" unless File.exist?(path)

updated = 0
not_found = 0

CSV.foreach(path, headers: true) do |row|
  name   = row["name"]&.strip
  detail = row["detail"]

  next if name.blank?

  kampo = Kampo.find_by(name: name)
  unless kampo
    not_found += 1
    puts "NOT FOUND: #{name}"
    next
  end

  next if kampo.detail == detail
  kampo.update!(detail: detail)
  updated += 1
end

puts "== Kampo details imported =="
puts "updated: #{updated}, not_found: #{not_found}"

