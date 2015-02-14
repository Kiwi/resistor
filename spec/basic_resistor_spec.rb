# coding: utf-8

require_relative "spec_helper"

describe Resistor::BasicResistor do

  describe '::new' do
    let(:resistor) { Resistor.new(arg) }

    context '抵抗値を指定した場合' do
      let(:arg) { 4700 }
      it { expect(resistor.ohm).to eq 4700.0 }
      it { expect(resistor.code).to eq [:yellow, :purple, :red, :gold] }
      it { expect(resistor.tolerance).to eq 5.0 }
    end

    context '抵抗値を指定した場合' do
      let(:arg) { ['brown', 'black', 'blue', 'silver'] }
      it { expect(resistor.ohm).to eq 10_000_000 }
      it { expect(resistor.code).to eq [:brown, :black, :blue, :silver] }
      it { expect(resistor.tolerance).to eq 10.0 }
    end

    context 'どちらも指定しなかった場合' do
      let(:arg) { nil }
      it { expect { is_expected }.to raise_error(ArgumentError) }
    end

    context '許容差を指定した場合' do
      resistor = Resistor.new(100, tolerance: 0.1)
      it { expect(resistor.code[3]).to eq :purple }
      it { expect(resistor.tolerance).to eq 0.1 }
    end

    context 'オプションで5本帯を指定した場合' do
      # 許容差は変更されない
      resistor = Resistor.new(6.04, band_number: 5)
      it { expect(resistor.code).to eq [:blue, :black, :yellow, :silver, :gold] }
      it { expect(resistor.tolerance).to eq 5.0 }
    end

    context 'メソッドで5本帯を指定した場合' do
      # 許容差まで変更される
      Resistor::Options.set_band_number 5
      resistor = Resistor.new(123)
      it { expect(resistor.code).to eq [:brown, :red, :orange, :black, :brown] }
      it { expect(resistor.tolerance).to eq 1.0 }
      Resistor::Options.set_band_number 4
    end

    context 'メソッドで5本帯と許容差を指定した場合' do
      # 許容差まで指定できる
      Resistor::Options.defaults do |d|
        d[:band_number] = 5
        d[:tolerance] = 0.5
      end
      resistor = Resistor.new(49900)
      it { expect(resistor.code).to eq [:yellow, :white, :white, :red, :green] }
      it { expect(resistor.tolerance).to eq 0.5 }
      Resistor::Options.set_band_number 4
    end

    context 'メソッドで5本帯を指定してさらにオプションを渡した場合' do
      # オプションで渡されたものに上書きされる
      Resistor::Options.defaults do |d|
        d[:band_number] = 5
        d[:tolerance] = 0.5
      end
      resistor = Resistor.new(84.5, tolerance:0.1)
      it { expect(resistor.code).to eq [:gray, :yellow, :green, :gold, :purple] }
      it { expect(resistor.tolerance).to eq 0.1 }
      Resistor::Options.set_band_number 4
    end
  end

  describe '#+, #/' do
    context '直列接続の合成抵抗' do
      r1 = Resistor.new(100)
      r2 = Resistor.new(200)
      r3 = Resistor.new(300)
      it { expect((r1 + r2 + r3).ohm).to eq 600.0 }
    end

    context '並列接続の合成抵抗' do
      r1 = Resistor.new(30)
      r2 = Resistor.new(15)
      r3 = Resistor.new(10)
      it { expect((r1 / r2 / r3).ohm).to eq 5.0 }
    end

    context '並列と直列を合わせた合成抵抗' do
      r1 = Resistor.new(20)
      r2 = Resistor.new(30)
      r3 = Resistor.new(4)
      r4 = Resistor.new(8)
      it { expect(((r1 / r2) + r3 + (r4 / r4)).ohm).to eq 20.0 }
    end

    context '#+のエイリアスメソッドを使用した場合' do
      r1 = Resistor.new(100)
      original_name = (r1 + r1 + r1).ohm
      new_name = (r1 - r1 - r1).ohm
      it { expect(original_name == new_name).to be_truthy }
    end

    context '#/のエイリアスメソッドを使用した場合' do
      r1 = Resistor.new(100)
      original_name = (r1 / r1 / r1).ohm
      new_name = (r1 | r1 | r1).ohm
      it { expect(original_name == new_name).to be_truthy }
    end
  end

  describe '#ohm=, #code=' do
    context '抵抗値を変更する場合' do
      resistor = Resistor.new(100)
      resistor.ohm = 4.7
      it { expect(resistor.ohm).to eq 4.7 }
      it { expect(resistor.code).to eq [:yellow, :purple, :gold, :gold] }
    end

    context 'カラーコードを変更する場合' do
      resistor = Resistor.new(100)
      resistor.code = ['green', 'brown', 'silver', 'brown']
      it { expect(resistor.ohm).to eq 0.51 }
      it { expect(resistor.code).to eq [:green, :brown, :silver, :brown] }
      it { expect(resistor.tolerance).to eq 1.0 }
    end
  end

  describe '#e12?' do
    context 'E12系列である場合' do
      it { expect(Resistor.new(0.12).e12?).to eq true }
      it { expect(Resistor.new(3.3).e12?).to eq true }
      it { expect(Resistor.new(47).e12?).to eq true }
      it { expect(Resistor.new(82_000_000).e12?).to eq true }
    end

    context 'E12系列でない場合' do
      it { expect(Resistor.new(0.13).e12?).to eq false }
      it { expect(Resistor.new(3.8).e12?).to eq false }
      it { expect(Resistor.new(55).e12?).to eq false }
      it { expect(Resistor.new(70_000_000).e12?).to eq false }
    end
  end

  describe '#e24?' do
    context 'E24系列である場合' do
      it { expect(Resistor.new(0.1).e24?).to eq true }
      it { expect(Resistor.new(3).e24?).to eq true }
      it { expect(Resistor.new(47_000).e24?).to eq true }
      it { expect(Resistor.new(10_000_000).e24?).to eq true }
    end

    context 'E24系列でない場合' do
      it { expect(Resistor.new(0.92).e24?).to eq false }
      it { expect(Resistor.new(8.3).e24?).to eq false }
      it { expect(Resistor.new(23_000).e24?).to eq false }
      it { expect(Resistor.new(52_000_000).e24?).to eq false }
    end
  end

  describe '#e48?' do
    before do
      Resistor::Options.set_band_number 5
    end
    after do
      Resistor::Options.set_band_number 4
    end

    context 'E48系列である場合' do
      it { expect(Resistor.new(1.69).e48?).to eq true }
      it { expect(Resistor.new(28.7).e48?).to eq true }
      it { expect(Resistor.new(402).e48?).to eq true }
      it { expect(Resistor.new(90_900_000).e48?).to eq true }
    end

    context 'E48系列でない場合' do
      it { expect(Resistor.new(1.68).e48?).to eq false }
      it { expect(Resistor.new(28.6).e48?).to eq false }
      it { expect(Resistor.new(403).e48?).to eq false }
      it { expect(Resistor.new(91_900_000).e48?).to eq false }
    end
  end

  describe '#e96?' do
    before do
      Resistor::Options.set_band_number 5
    end
    after do
      Resistor::Options.set_band_number 4
    end

    context 'E96系列である場合' do
      it { expect(Resistor.new(1.91).e96?).to eq true }
      it { expect(Resistor.new(45.3).e96?).to eq true }
      it { expect(Resistor.new(715).e96?).to eq true }
      it { expect(Resistor.new(10_000_000).e96?).to eq true }
    end

    context 'E96系列でない場合' do
      it { expect(Resistor.new(1.92).e96?).to eq false }
      it { expect(Resistor.new(45.4).e96?).to eq false }
      it { expect(Resistor.new(716).e96?).to eq false }
      it { expect(Resistor.new(11_100_000).e96?).to eq false }
    end
  end
end
