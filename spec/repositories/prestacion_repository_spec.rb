require 'integration_spec_helper'
describe PrestacionRepository do
  let(:repository) { described_class.new }

  describe 'nueva prestacion' do
    it 'Dado que guardo la prestacion Odontologia si lo busco por el nombre deberia encontrarla' do
      nombre_prestacion = 'Odontologia'
      prestacion = Prestacion.new(nombre_prestacion, 0)
      described_class.new.save(prestacion)
      prestacion_encontrada = described_class.new.find_by_nombre(nombre_prestacion)
      expect(prestacion_encontrada.nombre).to eq nombre_prestacion
    end
  end

  describe 'Buscar Prestacion' do
    it 'Existente pasando nombre con distinto formato deberia encontrarlo' do
      nombre_prestacion = 'Odontologia'
      prestacion = Prestacion.new(nombre_prestacion, 0)
      described_class.new.save(prestacion)
      prestacion_encontrada = described_class.new.find_by_nombre('OdONTolOgía')
      expect(prestacion_encontrada.nombre).to eq nombre_prestacion
    end
  end
end
