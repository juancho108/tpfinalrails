class Option < ActiveRecord::Base

#methods

	def self.actualizar_valor_dolar
		libre = CotizacionDolar.new.libre
		blue = CotizacionDolar.new.blue

		Option.first.update(dolar_libre: libre) if libre
		Option.first.update(dolar_blue: blue) if blue
	end

end
