# coding: utf-8

require_relative "spec_helper"

describe Resistor::BasicResistor do

  describe '::new' do
    let(:resistor) { Resistor.new(ohm: ohm, code: code) }

    context '抵抗値を指定した場合' do
      let(:ohm) { 4700 }
      let(:code) { nil }

      it { expect(resistor.ohm).to eq 4700.0 }
      it { expect(resistor.code).to eq [:yellow, :purple, :red, :gold] }
      it { expect(resistor.error_range).to eq 5.0 }
    end

    context '抵抗値を指定した場合' do
      let(:ohm) { nil }
      let(:code) { ['brown', 'black', 'blue', 'silver'] }

      it { expect(resistor.ohm).to eq 10_000_000 }
      it { expect(resistor.code).to eq [:brown, :black, :blue, :silver] }
      it { expect(resistor.error_range).to eq 10.0 }
    end

    context 'どちらも指定しなかった場合' do
      let(:ohm) { nil }
      let(:code) { nil }

      it { expect { is_expected }.to raise_error(ArgumentError) }
    end

    context '許容差を指定した場合' do
      resistor = Resistor.new(ohm: 100, error_range: 0.1)
      it { expect(resistor.code[3]).to eq :purple }
      it { expect(resistor.error_range).to eq 0.1 }
    end
  end

  describe '#+, #/' do
    context '直列接続の合成抵抗' do
      r1 = Resistor.new(ohm: 100)
      r2 = Resistor.new(ohm: 200)
      r3 = Resistor.new(ohm: 300)

      it { expect((r1 + r2 + r3).ohm).to eq 600.0 }
    end

    context '並列接続の合成抵抗' do
      r1 = Resistor.new(ohm: 30)
      r2 = Resistor.new(ohm: 15)
      r3 = Resistor.new(ohm: 10)

      it { expect((r1 / r2 / r3).ohm).to eq 5.0 }
    end

    context '並列と直列を合わせた合成抵抗' do
      r1 = Resistor.new(ohm: 20)
      r2 = Resistor.new(ohm: 30)
      r3 = Resistor.new(ohm: 4)
      r4 = Resistor.new(ohm: 8)

      it { expect(((r1 / r2) + r3 + (r4 / r4)).ohm).to eq 20.0 }
    end
  end

  describe '#ohm=, #code=' do
    context '抵抗値を変更する場合' do
      resistor = Resistor.new(ohm: 100)
      resistor.ohm = 4.7

      it { expect(resistor.ohm).to eq 4.7 }
      it { expect(resistor.code).to eq [:yellow, :purple, :gold, :gold] }
    end

    context 'カラーコードを変更する場合' do
      resistor = Resistor.new(ohm: 100)
      resistor.code = ['green', 'brown', 'silver', 'brown']

      it { expect(resistor.ohm).to eq 0.51 }
      it { expect(resistor.code).to eq [:green, :brown, :silver, :brown] }
      it { expect(resistor.error_range).to eq 1.0 }
    end
  end

  describe '#e12?' do
    context 'E12系列である場合' do
      it { expect(Resistor.new(ohm: 0.12).e12?).to eq true }
      it { expect(Resistor.new(ohm: 3.3).e12?).to eq true }
      it { expect(Resistor.new(ohm: 47).e12?).to eq true }
      it { expect(Resistor.new(ohm: 82_000_000).e12?).to eq true }
    end

    context 'E12系列でない場合' do
      it { expect(Resistor.new(ohm: 0.13).e12?).to eq false }
      it { expect(Resistor.new(ohm: 3.8).e12?).to eq false }
      it { expect(Resistor.new(ohm: 55).e12?).to eq false }
      it { expect(Resistor.new(ohm: 70_000_000).e12?).to eq false }
    end
  end

  describe '#e24?' do
    context 'E24系列である場合' do
      it { expect(Resistor.new(ohm: 0.1).e24?).to eq true }
      it { expect(Resistor.new(ohm: 3).e24?).to eq true }
      it { expect(Resistor.new(ohm: 47_000).e24?).to eq true }
      it { expect(Resistor.new(ohm: 10_000_000).e24?).to eq true }
    end

    context 'E24系列でない場合' do
      it { expect(Resistor.new(ohm: 0.92).e24?).to eq false }
      it { expect(Resistor.new(ohm: 8.3).e24?).to eq false }
      it { expect(Resistor.new(ohm: 23_000).e24?).to eq false }
      it { expect(Resistor.new(ohm: 52_000_000).e24?).to eq false }
    end
  end
end
