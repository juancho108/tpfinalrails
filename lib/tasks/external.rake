namespace :external do
  desc "Obtenemos la cotizacion del dolar"
  task dolar: :environment do
    libre = CotizacionDolar.new.libre
    blue = CotizacionDolar.new.blue

    Configuration.first.update(dolar_libre: libre) if libre
    Configuration.first.update(dolar_blue: blue) if blue
  end
end
