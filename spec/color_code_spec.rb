# coding: utf-8

require_relative "spec_helper"

describe Resistor::ColorCode do

  describe '::encode' do
    subject { Resistor::ColorCode.encode(ohm, options) }

    context '0Ωの場合' do
      let(:ohm) { 0 }
      let(:options) { {} }
      it { is_expected.to eq [:black] }
    end

    context '0.1Ω以上1Ωより小さい場合' do
      let(:ohm) { 0.24 }
      let(:options) { {} }
      it { is_expected.to eq [:red, :yellow, :silver, :gold] }
    end

    context '1Ω以上10Ωより小さい場合' do
      let(:ohm) { 2 }
      let(:options) { {} }
      it { is_expected.to eq [:red, :black, :gold, :gold] }
    end

    context '10Ω以上の場合' do
      let(:ohm) { 3300 }
      let(:options) { {} }
      it { is_expected.to eq [:orange, :orange, :red, :gold] }
    end

    context '0Ωより小さい場合' do
      let(:ohm) { -10 }
      let(:options) { {} }
      it { expect { is_expected }.to raise_error(ArgumentError) }
    end

    context '0.1Ωより小さい場合' do
      let(:ohm) { 0.01 }
      let(:options) { {} }
      it { expect { is_expected }.to raise_error(ArgumentError) }
    end

    context 'オプションで5本帯を指定した場合' do
      # 許容差は変更されない
      let(:ohm) { 4320 }
      let(:options) { {:band_number => 5} }
      it { is_expected.to eq [:yellow, :orange, :red, :brown, :gold] }
    end

    context 'メソッドで5本帯を指定した場合' do
      # 許容差まで変更される
      Resistor::Options.set_band_number 5
      code = Resistor::ColorCode.encode(511)
      it { expect(code).to eq [:green, :brown, :brown, :black, :brown] }
      Resistor::Options.set_band_number 4
    end

    context 'メソッドで5本帯と許容差を指定した場合' do
      # 許容差まで指定できる
      Resistor::Options.defaults do |d|
        d[:band_number] = 5
        d[:tolerance] = 0.5
      end
      code = Resistor::ColorCode.encode(3.92)
      it { expect(code).to eq [:orange, :white, :red, :silver, :green] }
      Resistor::Options.set_band_number 4
    end

    context 'メソッドで5本帯を指定してさらにオプションを渡した場合' do
      # オプションで渡されたものに上書きされる
      Resistor::Options.defaults do |d|
        d[:band_number] = 5
        d[:tolerance] = 0.5
      end
      code = Resistor::ColorCode.encode(20.5, tolerance:0.1)
      it { expect(code).to eq [:red, :black, :green, :gold, :purple] }
      Resistor::Options.set_band_number 4
    end
  end

  describe '::decode' do
    subject { Resistor::ColorCode.decode(code, options) }

    context '0Ωの場合' do
      let(:code) { [:black] }
      let(:options) { {} }
      it { is_expected.to eq 0 }
    end

    context '0.1Ω以上1Ωより小さい場合' do
      let(:code) { [:blue, :red, :silver, :gold] }
      let(:options) { {} }
      it { is_expected.to eq 0.62 }
    end

    context '1Ω以上10Ωより小さい場合' do
      let(:code) { [:white, :brown, :gold, :gold] }
      let(:options) { {} }
      it { is_expected.to eq 9.1 }
    end

    context '10Ω以上の場合' do
      let(:code) { [:brown, :black, :blue, :gold] }
      let(:options) { {} }
      it { is_expected.to eq 10_000_000 }
    end

    context '1本目に黒が指定された場合' do
      let(:code) { [:black, :blue, :blue, :gold] }
      let(:options) { {} }
      it { expect { is_expected }.to raise_error(ArgumentError) }
    end

    context 'オプションで5本帯を指定した場合' do
      # 許容差は変更されない
      let(:code) { [:yellow, :orange, :red, :brown, :gold] }
      let(:options) { {:band_number => 5} }
      it { is_expected.to eq 4320.0 }
    end

    context 'メソッドで5本帯を指定した場合' do
      # 許容差まで変更される
      Resistor::Options.set_band_number 5
      ohm = Resistor::ColorCode.decode([:green, :brown, :brown, :black, :brown])
      it { expect(ohm).to eq 511.0 }
      Resistor::Options.set_band_number 4
    end
  end
end
