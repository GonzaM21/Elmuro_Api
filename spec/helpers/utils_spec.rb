require 'spec_helper'
require_relative '../../src/exceptions/no_string_error'

describe Utils do
  let(:utils) { described_class.new }

  it 'debe retornar pepe sin acento cuando le saco el formato a pepé' do
    expect(utils.sacar_formato_string('pepé')).to eq('pepe')
  end

  it 'debe retornar pepe sin mayusculas cuando le saco el formato a PePe' do
    expect(utils.sacar_formato_string('PePe')).to eq('pepe')
  end

  it 'debe lanzar una excepcion si se le pasa un numero' do
    expect { utils.sacar_formato_string(1) }.to raise_error(NoStringError)
  end

  it 'debe retornar pepe sin formato si le paso PépE1' do
    expect(utils.sacar_formato_string('PépE1')).to eq('pepe1')
  end
end
