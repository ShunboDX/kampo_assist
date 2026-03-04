class Autocomplete::SymptomsController < ApplicationController
  def index
    q = params[:q].to_s.strip
    return render json: [] if q.blank?

    symptoms = Symptom
      .where("name ILIKE ?", "%#{sanitize_sql_like(q)}%")
      .order(:name)
      .limit(10)
      .select(:id, :name)

    render json: symptoms.map { |s| { id: s.id, name: s.name } }
  end

  private

  def sanitize_sql_like(string)
    ActiveRecord::Base.sanitize_sql_like(string)
  end
end
