# app/services/kampo_search.rb
class KampoSearch
  # 検索結果を扱いやすくするための小さなオブジェクト
  Result = Struct.new(
    :kampo,
    :total_score,
    :disease_score,
    :symptom_score,
    keyword_init: true
  )

  def initialize(disease_ids: [], symptom_ids: [], limit: nil)
    @disease_ids  = Array(disease_ids).reject(&:blank?).map(&:to_i)
    @symptom_ids  = Array(symptom_ids).reject(&:blank?).map(&:to_i)
    @limit        = limit
  end

  # メイン処理
  # 呼び出し方: KampoSearch.new(disease_ids: [...], symptom_ids: [...]).call
  def call
    # 条件が何もない場合は空配列を返す
    return [] if disease_ids.empty? && symptom_ids.empty?

    # 1. 中間テーブルから「選択された病名・症状」と紐づくレコードをまとめて取得
    disease_links = load_disease_links
    symptom_links = load_symptom_links

    # 2. kampo_id ごとにグルーピング
    disease_grouped = disease_links.group_by(&:kampo_id)
    symptom_grouped = symptom_links.group_by(&:kampo_id)

    # 3. どれか1つでもヒットしている漢方IDを候補とする
    kampo_ids = (disease_grouped.keys + symptom_grouped.keys).uniq
    return [] if kampo_ids.empty?

    # 4. 漢方マスタを一括取得（N+1防止）
    kampos = Kampo.where(id: kampo_ids)

    # 5. 漢方ごとにスコア計算
    results = kampos.map do |kampo|
      disease_score  = disease_score_for(kampo.id, disease_grouped)
      symptom_score  = symptom_score_for(kampo.id, symptom_grouped)
      total_score    = disease_score + symptom_score

      Result.new(
        kampo: kampo,
        total_score: total_score,
        disease_score: disease_score,
        symptom_score: symptom_score
      )
    end

    # 6. 合計スコアの降順で並び替え
    results.sort_by! { |res| -res.total_score }

    # 7. limit 指定があれば絞る（なければ全部返す）
    limit.present? ? results.first(limit) : results
  end

  private

  attr_reader :disease_ids, :symptom_ids, :limit

  # 病名リンクをまとめて取得
  def load_disease_links
    if disease_ids.any?
      KampoDisease.where(disease_id: disease_ids)
    else
      KampoDisease.none
    end
  end

  # 症状リンクをまとめて取得
  def load_symptom_links
    if symptom_ids.any?
      KampoSymptom.where(symptom_id: symptom_ids)
    else
      KampoSymptom.none
    end
  end

  # ある kampo_id に対する病名スコア
  #
  # 例：
  # 痔出血(5) + 子宮内膜症(5) = 10点
  #
  def disease_score_for(kampo_id, disease_grouped)
    Array(disease_grouped[kampo_id]).sum { |link| link.weight.to_i }
  end

  # ある kampo_id に対する症状スコア
  #
  # 仕様：
  # 今回は「症状は全部1点」なので、ヒットした件数をそのまま点数にする
  # 例：下血・過多出血症 の2つがヒット → 2点
  #
  # ※ 将来「症状にも weight を持たせる」なら、ここを sum に変えればOK
  #
  def symptom_score_for(kampo_id, symptom_grouped)
    Array(symptom_grouped[kampo_id]).size
    # weight を使うなら↓
    # Array(symptom_grouped[kampo_id]).sum { |link| link.weight.to_i }
  end
end
