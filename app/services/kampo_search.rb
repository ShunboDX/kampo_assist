class KampoSearch
  Result = Struct.new(
    :kampo,
    :total_score,
    :disease_score,
    :symptom_score,
    keyword_init: true
  )

  def initialize(disease_ids: [], symptom_ids: [], limit: nil, kampos_scope: Kampo.all)
    @disease_ids  = Array(disease_ids).reject(&:blank?).map(&:to_i)
    @symptom_ids  = Array(symptom_ids).reject(&:blank?).map(&:to_i)
    @limit        = limit
    @kampos_scope = kampos_scope
  end

  def call
    return [] if disease_ids.empty? && symptom_ids.empty? && kampos_scope.blank?

    disease_links = load_disease_links
    symptom_links = load_symptom_links

    disease_grouped = disease_links.group_by(&:kampo_id)
    symptom_grouped = symptom_links.group_by(&:kampo_id)

    scoped_kampo_ids = kampos_scope.pluck(:id)

    candidate_ids =
      if disease_ids.empty? && symptom_ids.empty?
        scoped_kampo_ids
      else
        ((disease_grouped.keys + symptom_grouped.keys).uniq & scoped_kampo_ids)
      end

    return [] if candidate_ids.empty?

    kampos = kampos_scope.where(id: candidate_ids)

    results = kampos.map do |kampo|
      disease_score = disease_score_for(kampo.id, disease_grouped)
      symptom_score = symptom_score_for(kampo.id, symptom_grouped)
      total_score   = disease_score + symptom_score

      Result.new(
        kampo: kampo,
        total_score: total_score,
        disease_score: disease_score,
        symptom_score: symptom_score
      )
    end

    results.sort_by! { |res| -res.total_score }
    limit.present? ? results.first(limit) : results
  end

  private

  attr_reader :disease_ids, :symptom_ids, :limit, :kampos_scope

  def load_disease_links
    if disease_ids.any?
      KampoDisease.where(disease_id: disease_ids, kampo_id: kampos_scope.select(:id))
    else
      KampoDisease.none
    end
  end

  def load_symptom_links
    if symptom_ids.any?
      KampoSymptom.where(symptom_id: symptom_ids, kampo_id: kampos_scope.select(:id))
    else
      KampoSymptom.none
    end
  end

  def disease_score_for(kampo_id, disease_grouped)
    Array(disease_grouped[kampo_id]).sum { |link| link.weight.to_i }
  end

  def symptom_score_for(kampo_id, symptom_grouped)
    Array(symptom_grouped[kampo_id]).size
  end
end
