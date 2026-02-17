namespace :admin do
  desc "Promote a user to admin by email: bin/rails admin:promote EMAIL=businesslifeshun@gmail.com"
  task promote: :environment do
    email = ENV["EMAIL"].to_s
    raise "EMAIL is required" if email.blank?

    user = User.find_by!(email: email)
    user.update!(role: :admin)

    puts "Promoted #{user.email} to admin"
  end
end