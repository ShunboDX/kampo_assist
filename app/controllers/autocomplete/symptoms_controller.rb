class Autocomplete::SymptomsController < ApplicationController
  def index
    q = params[:q].to_s.strip
    return render json: [] if q.blank?

    escaped = ActiveRecord::Base.sanitize_sql_like(q)

    symptoms = Symptom
      .where("name LIKE ?", "%#{escaped}%")
      .order(:name)
      .limit(10)
      .pluck(:id, :name)

    render json: symptoms.map { |id, name| { id: id, name: name } }
  end
end
