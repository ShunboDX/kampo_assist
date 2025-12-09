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
      蕁麻疹 湿疹 角皮症 皮膚炎 化膿性皮膚疾患 肝斑 ざ瘡 掌蹠膿疱症
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
      不正出血 不正性器出血 産後出血 過多出血症 月経過多 月経不順
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

# === Kampo（漢方マスタ）の seed ===
kampos = [
  {
  name: "安中散",
  kana_name: "アンチュウサン",
  note: "痩せ型で腹部筋肉が弛緩する傾向にあり，胃痛又は腹痛があって，時に胸やけ，げっぷ，食欲不振，吐き気などを伴う次の諸症状：神経性胃炎，慢性胃炎，胃アトニー",
  detail: nil
  },
  {
  name: "胃苓湯",
  kana_name: "イレイトウ",
  note: "水瀉性水様性の下痢，嘔吐があり，口渇，尿量減少を伴う次の諸症：食あたり食中毒，熱中症，冷え腹，急性胃腸炎，腹痛　［医薬品カード］慢性胃腸炎，種々の原因による浮腫，胃アトニー症，胃下垂症，腎炎，ネフローゼ",
  detail: nil
  },
  {
  name: "茵蔯蒿湯",
  kana_name: "インチンコウトウ",
  note: "尿量減少，やや便秘がちで比較的体力のあるものの次の諸症：黄疸，肝硬変症，ネフローゼ，蕁麻疹，口内炎",
  detail: nil
  },
  {
  name: "茵蔯五苓散",
  kana_name: "インチンゴレイサン",
  note: "のどが渇いて（口喝），尿量減少の次の諸症：嘔吐，蕁麻疹，二日酔のむかつき，むくみ浮腫　［医薬品カード］急・慢性肝炎，ネフローゼ，腎炎，胆嚢症，胆嚢炎，胆石症，急性胃炎，肝硬変，口内炎，下痢，めまい，頭痛",
  detail: nil
  },
  {
  name: "温経湯",
  kana_name: "ウンケイトウ",
  note: "手足のほてり，唇がかわくものの次の諸症：月経不順，月経困難，こしけ，更年期障害，不眠，神経症，湿疹，足腰の冷え，しもやけ　［医薬品カード］血の道症，進行性指掌角皮症，皮膚瘙痒(掻痒)症，不正出血，不妊症，習慣性流産，凍傷",
  detail: nil
  },
  {
  name: "温清飲",
  kana_name: "ウンセイイン",
  note: "皮膚の色つやが悪く，のぼせるものに用いる：月経不順，月経困難，血の道症，更年期障害，神経症　［医薬品カード］湿疹，口内炎，皮膚瘙痒(掻痒)症，性器出血，痔，出血尋常性乾癬，蕁麻疹，ベーチェット病",
  detail: nil
  },
  {
  name: "越婢加朮湯",
  kana_name: "エッピカジュツトウ",
  note: "浮腫と多汗と尿量減少、排尿困難のあるものの次の諸症：腎炎，ネフローゼ，脚気，関節リウマチ，夜尿症，湿疹",
  detail: nil
  },
  {
    name: "四物湯",
    kana_name: "シモツトウ",
    note: "皮膚が枯燥し，色つやの悪い体質で胃腸障害のない人の次の諸症：産後あるいは流産後の疲労回復，月経不順，冷え症，しもやけ，しみ，血の道症　［医薬品カード］更年期障害，自律神経失調症，不妊症，産後の諸症状，低血圧症，肝斑",
    detail: nil
  },

  { name: "黄耆建中湯", kana_name: "オウギケンチュウトウ", note: "身体虚弱で疲労しやすいものの次の諸症：虚弱体質，病後の衰弱，寝汗［医薬品カード］①腹痛，食欲不振，息切れなどを伴う場合　②発疹，びらんなどの皮膚症状を伴う場合　③創傷治癒の遷延化や慢性化膿巣のある場合　④腹部は腹壁が薄く，腹直筋が緊張している場合黄芩湯(オウゴントウ)下痢して，心下痞え(腹痛)，腹中拘急するもので腹直筋の攣急があり，発熱・頭痛・嘔吐・乾嘔・渇等を目標とする。適応は腸カタル，消化不良，嘔吐，下痢", detail: nil },
  { name: "黄芩湯", kana_name: "オウゴントウ", note: "下痢して，心下痞え(腹痛)，腹中拘急するもので腹直筋の攣急があり，発熱・頭痛・嘔吐・乾嘔・渇等を目標とする。適応は腸カタル，消化不良，嘔吐，下痢", detail: nil },
  { name: "黄連解毒湯", kana_name: "オウレンゲドクトウ", note: "比較的体力があり，のぼせぎみで顔色赤く，いらいらする傾向のある次の諸症：鼻出血，高血圧，不眠症，ノイローゼ，胃炎，二日酔い，血の道症，めまい，動悸，湿疹・皮膚炎，皮膚瘙痒(掻痒)症", detail: nil },
  { name: "黄連湯", kana_name: "オウレントウ", note: "胃部の停滞感（胃もたれ）や重圧感，食欲不振のあるものの次の諸症：急性胃炎，二日酔，口内炎　［医薬品カード］慢性胃炎，急・慢性胃腸炎，胃・十二指腸潰瘍，感冒性胃腸炎，胃神経症，神経症", detail: nil },
  { name: "乙字湯", kana_name: "オツジトウ", note: "症状がそれほど激しくなく，体力が中位で衰弱していないものの次の諸症：キレ痔，イボ痔．痔核、クラシエは上記の他に便秘の適応もあり", detail: nil },
  { name: "葛根湯", kana_name: "カッコントウ", note: "自然発汗がなく頭痛，発熱，悪寒，肩こり等を伴う比較的体力のあるものの次の諸症：感冒，鼻かぜ，発熱疾患の初期，炎症性疾患の初期(結膜炎，角膜炎，中耳炎，扁桃腺炎，乳腺炎，リンパ腺炎)，肩こり，上半身の神経痛，蕁麻疹．※クラシエは感冒，鼻かぜ，頭痛，肩こり，筋肉痛，手や肩の痛みのみ適応承認", detail: nil },
  { name: "葛根湯加川芎辛夷", kana_name: "カッコントウカセンキュウシンイ", note: "鼻づまり，鼻汁, 蓄膿症，慢性鼻炎", detail: nil },
  { name: "葛根加朮附湯", kana_name: "カッコンカジュツブトウ", note: "悪寒発熱して，頭痛があり，項部・肩背部に緊張感のあるものの次の諸症：肩こり，肩甲部の神経痛，上半身の関節リウマチ", detail: nil },
  { name: "加味帰脾湯", kana_name: "カミキヒトウ", note: "虚弱体質で血色の悪い人の次の諸症：貧血，不眠症，精神不安，神経症", detail: nil },
  { name: "加味逍遙散", kana_name: "カミショウヨウサン", note: "虚弱体質な女性で肩こり，易疲労感，精神不安などの精神神経症状，時に便秘の傾向のある次の諸症：冷え性，虚弱体質，月経不順，月経困難，更年期障害，血の道症", detail: nil },
  { name: "甘草湯", kana_name: "カンゾウトウ", note: "激しい咳，咽頭痛の寛解", detail: nil },
  { name: "桔梗湯", kana_name: "キキョウトウ", note: "咽喉がはれて痛む次の諸症：扁桃腺炎，扁桃周囲炎　［医薬品カード］咽頭炎、喉頭炎，咽頭違和感、喉頭違和感", detail: nil },
  { name: "帰脾湯", kana_name: "キヒトウ", note: "虚弱体質で血色の悪い人の次の諸症：貧血，不眠症　［医薬品カード］胃神経症，不安神経症，諸種出血性疾患，再生不良性貧血，うつ状態，健忘症", detail: nil },
  { name: "芎帰膠艾湯", kana_name: "キュウキキョウガイトウ", note: "冷え症で，出血過多により，貧血するもの．痔出血，外傷後の内出血，産後出血，貧血症　［医薬品カード］諸種の出血(性器出血，腎並びに尿路出血，下血など)，過多出血症，子宮内膜症", detail: nil },
  { name: "芎帰調血飲", kana_name: "キュウキチョウケツイン", note: "産後の神経症，体力低下，月経不順", detail: nil },
  { name: "九味檳榔湯", kana_name: "クミビンロウトウ", note: "心悸亢進，肩こり，倦怠感があって，便秘の傾向があるもの．脚気，高血圧，動脈硬化，及びこれらに伴う頭痛", detail: nil },
  { name: "荊芥連翹湯", kana_name: "ケイガイレンギョウトウ", note: "蓄膿症，慢性鼻炎，慢性扁桃腺炎，にきび、尋常性ざ瘡［医薬品カード］慢性副鼻腔炎，急・慢性中耳炎，慢性頸部顎下部リンパ節炎，湿疹", detail: nil },
  { name: "桂枝加黄耆湯", kana_name: "ケイシカオウギトウ", note: "体力が衰えている者の寝汗，あせも", detail: nil },
  { name: "桂枝加葛根湯", kana_name: "ケイシカカッコントウ", note: "身体虚弱体質な者の感冒の初期で肩こりや頭痛のあるもの", detail: nil },
  { name: "桂枝加厚朴杏仁湯", kana_name: "ケイシカコウボクキョウニントウ",note: "身体虚弱体質な者の咳", detail: nil },
  { name: "桂枝加朮附湯", kana_name: "ケイシカジュツブトウ",note: "冷関節痛，神経痛", detail: nil },
  { name: "桂枝加芍薬湯", kana_name: "ケイシカシャクヤクトウ",note: "腹部膨満感のある次の諸症：しぶり腹，腹痛、便秘", detail: nil },
  { name: "桂枝加芍薬大黄湯", kana_name: "ケイシカシャクヤクダイオウトウ",note: "比較的体力のない人で，腹部膨満し，腸内の停滞感あるいは腹痛などを伴うものの次の諸症1急性腸炎，大腸カタル　2常習便秘，宿便，しぶり腹", detail: nil },
  { name: "桂枝加竜骨牡蛎湯", kana_name: "ケイシカリュウコツボレイトウ",note: "下腹直腹筋に緊張のある比較的体力の衰えているものの次の諸症：小児夜尿症，神経衰弱，性的神経衰弱，遺精，陰萎(以上ツムラのみ適応承認)", detail: nil },
  { name: "桂枝加苓朮附湯", kana_name: "ケイシカリョウジュツブトウ",note: "関節痛", detail: nil },
  { name: "桂枝湯", kana_name: "ケイシトウ",note: "体力が衰えた時の感冒の初期", detail: nil },
  { name: "桂枝人参湯", kana_name: "ケイシニンジントウ",note: "胃腸の弱い人の次の諸症：頭痛，動悸，慢性胃腸炎，胃アトニー　［医薬品カード］感冒性腸炎、下痢症，胃腸炎，胃アトニー症(頭痛を伴う)", detail: nil },
  { name: "桂枝茯苓丸", kana_name: "ケイシブクリョウガン",note: "体格はしっかりしていて赤ら顔が多く，腹部は大体充実，下腹部に抵抗のあるものの次の諸症：子宮並びにその付属器の炎症，子宮内膜炎，月経不順，月経困難，帯下，更年期障害(頭痛，めまい，のぼせ，肩こり等)，冷え性，腹膜炎，打撲傷，痔疾患，精巣炎(以上ツムラのみ適応承認)．比較的体力があり，特に下腹部痛，肩こり，頭痛，めまい，のぼせて足冷え等を訴える次の諸症：月経不順，月経異常，月経痛，更年期障害，血の道症，肩こり，めまい，頭重，打撲傷，しもやけ，しみ(以上クラシエのみ適応承認)", detail: nil },
  { name: "桂枝茯苓丸加薏苡仁", kana_name: "ケイシブクリョウガンカヨクイニン",note: "比較的体力があり，ときに下腹部痛，肩こり，頭重，めまい，のぼせて足冷えなどを訴えるものの次の諸症：月経不順，血の道症，にきび，しみ，手足のあれ　［医薬品カード］①肌の荒れ，肝斑，疣贅いぼ等の皮膚症状を伴う場合　②頭痛等を伴う場合　③無月経，過多月経，月経困難症等の月経異常", detail: nil },
  { name: "桂芍知母湯", kana_name: "ケイシャクチモトウ",note: "関節痛，身体痩せ，脚部腫脹し，めまい，悪心のある者の次の諸症：神経痛，関節リウマチ", detail: nil },
  { name: "啓脾湯", kana_name: "ケイヒトウ",note: "やせて，顔色が悪く，食欲不振，下痢の傾向があるものの次の諸症：胃腸虚弱，慢性胃腸炎，消化不良，下痢　［医薬品カード］①嘔吐，腹痛などを伴う場合　②腹部が軟弱で，腹壁の緊張の弱い場合", detail: nil },
  { name: "桂麻各半湯", kana_name: "ケイマカクハントウ", note: "感冒，咳，掻痒", detail: nil },
  { name: "香蘇散", kana_name: "コウソサン",note: "胃腸虚弱で神経質の人の感冒の初期　［医薬品カード］耳管狭窄，神経症，更年期障害，慢性胃炎，蕁麻疹(魚・肉による)", detail: nil },
  { name: "五虎湯", kana_name: "ゴコトウ",note: "咳，気管支喘息　［医薬品カード］気管支炎，喘息性気管支炎，感冒，気管支拡張症", detail: nil },
  { name: "五積散", kana_name: "ゴシャクサン",note: "慢性に経過し，症状の激しくない次の諸症：胃腸炎，腰痛，神経痛，関節痛，月経痛，頭痛，冷え症，更年期障害，感冒　［医薬品カード］下腹部痛，筋肉痛，関節リウマチ，月経困難症，月経不順", detail: nil },
  { name: "柴陥湯", kana_name: "サイカントウ",note: "咳，咳による胸痛　［医薬品カード］急・慢性気管支炎，感冒，肺炎，胸膜炎，気管支喘息，気管支拡張症", detail: nil },
  { name: "柴胡加竜骨牡蛎湯", kana_name: "サイコカリュウコツボレイトウ",note: "比較的体力があり，心悸亢進，動悸、不眠，いらだち、いらいらなどの精神症状のあるものの次の諸症：高血圧症，動脈硬化症，慢性腎臓病，神経衰弱症，神経性心悸亢進症，てんかん，ヒステリー，小児夜啼症，陰萎(以上ツムラのみ適応承認)．精神不安があって，動悸，不眠等を伴う次の諸症：高血圧の随伴症状(動悸，不安，不眠)，神経症，更年期神経症，小児夜泣き(以上クラシエのみ適応承認)", detail: nil },
  { name: "柴胡桂枝湯", kana_name: "サイコケイシトウ",note: "熱，発汗，悪寒し，身体痛み，頭痛，吐き気のあるものの次の諸症：感冒・流感・肺炎・肺結核等の熱性疾患，胃潰瘍・十二指腸潰瘍・胆嚢炎・胆石・肝機能障害・膵臓炎等の心下部緊張疼痛(以上ツムラのみ適応承認)，多くは腹痛を伴う胃腸炎，微熱・寒気・頭痛・吐き気等のある感冒，感冒の後期の症状(以上クラシエのみ適応承認)", detail: nil },
  { name: "柴胡桂枝乾姜湯", kana_name: "サイコケイシカンキョウトウ",note: "体力が弱く，冷え性，貧血気味で，動悸，息切れがあり，神経過敏のものの次の諸症：更年期障害，血の道症，神経症，不眠症", detail: nil },
  { name: "柴胡清肝湯", kana_name: "サイコセイカントウ",note: "かんの強い傾向のある小児の次の諸症：神経症，慢性扁桃腺炎，湿疹　［医薬品カード］再発性扁桃腺炎，頸部顎下部リンパ腺炎，アデノイド，咽・喉頭炎，虚弱児童の体質改善", detail: nil },
  { name: "柴朴湯", kana_name: "サイボクトウ",note: "気分がふさいで，抑うつ、咽喉，食道異物感、食道違和感があり，時に動悸，めまい，嘔気などを伴う次の諸症：小児ぜんそく，気管支喘息，気管支炎，咳，不安神経症　［医薬品カード］感冒，慢性胃炎，咽・喉頭神経症，食道神経症，胃神経症，過敏性大腸症候群，胸膜炎・肺結核等の補助療法，慢性リンパ腺炎，虚弱児の体質改善", detail: nil },
  { name: "柴苓湯", kana_name: "サイレイトウ",note: "吐き気，食欲不振，のどのかわき，尿量減少などの次の諸症：水瀉性下痢，急性胃腸炎，熱中症，むくみ浮腫　［医薬品カード］胃炎，ネフローゼ，慢性肝炎，肝硬変，慢性胃腸炎，胃腸型感冒，胃アトニー症，胃下垂症，腎盂腎炎，メニエール症候群", detail: nil },
  { name: "三黄瀉心湯", kana_name: "サンオウシャシントウ",note: "比較的体力があり，のぼせ気味で，顔面紅潮し，精神不安で，便秘の傾向のあるものの次の諸症：高血圧の随伴症状(のぼせ，肩こり，耳鳴，頭重，不眠，不安)，鼻血，痔出血，便秘，更年期障害，血の道症　［医薬品カード］高血圧症，動脈硬化症，諸種の出血(吐血等)，不安神経症，自律神経失調症，口内炎，胃炎，宿酔，湿疹，蕁麻疹", detail: nil },
  { name: "酸棗仁湯", kana_name: "サンソウニントウ",note: "心身が疲れ弱って眠れないもの　［医薬品カード］不眠症，神経症，嗜眠，自律神経失調症", detail: nil },
  { name: "三物黄芩湯", kana_name: "サンモツオウゴントウ",note: "手足のほてり　［医薬品カード］湿疹，進行性指掌角皮症，掌蹠膿疱症，掌蹠熱感，不眠症，更年期障害，高血圧，頭痛，汗疱状白癬", detail: nil },
  { name: "滋陰降火湯", kana_name: "ジインコウカトウ",note: "のどにうるおいがなく痰の出なくて咳こむもの　［医薬品カード］急・慢性気管支炎，上気道炎，気管支喘息，肺結核，喉頭炎(嗄声)", detail: nil },
  { name: "滋陰至宝湯", kana_name: "ジインシホウトウ",note: "虚弱なものの慢性の咳・痰　［医薬品カード］急・慢性気管支炎，上気道炎，気管支拡張症，気管支喘息，肺結核，肺気腫，肺線維症", detail: nil },
  { name: "紫雲膏", kana_name: "シウンコウ",note: "火傷，痔核による疼痛，肛門裂傷", detail: nil },
  { name: "四逆散", kana_name: "シギャクサン",note: "比較的体力のある人で，大柴胡湯証と小柴胡湯証と中間証を表すものの次の諸症：胆嚢炎，胆石症，胃炎，胃酸過多，胃潰瘍，鼻カタル，気管支炎，神経質，ヒステリー", detail: nil },
  { name: "四君子湯", kana_name: "シクンシトウ",note: "やせて顔色が悪くて，食欲がなく，疲れやすいものの次の諸症：胃腸虚弱，慢性胃炎，胃のもたれ，嘔吐，下痢　［医薬品カード］胃炎，胃・十二指腸潰瘍，慢性胃腸炎，胃アトニー症，胃下垂症，慢性消耗性疾患，術後の胃腸障害", detail: nil },
  { name: "梔子柏皮湯", kana_name: "シシハクヒトウ",note: "肝臓部に圧迫感があるもの．黄疸，皮膚瘙痒(掻痒)症，宿酔", detail: nil },
  { name: "七物降下湯", kana_name: "シチモツコウカトウ",note: "体質虚弱の傾向のあるものの次の諸症：高血圧に伴う随伴症状(のぼせ，肩こり，耳鳴，頭重)", detail: nil },
  # === 追記ここまで ===

]

