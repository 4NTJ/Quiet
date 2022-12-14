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
    let soundName: String 

    static let sampleData: [Noise] = [
    Noise(description: "π μλ©΄μ μν₯μ΄ μλ μ‘°μ©ν μ§μ­μ΄μμ",
          levelRange: "20~40dB",
          markColor: "νμβͺ",
          examples: "λλ­μ μλ¦¬, μ‘°μ©ν κ³΅μ λ±",
          soundName: "Gray"),
    Noise(description: "π₯± μ‘°μ©ν λμκ΄ μ λμ μμμ΄ μμ΄μ",
          levelRange: "40~60dB",
          markColor: "νλμπ΅",
          examples: "μ‘°μ©ν λμκ΄, μΌλ° λν λ±",
          soundName: "Blue"),
    Noise(description: "βπ μλλ¬μ΄ μ¬λ¬΄μ€ μ λμ μμμ΄ μμ΄μβ",
          levelRange: "60~70dB",
          markColor: "μ΄λ‘μπ’",
          examples: "μλλ¬μ΄ μ¬λ¬΄μ€, μ νλ²¨ λ±",
          soundName: "Green"),
    Noise(description: "βπ¨ κ³΅μ¬μ₯λ§νΌ μλλ¬μΈ κ°λ₯μ±μ΄ μμ΄μβ",
          levelRange: "70~90dB",
          markColor: "λΈλμπ‘",
          examples: "κΈΈκ±°λ¦¬, μ§νμ²  μ­μ¬ λ΄ λ±",
          soundName: "Yellow"),
    Noise(description: "βπ± μμμ΄ μΈμ²΄μ μν₯μ μ£Όλ μν μ§μ­μ΄μμβ",
          levelRange: "90dB~",
          markColor: "οΈλΉ¨κ°μπ΄",
          examples: "μ² λλ³, μ ν¬κΈ° μ΄μ°©λ₯ λ±",
          soundName: "Red")
    ]
}
