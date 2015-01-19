module Resistor
  module ColorCode

    # 1桁目、2桁目の数値
    NUM = {
      :black  => 0,
      :brown  => 1,
      :red    => 2,
      :orange => 3,
      :yellow => 4,
      :green  => 5,
      :blue   => 6,
      :purple => 7,
      :gray   => 8,
      :white  => 9
    }.freeze

    # 3桁目で指定される乗数
    MULT = {
      :black  => 0,
      :brown  => 1,
      :red    => 2,
      :orange => 3,
      :yellow => 4,
      :green  => 5,
      :blue   => 6,
      :gold   => -1,
      :silver => -2
    }.freeze

    # 4桁目で指定される誤差範囲
    ERROR_RANGE = {
      :brown  => 1.0,
      :red    => 2.0,
      :orange => 0.05,
      :green  => 0.5,
      :blue   => 0.25,
      :purple => 0.1,
      :gold   => 5.0,
      :silver => 10.0
    }.freeze

    # E12系列
    E12_SERIES = {
      1 => [0, 2, 5, 8],
      2 => [2, 7],
      3 => [3, 9],
      4 => [7],
      5 => [6],
      6 => [8],
      8 => [2],
    }.freeze

    # E24系列
    E24_SERIES = {
      1 => [0, 1, 2, 3, 5, 6, 8],
      2 => [0, 2, 4, 7],
      3 => [0, 3, 6, 9],
      4 => [3, 7],
      5 => [1, 6],
      6 => [2, 8],
      7 => [5],
      8 => [2],
      9 => [1]
    }.freeze

    # 抵抗値 -> カラーコード
    def self.encode(ohm, error_range: 5.0)
      return [NUM.key(0)] if ohm == 0
      raise ArgumentError if ohm < 0.1

      # 0.1以上で1より小さい
      if ohm < 1
        ohm_str = (ohm*100).to_s.split('')
        [NUM.key(ohm_str[0].to_i), NUM.key(ohm_str[1].to_i),
         MULT.key(-2), ERROR_RANGE.key(error_range)]

      # 1以上で10より小さい(1桁)
      elsif ohm < 10
        ohm_str = (ohm*10).to_s.split('')
        [NUM.key(ohm_str[0].to_i), NUM.key(ohm_str[1].to_i),
         MULT.key(-1), ERROR_RANGE.key(error_range)]

      # 2桁以上
      else
        ohm_str = ohm.to_i.to_s.split('')
        [NUM.key(ohm_str[0].to_i), NUM.key(ohm_str[1].to_i),
         MULT.key(ohm_str.size - 2), ERROR_RANGE.key(error_range)]
      end
    end

    # カラーコード -> 抵抗値
    def self.decode(code)
      raise ArgumentError unless code.is_a? Array
      code = code.map(&:to_sym)
      return 0.0 if code == [:black]
      raise ArgumentError if code[0] == :black

      ohm = (NUM[code[0]]*10 + NUM[code[1]]) * 10**MULT[code[2]]
      return ohm.to_f
    end
  end
end
