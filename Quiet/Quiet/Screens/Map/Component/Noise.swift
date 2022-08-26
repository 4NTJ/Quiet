//
//  Noise.swift
//  Quiet
//
//  Created by DaeSeong on 2022/08/25.
//

import Foundation

struct Noise {
    let description: String
    let levelRange: String
    let markColor: String
    let examples: String
   // let listening: String // FIXME: - 추후수정

    static let sampleData: [Noise] = [
    Noise(description: "😌 수면에 영향이 없는 조용한 지역이에요",
          levelRange: "20~40dB",
          markColor: "회색⚪",
          examples: "나뭇잎 소리, 조용한 공원 등"),
    Noise(description: "🥱 조용한 도서관 정도의 소음이 있어요",
          levelRange: "40~60dB",
          markColor: "파란색🔵",
          examples: "조용한 도서관, 일반 대화 등"),
    Noise(description: "😌 수면에 영향이 없는 조용한 지역이에요",
          levelRange: "60~70dB",
          markColor: "초록색🟢",
          examples: "시끄러운 사무실, 전화벨 등"),
    Noise(description: "😌 수면에 영향이 없는 조용한 지역이에요",
          levelRange: "70~90dB",
          markColor: "노란색🟡",
          examples: "길거리, 지하철 역사 내 등"),
    Noise(description: "😱 소음이 인체에 영향을 주는 위험 지역이에요",
          levelRange: "90dB~",
          markColor: "️빨간색🔴",
          examples: "철도변, 전투기 이착륙 등")
    ]
}
