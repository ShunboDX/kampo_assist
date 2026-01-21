module KamposHelper
  PLACEHOLDER_DETAIL_TEXT = "特記事項無し"

  def display_or_default_detail(text)
    detail_effectively_blank?(text) ? PLACEHOLDER_DETAIL_TEXT : text.to_s.strip
  end

  def detail_effectively_blank?(text)
    normalize_detail_for_presence_check(text).blank?
  end

  private

  def normalize_detail_for_presence_check(text)
    s = text.to_s.strip

    # 見出しを削除（表記ゆれに少し対応）
    s = s.gsub(/【\s*(禁忌|併用注意|慎重投与)\s*】/, "")

    # 箇条書き記号だけの行を削除
    s = s.gsub(/^\s*[・\-●]\s*$/m, "")

    # 空白を全部落として、残りがあるかで判定
    s.gsub(/\s+/, "")
  end
end
