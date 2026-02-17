# app/services/search_session_saver.rb
class SearchSessionSaver
  DEFAULT_LIMIT = 100

  def initialize(user:, medical_area_ids:, disease_ids:, symptom_ids:, limit: DEFAULT_LIMIT)
    @user = user
    @medical_area_ids = Array(medical_area_ids).reject(&:blank?)
    @disease_ids      = Array(disease_ids).reject(&:blank?)
    @symptom_ids      = Array(symptom_ids).reject(&:blank?)
    @limit = limit
  end

  def call
    return unless @user

    conditions = {
      "medical_area_ids" => @medical_area_ids,
      "disease_ids"      => @disease_ids,
      "symptom_ids"      => @symptom_ids
    }.compact_blank

    return if conditions.blank?

    hash = SearchSession.generate_hash(conditions)

    search_session = @user.search_sessions.find_or_initialize_by(conditions_hash: hash)
    search_session.conditions = conditions
    search_session.save!

    enforce_limit!

    search_session
  end

  private

  def enforce_limit!
    over = @user.search_sessions.count - @limit
    return if over <= 0

    # 既存実装の意図を維持（updated_atが古い順に削除）
    @user.search_sessions.order(updated_at: :asc).limit(over).delete_all
  end
end