kampos.each do |attrs|
  Kampo.find_or_create_by!(name: attrs[:name]) do |kampo|
    kampo.kana_name = attrs[:kana_name]
    kampo.note      = attrs[:note]
    kampo.detail    = attrs[:detail]
  end
end

# === Kampo と Disease / Symptom を結びつける設定 ===
kampo_links = {
  "四物湯" => {
    diseases: [
      { name: "月経不順", weight: 5 },
      { name: "更年期障害", weight: 5 }, 
      { name: "自律神経失調", weight: 5 },
      { name: "不妊症", weight: 5 },
      { name: "肝斑", weight: 5 },
    ],
    symptoms: [
      { name: "冷え", weight: 1 },
      { name: "しもやけ", weight: 1 },
      { name: "しみ", weight: 1 },
    ]
  },
  
  "安中散" => {
    diseases: [
      { name: "胃炎", weight: 5 },
      { name: "胃アトニー", weight: 5 },
    ],
    symptoms: [
      { name: "胃痛", weight: 1 },
      { name: "腹痛", weight: 1 },
      { name: "胸やけ", weight: 1 },
      { name: "げっぷ", weight: 1 },
      { name: "食欲不振", weight: 1 },
      { name: "吐き気", weight: 1 },
    ]
  },

  "胃苓湯" => {
    diseases: [
      { name: "食中毒", weight: 5 },
      { name: "胃腸炎", weight: 5 },
      { name: "胃アトニー", weight: 5 },
      { name: "胃下垂症", weight: 5 },
      { name: "腎炎", weight: 5 },
      { name: "ネフローゼ", weight: 5 },
    ],
    symptoms: [
      { name: "下痢", weight: 1 },
      { name: "嘔吐", weight: 1 },
      { name: "口渇", weight: 1 },
      { name: "尿量減少", weight: 1 },
      { name: "腹痛", weight: 1 },
      { name: "浮腫", weight: 1 },
      { name: "熱中症", weight: 1 },
      { name: "冷え", weight: 1 },
    ]
  },

  "茵蔯蒿湯" => {
    diseases: [
      { name: "肝硬変症", weight: 5 },
      { name: "ネフローゼ", weight: 5 },
      { name: "蕁麻疹", weight: 5 },
      { name: "口内炎", weight: 5 },
    ],
    symptoms: [
      { name: "尿量減少", weight: 1 },
      { name: "便秘", weight: 1 },
      { name: "黄疸", weight: 1 },
    ]
  },

  "茵蔯五苓散" => {
    diseases: [
      { name: "蕁麻疹", weight: 5 },
      { name: "肝炎", weight: 5 },
      { name: "ネフローゼ", weight: 5 },
      { name: "腎炎", weight: 5 },
      { name: "胆嚢炎", weight: 5 },
      { name: "胃炎", weight: 5 },
      { name: "肝硬変症", weight: 5 },
      { name: "口内炎", weight: 5 },
    ],
    symptoms: [
      { name: "口渇", weight: 1 },
      { name: "尿量減少", weight: 1 },
      { name: "嘔吐", weight: 1 },
      { name: "二日酔", weight: 1 },
      { name: "浮腫", weight: 1 },
      { name: "下痢", weight: 1 },
      { name: "めまい", weight: 1 },
      { name: "頭痛", weight: 1 },
    ]
  },

  "温経湯" => {
    diseases: [
      { name: "月経不順", weight: 5 },
      { name: "月経困難", weight: 5 },
      { name: "更年期障害", weight: 5 },
      { name: "不妊症", weight: 5 },
      { name: "神経症", weight: 5 },
      { name: "湿疹", weight: 5 },
      { name: "角皮症", weight: 5 },
      { name: "習慣性流産", weight: 5 },
      { name: "凍傷", weight: 5 },
    ],
    symptoms: [
      { name: "手足のほてり", weight: 1 },
      { name: "足腰の冷え", weight: 1 },
      { name: "しもやけ", weight: 1 },
      { name: "皮膚瘙痒", weight: 1 },
      { name: "不正出血", weight: 1 },
    ]
  },

  "温清飲" => {
    diseases: [
      { name: "月経不順", weight: 5 },
      { name: "月経困難", weight: 5 },
      { name: "更年期障害", weight: 5 },
      { name: "神経症", weight: 5 },
      { name: "湿疹", weight: 5 },
      { name: "口内炎", weight: 5 },
      { name: "痔", weight: 5 },
      { name: "蕁麻疹", weight: 5 },
      { name: "ベーチェット病", weight: 5 },
    ],
    symptoms: [
      { name: "のぼせ", weight: 1 },
      { name: "皮膚瘙痒", weight: 1 },
      { name: "不正性器出血", weight: 1 },
    ]
  },

  "越婢加朮湯" => {
    diseases: [
      { name: "腎炎", weight: 5 },
      { name: "ネフローゼ", weight: 5 },
      { name: "脚気", weight: 5 },
      { name: "関節リウマチ", weight: 5 },
      { name: "夜尿症", weight: 5 },
      { name: "麻疹", weight: 5 },
    ],
    symptoms: [
      { name: "浮腫", weight: 1 },
      { name: "多汗", weight: 1 },
      { name: "尿量減少", weight: 1 },
      { name: "排尿困難", weight: 1 },
    ]
  },

  "黄耆建中湯" => {
    diseases: [],
    symptoms: [
      { name: "虚弱",     weight: 1 },
      { name: "病後",     weight: 1 },
      { name: "寝汗",     weight: 1 },
      { name: "腹痛",     weight: 1 },
      { name: "食欲不振", weight: 1 },
      { name: "息切れ",   weight: 1 },
      { name: "発疹",     weight: 1 },
      { name: "びらん",   weight: 1 },
      { name: "創傷",     weight: 1 },
    ]
  },

  "黄芩湯" => {
    diseases: [
      { name: "胃腸炎", weight: 5 },
      { name: "口内炎", weight: 5 },
      { name: "胃炎",   weight: 5 },
      { name: "潰瘍",   weight: 5 },
      { name: "神経症", weight: 5 },
    ],
    symptoms: [
      { name: "胃もたれ", weight: 1 },
      { name: "食欲不振", weight: 1 },
      { name: "二日酔",   weight: 1 },
    ]
  },

  "黄連解毒湯" => {
    diseases: [
      { name: "高血圧", weight: 5 },
      { name: "不眠",   weight: 5 },
      { name: "胃炎",   weight: 5 },
      { name: "湿疹",   weight: 5 },
      { name: "皮膚炎", weight: 5 },
    ],
    symptoms: [
      { name: "のぼせ",     weight: 1 },
      { name: "いらいら",   weight: 1 },
      { name: "鼻出血",     weight: 1 },
      { name: "ノイローゼ", weight: 1 },
      { name: "二日酔",     weight: 1 },
      { name: "めまい",     weight: 1 },
      { name: "動悸",       weight: 1 },
      { name: "皮膚瘙痒",   weight: 1 },
    ]
  },

  "黄連湯" => {
    diseases: [
      { name: "胃炎",   weight: 5 },
      { name: "口内炎", weight: 5 },
      { name: "胃腸炎", weight: 5 },
      { name: "潰瘍",   weight: 5 },
      { name: "神経症", weight: 5 },
    ],
    symptoms: [
      { name: "胃もたれ", weight: 1 },
      { name: "食欲不振", weight: 1 },
      { name: "二日酔",   weight: 1 },
    ]
  },

  "乙字湯" => {
    diseases: [
      { name: "痔",    weight: 5 },
      { name: "キレ痔", weight: 5 },
      { name: "イボ痔", weight: 5 },
    ],
    symptoms: [
      { name: "便秘", weight: 1 },
    ]
  },

  "葛根湯" => {
    diseases: [
      { name: "感冒",     weight: 5 },
      { name: "鼻かぜ",   weight: 5 },
      { name: "結膜炎",   weight: 5 },
      { name: "角膜炎",   weight: 5 },
      { name: "中耳炎",   weight: 5 },
      { name: "扁桃腺炎", weight: 5 },
      { name: "乳腺炎",   weight: 5 },
      { name: "リンパ腺炎", weight: 5 },
      { name: "蕁麻疹",   weight: 5 },
    ],
    symptoms: [
      { name: "頭痛",   weight: 1 },
      { name: "発熱",   weight: 1 },
      { name: "肩こり", weight: 1 },
      { name: "神経痛", weight: 1 },
      { name: "筋肉痛", weight: 1 },
    ]
  },

  "葛根湯加川芎辛夷" => {
    diseases: [
      { name: "蓄膿症",   weight: 5 },
      { name: "慢性鼻炎", weight: 5 },
    ],
    symptoms: [
      { name: "鼻づまり", weight: 1 },
      { name: "鼻汁",     weight: 1 },
    ]
  },

  "葛根加朮附湯" => {
    diseases: [
      { name: "関節リウマチ", weight: 5 },
    ],
    symptoms: [
      { name: "発熱",   weight: 1 },
      { name: "頭痛",   weight: 1 },
      { name: "肩こり", weight: 1 },
      { name: "神経痛", weight: 1 },
    ]
  },

  "加味帰脾湯" => {
    diseases: [
      { name: "不眠",       weight: 5 },
      { name: "不安神経症", weight: 5 },
      { name: "神経症",     weight: 5 },
    ],
    symptoms: [
      { name: "貧血", weight: 1 },
    ]
  },

  "加味逍遙散" => {
    diseases: [
      { name: "神経症",     weight: 5 },
      { name: "月経不順",   weight: 5 },
      { name: "月経困難",   weight: 5 },
      { name: "更年期障害", weight: 5 },
    ],
    symptoms: [
      { name: "肩こり", weight: 1 },
      { name: "疲労",   weight: 1 },
      { name: "冷え",   weight: 1 },
      { name: "虚弱",   weight: 1 },
    ]
  },

  "甘草湯" => {
    diseases: [],
    symptoms: [
      { name: "咳",     weight: 1 },
      { name: "咽頭痛", weight: 1 },
    ]
  },

  "桔梗湯" => {
    diseases: [
      { name: "扁桃腺炎", weight: 5 },
      { name: "咽頭炎",   weight: 5 },
      { name: "喉頭炎",   weight: 5 },
    ],
    symptoms: [
      { name: "咽頭違和感", weight: 1 },
      { name: "喉頭違和感", weight: 1 },
    ]
  },

  "帰脾湯" => {
    diseases: [
      { name: "不眠",       weight: 5 },
      { name: "痔出血",     weight: 5 },
      { name: "神経症",     weight: 5 },
      { name: "不安神経症", weight: 5 },
      { name: "うつ状態",   weight: 5 },
      { name: "健忘症",     weight: 5 },
      { name: "子宮内膜症", weight: 5 },
    ],
    symptoms: [
      { name: "貧血",       weight: 1 },
      { name: "鼻出血",     weight: 1 },
      { name: "尿路出血",   weight: 1 },
      { name: "不正出血",   weight: 1 },
      { name: "不正性器出血", weight: 1 },
      { name: "産後出血",   weight: 1 },
      { name: "過多出血症", weight: 1 },
      { name: "冷え",       weight: 1 },
      { name: "下血",       weight: 1 },
      { name: "月経不順",   weight: 1 },
      { name: "体力低下",   weight: 1 },
    ]
  },

  "芎帰膠艾湯" => {
    diseases: [
      { name: "痔出血",   weight: 5 },
      { name: "子宮内膜症", weight: 5 },
      { name: "神経症", weight: 5 },
    ],
    symptoms: [
      { name: "貧血", weight: 1 },
      { name: "冷え", weight: 1 },
      { name: "産後出血", weight: 1 },
      { name: "尿路出血", weight: 1 },
      { name: "過多出血症", weight: 1 },
      { name: "体力低下", weight: 1 },
    ]
  },

  "芎帰調血飲" => {
    diseases: [
      { name: "神経症",   weight: 5 },
      { name: "月経不順", weight: 5 },
    ],
    symptoms: [
      { name: "体力低下", weight: 1 },
    ]
  },

  "九味檳榔湯" => {
    diseases: [
      { name: "脚気",   weight: 5 },
      { name: "高血圧", weight: 5 },
      { name: "動脈硬化", weight: 5 },
    ],
    symptoms: [
      { name: "心悸亢進", weight: 1 },
      { name: "肩こり",   weight: 1 },
      { name: "便秘",     weight: 1 },
    ]
  },

  "荊芥連翹湯" => {
    diseases: [
      { name: "蓄膿症",   weight: 5 },
      { name: "慢性鼻炎", weight: 5 },
      { name: "扁桃腺炎", weight: 5 },
      { name: "ざ瘡",     weight: 5 },
      { name: "中耳炎",   weight: 5 },
      { name: "リンパ節炎", weight: 5 },
      { name: "湿疹",     weight: 5 },
    ],
    symptoms: [
      { name: "にきび", weight: 1 },
    ]
  },

  "桂枝加黄耆湯" => {
    diseases: [],
    symptoms: [
      { name: "寝汗", weight: 1 },
      { name: "あせも", weight: 1 },
    ]
  },

  "桂枝加葛根湯" => {
    diseases: [],
    symptoms: [
      { name: "肩こり", weight: 1 },
      { name: "頭痛",   weight: 1 },
    ]
  },

  "桂枝加厚朴杏仁湯" => {
    diseases: [],
    symptoms: [
      { name: "咳", weight: 1 },
    ]
  },

  "桂枝加朮附湯" => {
    diseases: [],
    symptoms: [
      { name: "関節痛", weight: 1 },
      { name: "神経痛", weight: 1 },
    ]
  },

  "桂枝加芍薬湯" => {
    diseases: [],
    symptoms: [
      { name: "腹痛",     weight: 1 },
      { name: "しぶり腹", weight: 1 },
      { name: "便秘",     weight: 1 },
    ]
  },

  "桂枝加芍薬大黄湯" => {
    diseases: [
      { name: "腸炎",     weight: 5 },
      { name: "腸カタル", weight: 5 },
    ],
    symptoms: [
      { name: "腹部膨満感", weight: 1 },
      { name: "しぶり腹",   weight: 1 },
      { name: "便秘",       weight: 1 },
    ]
  },

  "桂枝加竜骨牡蛎湯" => {
    diseases: [
      { name: "夜尿症", weight: 5 },
    ],
    symptoms: [
      { name: "性的神経衰弱", weight: 1 },
      { name: "陰萎",         weight: 1 },
    ]
  },

  "桂枝加苓朮附湯" => {
    diseases: [],
    symptoms: [
      { name: "関節痛", weight: 1 },
    ]
  },

  "桂枝湯" => {
    diseases: [
      { name: "感冒", weight: 5 },
    ],
    symptoms: []
  },

  "桂枝人参湯" => {
    diseases: [
      { name: "胃腸炎",   weight: 5 },
      { name: "胃アトニー", weight: 5 },
      { name: "感冒",     weight: 5 },
      { name: "腸炎",     weight: 5 },
    ],
    symptoms: [
      { name: "頭痛", weight: 1 },
      { name: "動悸", weight: 1 },
      { name: "下痢", weight: 1 },
    ]
  },

  "桂枝茯苓丸" => {
    diseases: [
      { name: "子宮並びにその付属器の炎症", weight: 5 },
      { name: "子宮内膜炎",               weight: 5 },
      { name: "月経不順",                 weight: 5 },
      { name: "月経困難",                 weight: 5 },
      { name: "更年期障害",               weight: 5 },
      { name: "痔",                       weight: 5 },
    ],
    symptoms: [
      { name: "冷え",       weight: 1 },
      { name: "下腹部痛",   weight: 1 },
      { name: "肩こり",     weight: 1 },
      { name: "頭痛",       weight: 1 },
      { name: "めまい",     weight: 1 },
      { name: "月経痛",     weight: 1 },
      { name: "しもやけ",   weight: 1 },
      { name: "しみ",       weight: 1 },
    ]
  },

  "桂枝茯苓丸加薏苡仁" => {
    diseases: [
      { name: "月経不順", weight: 5 },
      { name: "肝斑",     weight: 5 },
      { name: "月経困難", weight: 5 },
    ],
    symptoms: [
      { name: "下腹部痛",   weight: 1 },
      { name: "肩こり",     weight: 1 },
      { name: "頭重",       weight: 1 },
      { name: "めまい",     weight: 1 },
      { name: "にきび",     weight: 1 },
      { name: "しみ",       weight: 1 },
      { name: "手足のあれ", weight: 1 },
      { name: "月経過多",   weight: 1 },
    ]
  },

  "桂芍知母湯" => {
    diseases: [
      { name: "関節リウマチ", weight: 5 },
    ],
    symptoms: [
      { name: "関節痛", weight: 1 },
      { name: "痩せ",   weight: 1 },
      { name: "めまい", weight: 1 },
      { name: "神経痛", weight: 1 },
    ]
  },

  "啓脾湯" => {
    diseases: [
      { name: "胃腸炎", weight: 5 },
    ],
    symptoms: [
      { name: "消化不良", weight: 1 },
      { name: "下痢",     weight: 1 },
      { name: "嘔吐",     weight: 1 },
    ]
  },

  "桂麻各半湯" => {
    diseases: [
      { name: "感冒", weight: 5 },
    ],
    symptoms: [
      { name: "咳", weight: 1 },
    ]
  },

  "香蘇散" => {
    diseases: [
      { name: "感冒",     weight: 5 },
      { name: "耳管狭窄", weight: 5 },
      { name: "神経症",   weight: 5 },
      { name: "更年期障害", weight: 5 },
      { name: "胃炎",     weight: 5 },
      { name: "蕁麻疹",   weight: 5 },
    ],
    symptoms: []
  },

  "五虎湯" => {
    diseases: [
      { name: "気管支喘息",     weight: 5 },
      { name: "気管支炎",       weight: 5 },
      { name: "喘息性気管支炎", weight: 5 },
      { name: "感冒",           weight: 5 },
      { name: "気管支拡張症",   weight: 5 },
    ],
    symptoms: [
      { name: "咳", weight: 1 },
    ]
  },

  "五積散" => {
    diseases: [
      { name: "胃腸炎",     weight: 5 },
      { name: "更年期障害", weight: 5 },
      { name: "感冒",       weight: 5 },
      { name: "関節リウマチ", weight: 5 },
      { name: "月経困難",   weight: 5 },
      { name: "月経不順",   weight: 5 },
    ],
    symptoms: [
      { name: "腰痛",     weight: 1 },
      { name: "神経痛",   weight: 1 },
      { name: "関節痛",   weight: 1 },
      { name: "月経痛",   weight: 1 },
      { name: "頭痛",     weight: 1 },
      { name: "冷え",     weight: 1 },
      { name: "下腹部痛", weight: 1 },
      { name: "筋肉痛",   weight: 1 },
    ]
  },
  
  "柴陥湯" => {
    diseases: [
      { name: "気管支炎",     weight: 5 },
      { name: "感冒",         weight: 5 },
      { name: "肺炎",         weight: 5 },
      { name: "胸膜炎",       weight: 5 },
      { name: "気管支喘息",   weight: 5 },
      { name: "気管支拡張症", weight: 5 },
    ],
    symptoms: [
      { name: "咳", weight: 1 },
    ]
  },

  "柴胡加竜骨牡蛎湯" => {
    diseases: [
      { name: "高血圧",     weight: 5 },
      { name: "動脈硬化",   weight: 5 },
      { name: "慢性腎臓病", weight: 5 },
      { name: "てんかん",   weight: 5 },
      { name: "ヒステリー", weight: 5 },
      { name: "不眠",       weight: 5 },
      { name: "神経症",     weight: 5 },
      { name: "更年期障害", weight: 5 },
    ],
    symptoms: [
      { name: "心悸亢進", weight: 1 },
      { name: "動悸",     weight: 1 },
      { name: "陰萎",     weight: 1 },
      { name: "精神不安", weight: 1 },
    ]
  },

  "柴胡桂枝湯" => {
    diseases: [
      { name: "感冒",     weight: 5 },
      { name: "肺炎",     weight: 5 },
      { name: "肺結核",   weight: 5 },
      { name: "潰瘍",     weight: 5 },
      { name: "胆嚢炎",   weight: 5 },
      { name: "胆石",     weight: 5 },
      { name: "膵臓炎",   weight: 5 },
      { name: "胃腸炎",   weight: 5 },
    ],
    symptoms: [
      { name: "発熱",   weight: 1 },
      { name: "頭痛",   weight: 1 },
      { name: "吐き気", weight: 1 },
      { name: "微熱",   weight: 1 },
    ]
  },

  "柴胡桂枝乾姜湯" => {
    diseases: [
      { name: "更年期障害", weight: 5 },
      { name: "神経症",     weight: 5 },
      { name: "不眠",       weight: 5 },
    ],
    symptoms: [
      { name: "冷え",   weight: 1 },
      { name: "貧血",   weight: 1 },
      { name: "動悸",   weight: 1 },
      { name: "息切れ", weight: 1 },
    ]
  },

  "柴胡清肝湯" => {
    diseases: [
      { name: "神経症",     weight: 5 },
      { name: "扁桃腺炎",   weight: 5 },
      { name: "湿疹",       weight: 5 },
      { name: "リンパ腺炎", weight: 5 },
      { name: "アデノイド", weight: 5 },
      { name: "咽頭炎",     weight: 5 },
      { name: "喉頭炎",     weight: 5 },
    ],
    symptoms: [
      { name: "虚弱", weight: 1 },
    ]
  },

  "柴朴湯" => {
    diseases: [
      { name: "気管支喘息",           weight: 5 },
      { name: "気管支炎",             weight: 5 },
      { name: "不安神経症",           weight: 5 },
      { name: "感冒",                 weight: 5 },
      { name: "胃炎",                 weight: 5 },
      { name: "神経症",               weight: 5 },
      { name: "過敏性大腸症候群",     weight: 5 },
      { name: "胸膜炎",               weight: 5 },
      { name: "肺結核",               weight: 5 },
      { name: "リンパ腺炎",           weight: 5 },
    ],
    symptoms: [
      { name: "抑うつ",       weight: 1 },
      { name: "食道異物感",   weight: 1 },
      { name: "食道違和感",   weight: 1 },
      { name: "動悸",         weight: 1 },
      { name: "めまい",       weight: 1 },
      { name: "咳",           weight: 1 },
    ]
  },

  "柴苓湯" => {
    diseases: [
      { name: "胃腸炎",   weight: 5 },
      { name: "胃炎",     weight: 5 },
      { name: "ネフローゼ", weight: 5 },
      { name: "肺炎",     weight: 5 },
      { name: "肝硬変症", weight: 5 },
      { name: "感冒",     weight: 5 },
      { name: "胃アトニー", weight: 5 },
      { name: "胃下垂症", weight: 5 },
      { name: "腎炎",     weight: 5 },
      { name: "メニエール", weight: 5 },
    ],
    symptoms: [
      { name: "吐き気",             weight: 1 },
      { name: "食欲不振",           weight: 1 },
      { name: "喉の渇きとほてり",   weight: 1 },
      { name: "尿量減少",           weight: 1 },
      { name: "下痢",               weight: 1 },
      { name: "熱中症",             weight: 1 },
      { name: "浮腫",               weight: 1 },
    ]
  },

  "三黄瀉心湯" => {
    diseases: [
      { name: "高血圧",         weight: 5 },
      { name: "不眠",           weight: 5 },
      { name: "痔出血",         weight: 5 },
      { name: "更年期障害",     weight: 5 },
      { name: "動脈硬化",       weight: 5 },
      { name: "不安神経症",     weight: 5 },
      { name: "自律神経失調",   weight: 5 },
      { name: "口内炎",         weight: 5 },
      { name: "胃炎",           weight: 5 },
      { name: "湿疹",           weight: 5 },
      { name: "蕁麻疹",         weight: 5 },
    ],
    symptoms: [
      { name: "のぼせ",     weight: 1 },
      { name: "顔面紅潮",   weight: 1 },
      { name: "精神不安",   weight: 1 },
      { name: "便秘",       weight: 1 },
      { name: "肩こり",     weight: 1 },
      { name: "耳鳴",       weight: 1 },
      { name: "頭痛",       weight: 1 },
    ]
  },

  "酸棗仁湯" => {
    diseases: [
      { name: "不眠",           weight: 5 },
      { name: "神経症",         weight: 5 },
      { name: "自律神経失調",   weight: 5 },
    ],
    symptoms: []
  },

  "三物黄芩湯" => {
    diseases: [
      { name: "湿疹",             weight: 5 },
      { name: "角皮症",           weight: 5 },
      { name: "掌蹠膿疱症",       weight: 5 },
      { name: "不眠",             weight: 5 },
      { name: "更年期障害",       weight: 5 },
      { name: "高血圧",           weight: 5 },
      { name: "白癬",             weight: 5 },
    ],
    symptoms: [
      { name: "手足のほてり", weight: 1 },
      { name: "頭痛",         weight: 1 },
    ]
  },

  "滋陰降火湯" => {
    diseases: [
      { name: "気管支炎",     weight: 5 },
      { name: "上気道炎",     weight: 5 },
      { name: "気管支喘息",   weight: 5 },
      { name: "肺結核",       weight: 5 },
      { name: "喉頭炎",       weight: 5 },
    ],
    symptoms: [
      { name: "咳", weight: 1 },
    ]
  },

  "滋陰至宝湯" => {
    diseases: [
      { name: "気管支炎",       weight: 5 },
      { name: "上気道炎",       weight: 5 },
      { name: "気管支拡張症",   weight: 5 },
      { name: "気管支喘息",     weight: 5 },
      { name: "肺結核",         weight: 5 },
      { name: "肺気腫",         weight: 5 },
      { name: "肺線維症",       weight: 5 },
    ],
    symptoms: [
      { name: "咳", weight: 1 },
      { name: "痰", weight: 1 },
    ]
  },

  "紫雲膏" => {
    diseases: [
      { name: "火傷", weight: 5 },
    ],
    symptoms: []
  },

  "四逆散" => {
    diseases: [
      { name: "胆嚢炎",   weight: 5 },
      { name: "胆石",     weight: 5 },
      { name: "胃炎",     weight: 5 },
      { name: "潰瘍",     weight: 5 },
      { name: "気管支炎", weight: 5 },
      { name: "ヒステリー", weight: 5 },
    ],
    symptoms: [
      { name: "胃酸過多", weight: 1 },
      { name: "神経質",   weight: 1 },
    ]
  },

  "四君子湯" => {
    diseases: [
      { name: "胃炎",     weight: 5 },
      { name: "潰瘍",     weight: 5 },
      { name: "胃腸炎",   weight: 5 },
      { name: "胃アトニー", weight: 5 },
      { name: "胃下垂症", weight: 5 },
    ],
    symptoms: [
      { name: "痩せ",       weight: 1 },
      { name: "食欲不振",   weight: 1 },
      { name: "胃もたれ",   weight: 1 },
      { name: "嘔吐",       weight: 1 },
      { name: "下痢",       weight: 1 },
    ]
  },

  "梔子柏皮湯" => {
    diseases: [],
    symptoms: [
      { name: "黄疸",     weight: 1 },
      { name: "皮膚瘙痒", weight: 1 },
    ]
  },

  "七物降下湯" => {
    diseases: [
      { name: "高血圧", weight: 5 },
    ],
    symptoms: [
      { name: "虚弱",   weight: 1 },
      { name: "のぼせ", weight: 1 },
      { name: "肩こり", weight: 1 },
      { name: "耳鳴",   weight: 1 },
      { name: "頭重",   weight: 1 },
    ]
  },
  # === 追記ここまで ===
  # "〇〇湯" => {
  #   diseases: [...],
  #   symptoms: [...]
  # },
}

kampo_links.each do |kampo_name, links|
  # 1) 漢方を名前で取得
  kampo = Kampo.find_by!(name: kampo_name)

  # 2) 病名との関連付け（KampoDisease）
  Array(links[:diseases]).each do |d|
    disease = Disease.find_by(name: d[:name])

    unless disease
      puts "==== Disease NOT FOUND ===="
      puts "  kampo: #{kampo_name}"
      puts "  disease name: #{d[:name].inspect}"
      raise ActiveRecord::RecordNotFound, "Disease not found: #{d[:name]}"
    end

    KampoDisease.find_or_create_by!(kampo:, disease:) do |kd|
      kd.weight = d[:weight]
    end
  end

  # 3) 症状との関連付け（KampoSymptom）
  Array(links[:symptoms]).each do |s|
    symptom = Symptom.find_by(name: s[:name])

    unless symptom
      puts "==== Symptom NOT FOUND ===="
      puts "  kampo: #{kampo_name}"
      puts "  symptom name: #{s[:name].inspect}"
      raise ActiveRecord::RecordNotFound, "Symptom not found: #{s[:name]}"
    end

    KampoSymptom.find_or_create_by!(kampo:, symptom:) do |ks|
      ks.weight = s[:weight]
    end
  end
end