# coding: utf-8

require_relative "spec_helper"

describe Resistor::ColorCode do

  describe '::encode' do
    subject { Resistor::ColorCode.encode(ohm) }

    context '0Ωの場合' do
      let(:ohm) { 0 }
      it { is_expected.to eq [:black] }
    end

    context '0.1Ω以上1Ωより小さい場合' do
      let(:ohm) { 0.24 }
      it { is_expected.to eq [:red, :yellow, :silver, :gold] }
    end

    context '1Ω以上10Ωより小さい場合' do
      let(:ohm) { 2 }
      it { is_expected.to eq [:red, :black, :gold, :gold] }
    end

    context '10Ω以上の場合' do
      let(:ohm) { 3300 }
      it { is_expected.to eq [:orange, :orange, :red, :gold] }
    end

    context '0Ωより小さい場合' do
      let(:ohm) { -10 }
      it { expect { is_expected }.to raise_error(ArgumentError) }
    end

    context '0.1Ωより小さい場合' do
      let(:ohm) { 0.01 }
      it { expect { is_expected }.to raise_error(ArgumentError) }
    end
  end

  describe '::decode' do
    subject { Resistor::ColorCode.decode(code) }

    context '0Ωの場合' do
      let(:code) { [:black] }
      it { is_expected.to eq 0 }
    end

    context '0.1Ω以上1Ωより小さい場合' do
      let(:code) { [:blue, :red, :silver, :gold] }
      it { is_expected.to eq 0.62 }
    end

    context '1Ω以上10Ωより小さい場合' do
      let(:code) { [:white, :brown, :gold, :gold] }
      it { is_expected.to eq 9.1 }
    end

    context '10Ω以上の場合' do
      let(:code) { [:brown, :black, :blue, :gold] }
      it { is_expected.to eq 10_000_000 }
    end

    context '1本目に黒が指定された場合' do
      let(:code) { [:black, :blue, :blue, :gold] }
      it { expect { is_expected }.to raise_error(ArgumentError) }
    end
  end
end
