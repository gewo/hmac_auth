# coding: utf-8
require 'spec_helper'

module HMACAuth

  describe Signature do
    let(:secret) { 't0p_s3cr3t!!eins1' }
    let(:params) do
      {
        b: 2,
        a: { d: 4, c: 3 }
      }
    end

    describe '.verify' do
      describe 'timestamp' do
        let(:timestamp) { Time.now.to_i }
        let(:params_with_timestamp) { params.merge(timestamp: timestamp) }
        let(:signed_params) do
          Signature.sign(params_with_timestamp, secret: secret)
        end

        subject { Signature.verify(signed_params, secret: secret) }

        context 'valid' do
          let(:timestamp) { 10.minutes.ago.to_i.to_s }
          it { should be_truthy }
        end

        context 'invalid' do
          let(:timestamp) { 20.minutes.ago.to_i }
          it { should be_falsy }
        end
      end
    end

    describe '.sign' do
      describe 'hash' do
        subject { HMACAuth::Signature.sign(params, secret: secret) }

        it { expect(subject).to be_a Hash }
        it { expect(subject['signature']).to be_a String }
        it { expect(subject['timestamp']).to be }
        it { expect(subject['b']).to be_a String }

        context 'nested hash' do
          subject { HMACAuth::Signature.sign(params, secret: secret)['a'] }
          it { expect(subject).to be_a Hash }
          it { expect(subject['d']).to eq '4' }
          it { expect(subject['c']).to eq '3' }
        end
      end

      describe 'unsorted input' do
        def signature(hash)
          HMACAuth::Signature.sign(hash, secret: secret)['signature']
        end

        let(:hasha) { { a: 1, b: { c: 3, d: 4 } } }
        let(:hashd) { { b: { d: 4, c: 3 }, a: 1 } }

        it 'calculates the same signature' do
          signature(hasha).should == signature(hashd)
        end
      end
    end
  end
end
