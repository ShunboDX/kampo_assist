class KampoSearchQuery
  def initialize(medical_area_ids: [], disease_ids: [], symptom_ids: [], keyword: nil)
    @medical_area_ids = Array(medical_area_ids).reject(&:blank?)
    @disease_ids      = Array(disease_ids).reject(&:blank?)
    @symptom_ids      = Array(symptom_ids).reject(&:blank?)
    @keyword          = keyword.to_s.strip
  end

  def call
    scope = Kampo.all

    scope = filter_by_medical_areas(scope)
    scope = filter_by_diseases(scope)
    scope = filter_by_symptoms(scope)
    scope = filter_by_keyword(scope)

    scope.distinct
  end

  private

  attr_reader :medical_area_ids, :disease_ids, :symptom_ids, :keyword

  def filter_by_medical_areas(scope)
    return scope if medical_area_ids.blank?

    scope.joins(:diseases).where(diseases: { medical_area_id: medical_area_ids })
  end

  def filter_by_diseases(scope)
    return scope if disease_ids.blank?

    scope.joins(:diseases).where(diseases: { id: disease_ids })
  end

  def filter_by_symptoms(scope)
    return scope if symptom_ids.blank?

    scope
      .joins(:symptoms)
      .where(symptoms: { id: symptom_ids })
      .group("kampos.id")
      .having("COUNT(DISTINCT symptoms.id) = ?", symptom_ids.size)
  end

  def filter_by_keyword(scope)
    return scope if keyword.blank?

    escaped = ActiveRecord::Base.sanitize_sql_like(keyword)

    scope.where(
      "kampos.name LIKE :q OR kampos.note LIKE :q",
      q: "%#{escaped}%"
    )
  end
end