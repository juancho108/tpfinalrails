namespace :external do
  desc "Obtenemos la cotizacion del dolar"
  task dolar: :environment do
    Option.actualizar_valor_dolar
  end
end
