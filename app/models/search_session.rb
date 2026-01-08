class SearchSession < ApplicationRecord
  belongs_to :user

  validates :conditions, presence: true
  validates :conditions_hash, presence: true

  before_validation :normalize_conditions!
  before_validation :set_conditions_hash!

  def self.generate_hash(conditions)
    normalized = conditions.to_h.deep_dup

    %w[medical_area_ids disease_ids symptom_ids].each do |key|
      next unless normalized.key?(key)

      normalized[key] = Array(normalized[key])
                          .reject(&:blank?)
                          .map(&:to_s)
                          .sort
    end

    normalized = normalized.sort.to_h
    Digest::SHA256.hexdigest(normalized.to_json)
  end

  def result_kampo_names(limit: 3)
    disease_ids = Array(conditions["disease_ids"]).reject(&:blank?)
    symptom_ids = Array(conditions["symptom_ids"]).reject(&:blank?)

    return [] if disease_ids.blank? && symptom_ids.blank?

    results = KampoSearch.new(disease_ids: disease_ids, symptom_ids: symptom_ids).call
    results.first(limit).map { |r| r.kampo.name }
  end

  def result_count
    disease_ids = Array(conditions["disease_ids"]).reject(&:blank?)
    symptom_ids = Array(conditions["symptom_ids"]).reject(&:blank?)

    return 0 if disease_ids.blank? && symptom_ids.blank?

    KampoSearch.new(disease_ids: disease_ids, symptom_ids: symptom_ids).call.size
  end

   # 追加：表示用メソッド（一覧向け）
  def medical_area_names(limit: 3)
    ids = Array(conditions["medical_area_ids"]).reject(&:blank?)
    return [] if ids.blank?
    MedicalArea.where(id: ids).limit(limit).pluck(:name)
  end

  def disease_names(limit: 3)
    ids = Array(conditions["disease_ids"]).reject(&:blank?)
    return [] if ids.blank?
    Disease.where(id: ids).limit(limit).pluck(:name)
  end

  def symptom_names(limit: 3)
    ids = Array(conditions["symptom_ids"]).reject(&:blank?)
    return [] if ids.blank?
    Symptom.where(id: ids).limit(limit).pluck(:name)
  end

  def medical_area_names_all
    ids = Array(conditions["medical_area_ids"]).reject(&:blank?)
    return [] if ids.blank?
    MedicalArea.where(id: ids).pluck(:name)
  end

  def disease_names_all
    ids = Array(conditions["disease_ids"]).reject(&:blank?)
    return [] if ids.blank?
    Disease.where(id: ids).pluck(:name)
  end

  def symptom_names_all
    ids = Array(conditions["symptom_ids"]).reject(&:blank?)
    return [] if ids.blank?
    Symptom.where(id: ids).pluck(:name)
  end

  private

  def normalize_conditions!
    self.conditions ||= {}

    normalized = conditions.to_h.deep_dup

    # 配列になり得るキーは、型を整えて昇順ソート（順序揺れ対策）
    %w[medical_area_ids disease_ids symptom_ids].each do |key|
      next unless normalized.key?(key)

      normalized[key] = Array(normalized[key])
                          .reject(&:blank?)
                          .map(&:to_s)
                          .sort
    end

    # 将来増える条件のために、全体のキー順も揃える
    self.conditions = normalized.sort.to_h
  end

  def set_conditions_hash!
    # conditions が空でもpresenceで弾かれる想定だが、念のため
    payload = conditions.to_h
    self.conditions_hash = Digest::SHA256.hexdigest(payload.to_json)
  end
end
