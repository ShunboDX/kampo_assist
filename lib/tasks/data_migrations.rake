# lib/tasks/data_migrations.rake
namespace :data_migrations do
  desc "Move Symptom '貧血' to Disease '貧血'"
  task move_anemia: :environment do
    symptom_name = "貧血"
    disease_name = "貧血"

    anemia_symptom = Symptom.find_by!(name: symptom_name)

    anemia_disease = Disease.find_or_create_by!(
      name: disease_name,
      medical_area_id: anemia_symptom.medical_area_id
    )

    kampo_scope = Kampo.joins(:symptoms).where(symptoms: { id: anemia_symptom.id }).distinct
    puts "Found #{kampo_scope.count} kampo with Symptom '#{symptom_name}'."

    updated = 0
    ActiveRecord::Base.transaction do
      kampo_scope.find_each(batch_size: 200) do |kampo|
        next if kampo.diseases.exists?(anemia_disease.id)

        kampo.diseases << anemia_disease
        updated += 1
      end
    end

    puts "Attached Disease '#{disease_name}' to #{updated} kampo."
    puts "Done."
  end
end
