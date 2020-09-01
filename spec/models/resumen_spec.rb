require 'spec_helper'
require_relative '../../src/models/resumen'
require_relative '../../src/models/afiliado'
require_relative '../../src/models/plan'
require_relative '../../src/models/compra'

describe 'Resumen' do
  it 'deberia devolver 0 para una lista de compras vacia' do
    coberturas = []
    cobertura_medicamentos = CoberturaMedicamentos.new 80
    cobertura_visitas = CoberturaVisitas.new(nil, 0)
    coberturas.append cobertura_medicamentos
    coberturas.append cobertura_visitas
    plan = Plan.new('PlanTest', 500, nil, coberturas, nil, nil, nil)
    afiliado = Afiliado.new('Pepe', 40, plan, false, 0, nil, nil, nil, nil)
    resumen = Resumen.new(afiliado)
    expect(resumen.gastos_medicamentos).to eq 0
  end

  it 'deberia devolver la suma total si el plan no cubre medicamentos' do
    coberturas = []
    cobertura_medicamentos = CoberturaMedicamentos.new 0
    cobertura_visitas = CoberturaVisitas.new(nil, 0)
    coberturas.append cobertura_medicamentos
    coberturas.append cobertura_visitas
    plan = Plan.new('PlanTest', 500, nil, coberturas, nil, nil, nil)
    afiliado = Afiliado.new('Pepe', 40, plan, false, 0, nil, nil, nil, nil)
    compras = [Compra.new(afiliado, 10, nil, nil, nil), Compra.new(afiliado, 30, nil, nil, nil)]
    resumen = Resumen.new(afiliado, compras: compras)
    expect(resumen.gastos_medicamentos).to eq 40
  end

  it 'deberia devolver la suma total menos lo que cubre el plan' do
    coberturas = []
    cobertura_medicamentos = CoberturaMedicamentos.new 50
    cobertura_visitas = CoberturaVisitas.new(nil, 0)
    coberturas.append cobertura_medicamentos
    coberturas.append cobertura_visitas
    plan = Plan.new('PlanTest', 500, nil, coberturas, nil, nil, nil)
    afiliado = Afiliado.new('Pepe', 40, plan, false, 0, nil, nil, nil, nil)
    compras = [Compra.new(afiliado, 10, nil, nil, nil), Compra.new(afiliado, 30, nil, nil, nil)]
    resumen = Resumen.new(afiliado, compras: compras)
    expect(resumen.gastos_medicamentos).to eq 20
  end

  it 'deberia responder que el costo base es igual al costo del plan' do
    coberturas = []
    cobertura_medicamentos = CoberturaMedicamentos.new 0
    cobertura_visitas = CoberturaVisitas.new(nil, 0)
    coberturas.append cobertura_medicamentos
    coberturas.append cobertura_visitas
    plan = Plan.new('PlanTest', 500, nil, coberturas, nil, nil, nil)
    afiliado = Afiliado.new('Pepe', 40, plan, false, 0, nil, nil, nil, nil)
    resumen = Resumen.new(afiliado)
    expect(resumen.costo_plan).to eq 500
  end

  it 'deberia responder que el costo total es el base mas el adicional' do
    coberturas = []
    cobertura_medicamentos = CoberturaMedicamentos.new 50
    cobertura_visitas = CoberturaVisitas.new(nil, 0)
    coberturas.append cobertura_medicamentos
    coberturas.append cobertura_visitas
    plan = Plan.new('PlanTest', 500, nil, coberturas, nil, nil, nil)
    afiliado = Afiliado.new('Pepe', 40, plan, false, 0, nil, nil, nil, nil)
    compras = [Compra.new(afiliado, 10, nil, nil, nil), Compra.new(afiliado, 30, nil, nil, nil)]
    resumen = Resumen.new(afiliado, compras: compras)
    expect(resumen.total_a_pagar).to eq 20 + 500
  end

  it 'deberia decirme que los gastos de atenciones es 0 si no se atendio' do
    coberturas = []
    cobertura_medicamentos = CoberturaMedicamentos.new 0
    cobertura_visitas = CoberturaVisitas.new(nil, 0)
    coberturas.append cobertura_medicamentos
    coberturas.append cobertura_visitas
    plan = Plan.new('PlanTest', 500, nil, coberturas, nil, nil, nil)
    afiliado = Afiliado.new('Pepe', 40, plan, false, 0, nil, nil, nil, nil)
    resumen = Resumen.new(afiliado)
    expect(resumen.gastos_atenciones).to eq 0
  end

  it 'deberia decirme que los gastos son la suma del costo de atenciones si el limite es 0' do
    coberturas = []
    cobertura_medicamentos = CoberturaMedicamentos.new 0
    cobertura_visitas = CoberturaVisitas.new(0, 0)
    coberturas.append cobertura_medicamentos
    coberturas.append cobertura_visitas
    plan = Plan.new('PlanTest', 500, nil, coberturas, nil, nil, nil)
    afiliado = Afiliado.new('Pepe', 40, plan, false, 0, nil, nil, nil, nil)
    atenciones = [
      instance_double('Atencion', costo: 100),
      instance_double('Atencion', costo: 100),
      instance_double('Atencion', costo: 100),
      instance_double('Atencion', costo: 100),
      instance_double('Atencion', costo: 100)
    ]
    resumen = Resumen.new(afiliado, atenciones: atenciones)
    expect(resumen.gastos_atenciones).to eq 500
  end

  it 'deberia contar el copago para las atenciones menores al limite, luego el costo de atencion' do
    coberturas = []
    cobertura_medicamentos = CoberturaMedicamentos.new 0
    cobertura_visitas = CoberturaVisitas.new(3, 50)
    coberturas.append cobertura_medicamentos
    coberturas.append cobertura_visitas
    plan = Plan.new('PlanTest', 500, nil, coberturas, nil, nil, nil)
    afiliado = Afiliado.new('Pepe', 40, plan, false, 0, nil, nil, nil, nil)
    atenciones = [
      instance_double('Atencion', costo: 100),
      instance_double('Atencion', costo: 100),
      instance_double('Atencion', costo: 100),
      instance_double('Atencion', costo: 100),
      instance_double('Atencion', costo: 100)
    ]
    resumen = Resumen.new(afiliado, atenciones: atenciones)
    expect(resumen.gastos_atenciones).to eq 350
  end

  it 'si la cantidad de atenciones no supera el limite, el valor deberia ser copago * atenciones' do
    coberturas = []
    cobertura_medicamentos = CoberturaMedicamentos.new 0
    cobertura_visitas = CoberturaVisitas.new(nil, 50)
    coberturas.append cobertura_medicamentos
    coberturas.append cobertura_visitas
    plan = Plan.new('PlanTest', 500, nil, coberturas, nil, nil, nil)
    afiliado = Afiliado.new('Pepe', 40, plan, false, 0, nil, nil, nil, nil)
    atenciones = [
      instance_double('Atencion', costo: 100),
      instance_double('Atencion', costo: 100),
      instance_double('Atencion', costo: 100),
      instance_double('Atencion', costo: 100),
      instance_double('Atencion', costo: 100)
    ]
    resumen = Resumen.new(afiliado, atenciones: atenciones)
    expect(resumen.gastos_atenciones).to eq 250
  end

  it 'deberia responder correctamente con distintos valores de costos' do
    coberturas = []
    cobertura_medicamentos = CoberturaMedicamentos.new 0
    cobertura_visitas = CoberturaVisitas.new(2, 0)
    coberturas.append cobertura_medicamentos
    coberturas.append cobertura_visitas
    plan = Plan.new('PlanTest', 500, nil, coberturas, nil, nil, nil)
    afiliado = Afiliado.new('Pepe', 40, plan, false, 0, nil, nil, nil, nil)
    atenciones = [
      instance_double('Atencion', costo: 1000),
      instance_double('Atencion', costo: 500),
      instance_double('Atencion', costo: 1000)
    ]
    resumen = Resumen.new(afiliado, atenciones: atenciones)
    expect(resumen.gastos_atenciones).to eq 1000
  end

  it 'deberia devolver un detalle vacio cuándo no hay atenciones ni compras' do
    coberturas = []
    cobertura_medicamentos = CoberturaMedicamentos.new 0
    cobertura_visitas = CoberturaVisitas.new(2, 0)
    coberturas.append cobertura_medicamentos
    coberturas.append cobertura_visitas
    plan = Plan.new('PlanTest', 500, nil, coberturas, nil, nil, nil)
    afiliado = Afiliado.new('Pepe', 40, plan, false, 0, nil, nil, nil, nil)
    resumen = Resumen.new(afiliado)
    expect(resumen.detalle.length).to eq 0
  end

  it 'debería devolver un detalle con costos correctos para un copago de 0 y limite 0' do
    coberturas = []
    cobertura_medicamentos = CoberturaMedicamentos.new 0
    cobertura_visitas = CoberturaVisitas.new(0, 0)
    coberturas.append cobertura_medicamentos
    coberturas.append cobertura_visitas
    plan = Plan.new('PlanTest', 500, nil, coberturas, nil, nil, nil)
    afiliado = Afiliado.new('Pepe', 40, plan, false, 0, nil, nil, nil, nil)
    atenciones = [
      instance_double('Atencion', costo: 1000, fecha: Time.new(2020, 10, 10), nombre_prestacion: 'Rayos X', nombre_centro: 'Hospital 10'), # rubocop: disable Metrics/LineLength
      instance_double('Atencion', costo: 500, fecha: Time.new(2020, 10, 10), nombre_prestacion: 'Clinica', nombre_centro: 'Hospital 10'), # rubocop: disable Metrics/LineLength
      instance_double('Atencion', costo: 1000, fecha: Time.new(2020, 10, 10), nombre_prestacion: 'Rayos X', nombre_centro: 'Hospital 10') # rubocop: disable Metrics/LineLength
    ]
    detalle = Resumen.new(afiliado, atenciones: atenciones).detalle
    expect(detalle[0][:costo]).to eq 1000
    expect(detalle[1][:costo]).to eq 500
    expect(detalle[2][:costo]).to eq 1000
  end

  it 'debería devolver un detalle con fechas correctas para un copago de 0 y limite 0' do
    coberturas = []
    cobertura_medicamentos = CoberturaMedicamentos.new 0
    cobertura_visitas = CoberturaVisitas.new(0, 0)
    coberturas.append cobertura_medicamentos
    coberturas.append cobertura_visitas
    plan = Plan.new('PlanTest', 500, nil, coberturas, nil, nil, nil)
    afiliado = Afiliado.new('Pepe', 40, plan, false, 0, nil, nil, nil, nil)
    atenciones = [
      instance_double('Atencion', costo: 500, fecha: Time.new(2020, 10, 11), nombre_prestacion: 'Clinica', nombre_centro: 'Hospital 10'), # rubocop: disable Metrics/LineLength
      instance_double('Atencion', costo: 1000, fecha: Time.new(2020, 10, 10), nombre_prestacion: 'Rayos X', nombre_centro: 'Hospital 10'), # rubocop: disable Metrics/LineLength
      instance_double('Atencion', costo: 1000, fecha: Time.new(2020, 10, 13), nombre_prestacion: 'Rayos X', nombre_centro: 'Hospital 10') # rubocop: disable Metrics/LineLength
    ]
    detalle = Resumen.new(afiliado, atenciones: atenciones).detalle
    expect(detalle[0][:fecha]).to eq '10/10/2020'
    expect(detalle[1][:fecha]).to eq '11/10/2020'
    expect(detalle[2][:fecha]).to eq '13/10/2020'
  end

  it 'debería devolver un detalle con conceptos correctas para un copago de 0 y limite 0' do
    coberturas = []
    cobertura_medicamentos = CoberturaMedicamentos.new 0
    cobertura_visitas = CoberturaVisitas.new(0, 0)
    coberturas.append cobertura_medicamentos
    coberturas.append cobertura_visitas
    plan = Plan.new('PlanTest', 500, nil, coberturas, nil, nil, nil)
    afiliado = Afiliado.new('Pepe', 40, plan, false, 0, nil, nil, nil, nil)
    atenciones = [
      instance_double('Atencion', costo: 1000, fecha: Time.new(2020, 10, 10), nombre_prestacion: 'Rayos X', nombre_centro: 'Hospital 10'), # rubocop: disable Metrics/LineLength
      instance_double('Atencion', costo: 500, fecha: Time.new(2020, 10, 10), nombre_prestacion: 'Clinica', nombre_centro: 'Hospital 10'), # rubocop: disable Metrics/LineLength
      instance_double('Atencion', costo: 1000, fecha: Time.new(2020, 10, 10), nombre_prestacion: 'Rayos X', nombre_centro: 'Hospital 10') # rubocop: disable Metrics/LineLength
    ]
    detalle = Resumen.new(afiliado, atenciones: atenciones).detalle
    expect(detalle[0][:concepto]).to eq 'Rayos X - Hospital 10'
    expect(detalle[1][:concepto]).to eq 'Clinica - Hospital 10'
    expect(detalle[2][:concepto]).to eq 'Rayos X - Hospital 10'
  end

  it 'deberia devolver un detalle correcto con medicamentos y atenciones' do
    coberturas = []
    cobertura_medicamentos = CoberturaMedicamentos.new 0
    cobertura_visitas = CoberturaVisitas.new(0, 0)
    coberturas.append cobertura_medicamentos
    coberturas.append cobertura_visitas
    plan = Plan.new('PlanTest', 500, nil, coberturas, nil, nil, nil)
    afiliado = Afiliado.new('Pepe', 40, plan, false, 0, nil, nil, nil, nil)
    atenciones = [
      instance_double('Atencion', costo: 1000, fecha: Time.new(2020, 10, 10), nombre_prestacion: 'Rayos X', nombre_centro: 'Hospital 10'), # rubocop: disable Metrics/LineLength
    ]
    compras = [
      instance_double('Compra', costo: 500, fecha: Time.new(2020, 10, 9))
    ]
    detalle = Resumen.new(afiliado, atenciones: atenciones, compras: compras).detalle
    expect(detalle[0][:costo]).to eq 500
    expect(detalle[1][:costo]).to eq 1000
  end
end
