class Autocomplete::KamposController < ApplicationController
  def index
    q = params[:q].to_s.strip
    return render json: [] if q.blank?

    kampos = Kampo
      .where("name ILIKE ?", "%#{sanitize_sql_like(q)}%")
      .order(:name)
      .limit(10)
      .select(:id, :name)

    render json: kampos.map { |k| { id: k.id, name: k.name } }
  end

  private

  def sanitize_sql_like(string)
    ActiveRecord::Base.sanitize_sql_like(string)
  end
end
