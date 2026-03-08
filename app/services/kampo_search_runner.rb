class KampoSearchRunner
  attr_reader :no_condition, :results

  def initialize(medical_area_ids: [], disease_ids: [], symptom_ids: [], keyword: nil)
    @medical_area_ids = Array(medical_area_ids).reject(&:blank?)
    @disease_ids      = Array(disease_ids).reject(&:blank?)
    @symptom_ids      = Array(symptom_ids).reject(&:blank?)
    @keyword          = keyword.to_s.strip

    @no_condition = false
    @results = []
  end

  def call
    if medical_area_ids.blank? && disease_ids.blank? && symptom_ids.blank? && keyword.blank?
      @no_condition = true
      @results = []
      return self
    end

    @no_condition = false

    filtered_kampos = KampoSearchQuery.new(
      medical_area_ids: medical_area_ids,
      disease_ids: disease_ids,
      symptom_ids: symptom_ids,
      keyword: keyword
    ).call

    @results = KampoSearch.new(
      disease_ids: disease_ids,
      symptom_ids: symptom_ids,
      kampos_scope: filtered_kampos
    ).call

    self
  end

  private

  attr_reader :medical_area_ids, :disease_ids, :symptom_ids, :keyword
end
