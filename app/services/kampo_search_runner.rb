# app/services/kampo_search_runner.rb
class KampoSearchRunner
  attr_reader :no_condition, :results

  def initialize(disease_ids:, symptom_ids:)
    @disease_ids = Array(disease_ids).reject(&:blank?)
    @symptom_ids = Array(symptom_ids).reject(&:blank?)
    @no_condition = false
    @results = []
  end

  def call
    if @disease_ids.blank? && @symptom_ids.blank?
      @no_condition = true
      @results = []
      return self
    end

    @no_condition = false
    @results = KampoSearch.new(disease_ids: @disease_ids, symptom_ids: @symptom_ids).call
    self
  end
end
