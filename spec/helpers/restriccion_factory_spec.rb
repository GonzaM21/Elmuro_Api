require 'spec_helper'

describe RestriccionFactory do
  let(:factory) { described_class.new }

  RESTRICCION_CONYUGE = 'RestriccionConyuge'.freeze
  RESTRICCION_EDAD = 'RestriccionEdad'.freeze
  RESTRICCION_HIJOS = 'RestriccionHijos'.freeze
  it 'crear_restriccion RestriccionConyuge deberia devolver una instanica de RestriccionConyuge' do
    restriccion = factory.crear_restriccion(RESTRICCION_CONYUGE, 0, 0, 0, true)
    expect(restriccion).to be_an_instance_of(RestriccionConyuge)
  end
  it 'crear_restriccion RestriccionEdad deberia devolver una instanica de RestriccionEdad' do
    restriccion = factory.crear_restriccion(RESTRICCION_EDAD, 0, 0, 0, true)
    expect(restriccion).to be_an_instance_of(RestriccionEdad)
  end
  it 'crear_restriccion RestriccionHijos deberia devolver una instanica de RestriccionHijos' do
    restriccion = factory.crear_restriccion(RESTRICCION_HIJOS, 0, 0, 0, true)
    expect(restriccion).to be_an_instance_of(RestriccionHijos)
  end
end
