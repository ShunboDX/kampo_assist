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
