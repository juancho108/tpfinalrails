class Option < ActiveRecord::Base
include Singleton
#methods

	def self.actualizar_valor_dolar
		libre = CotizacionDolar.new.libre
		blue = CotizacionDolar.new.blue

		Option.instance.update(dolar_libre: libre) if libre
		Option.instance.update(dolar_blue: blue) if blue
	end

end
