# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# == MedicalArea / Disease / Symptom マスタ投入 ==========================
MEDICAL_AREA_DATA = {
  # 1. 全身症候
  "全身症候" => {
    diseases: [],
    symptoms: %w[
      口渇 浮腫 黄疸 二日酔 顔面紅潮 手足のほてり 足腰の冷え
      のぼせ 虚弱 疲労 倦怠 多汗 寝汗 発熱 微熱 肩こり 冷え
      肥満 痩せ 夏痩せ 病後 術後 体力低下 熱中症
    ]
  },


  # 2. 頭頸部
  "頭頸部" => {
    diseases: %w[
      中耳炎 扁桃腺炎 蓄膿症 慢性鼻炎 咽頭炎 喉頭炎 耳下腺炎
      顎下腺炎 リンパ節炎 耳管狭窄 アデノイド 脳卒中後遺症
      脳卒中 メニエール
    ],
    symptoms: %w[
      めまい ふらつき 耳鳴 頭痛 頭重 鼻出血 鼻づまり 鼻汁
      咽頭違和感 喉頭違和感 嗄声 喉の渇きとほてり
    ]
  },

  # 3. 血液
  "血液" => {
    diseases: [],
    symptoms: %w[貧血]
  },

  # 4. 消化器
  "消化器" => {
    diseases: %w[
      胃炎 胃アトニー 胃下垂症 胃腸カタル 腸カタル 食中毒 胃腸炎
      腸炎 潰瘍 過敏性大腸症候群 肝硬変症 肝炎 胆嚢炎 胆石
      膵臓炎 慢性膵炎 痔 キレ痔 イボ痔 痔出血
    ],
    symptoms: %w[
      胃痛 腹痛 下腹部痛 胸やけ 食道違和感 食道異物感 げっぷ
      胃酸過多 食欲不振 吐き気 悪心 胃もたれ 腹部膨満感
      しぶり腹 下痢 便秘 嘔吐 消化不良 下血
    ]
  },

  # 5. 腎 泌尿器
  "腎 泌尿器" => {
    diseases: %w[
      腎炎 ネフローゼ 慢性腎臓病 夜尿症 前立腺肥大 膀胱炎 尿道炎
      腎盂腎炎 膀胱神経症 前立腺炎 尿路結石
    ],
    symptoms: %w[
      尿量減少 浮腫 排尿困難 多尿 尿路出血 性的神経衰弱 陰萎
      排尿痛 残尿感
    ]
  },

  # 6. 眼科
  "眼科" => {
    diseases: %w[結膜炎 角膜炎 白内障],
    symptoms: %w[かすみ目 眼瞼痙攣]
  },

  # 7. 循環器
  "循環器" => {
    diseases: %w[
      高血圧 動脈硬化 狭心症 心臓弁膜症 発作性頻拍 心不全
      起立性調節障害 心臓神経症
    ],
    symptoms: %w[動悸 心悸亢進 浮腫 息切れ ふらつき]
  },

  # 8. 皮膚 膠原病
  "皮膚 膠原病" => {
    diseases: %w[
      薵麻疹 湿疹 角皮症 皮膚炎 化膿性皮膚疾患 肝斑 ざ瘡 掌蹠膿疱症
      白癬 水虫 火傷 凍傷 ベーチェット病 関節リウマチ 麻疹 水痘
      角化症 乾癬
    ],
    symptoms: %w[
      しもやけ 皮膚瘙痒 発疹 びらん 創傷 あせも しみ 手足のあれ
      いぼ にきび
    ]
  },

  # 9. 呼吸器
  "呼吸器" => {
    diseases: %w[
      感冒 鼻かぜ 上気道炎 インフルエンザ 気管支喘息 気管支炎
      喘息性気管支炎 気管支拡張症 肺炎 胸膜炎 肺気腫 肺線維症
      肺結核
    ],
    symptoms: %w[咳 痰 咽頭痛]
  },

  # 10. 歯科口腔外科
  "歯科口腔外科" => {
    diseases: %w[口内炎 舌苔 歯髄炎 歯根膜炎],
    symptoms: %w[抜歯後の疼痛 抜歯後の歯痛 歯牙痛 舌痛]
  },

  # 11. 代謝・内分泌
  "代謝・内分泌" => {
    diseases: %w[糖尿病 痛風 脚気 甲状腺機能亢進症 甲状腺炎],
    symptoms: []
  },

  # 12. 婦人科 乳腺
  "婦人科 乳腺" => {
    diseases: %w[
      月経不順 月経困難 更年期障害 不妊症 習慣性流産 乳腺炎
      リンパ腺炎 子宮並びにその付属器の炎症 子宮内膜炎
      子宮内膜症 妊娠悪阻
    ],
    symptoms: %w[
      不正出血 不正性器出血 産後出血 過多月出血 月経過多 月経不順
      月経痛 無月経
    ]
  },

  # 13. 運動器
  "運動器" => {
    diseases: %w[関節リウマチ 五十肩 頚肩腕症候群],
    symptoms: %w[
      神経痛 肋間神経痛 関節痛 腰痛 筋肉痛 下肢痛 しびれ
      筋痙攣 知覚麻痺
    ]
  },

   # 14. 精神神経
  "精神神経" => {
    diseases: %w[
      不眠 神経症 不安神経症 うつ状態 躁うつ病 健忘症 てんかん
      ヒステリー 自律神経失調 起立性調節障害 統合失調症
    ],
    symptoms: %w[いらいら ノイローゼ 神経質 精神不安 抑うつ 無気力]
  }
}.freeze

MEDICAL_AREA_DATA.each_with_index do |(area_name, defs), index|
  # MedicalArea を name で検索し、なければ作成
  area = MedicalArea.find_or_create_by!(name: area_name) do |a|
    a.display_order = index + 1
  end

  # 病名マスタ
  (defs[:diseases] || []).each do |disease_name|
    Disease.find_or_create_by!(medical_area: area, name: disease_name)
  end

  # 症状マスタ
  (defs[:symptoms] || []).each do |symptom_name|
    Symptom.find_or_create_by!(medical_area: area, name: symptom_name)
  end
end
# ======================================================================