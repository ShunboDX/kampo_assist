class Autocomplete::DiseasesController < ApplicationController
  def index
    q = params[:q].to_s.strip
    return render json: [] if q.blank?

    diseases = Disease
      .where("name ILIKE ?", "%#{sanitize_sql_like(q)}%")
      .order(:name)
      .limit(10)
      .select(:id, :name)

    render json: diseases.map { |d| { id: d.id, name: d.name } }
  end

  private

  # ActiveRecord::Sanitization を使えるようにする（Rails標準）
  def sanitize_sql_like(string)
    ActiveRecord::Base.sanitize_sql_like(string)
  end
end
