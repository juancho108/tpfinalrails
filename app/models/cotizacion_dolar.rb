class CotizacionDolar
  def blue
    begin 
      end_point = 'http://ws.geeklab.com.ar/dolar/get-dolar-json.php'
      result = JSON.parse(RestClient.get(end_point))

      result['blue']
    rescue
      return 0.0
    end
  end

  def libre
    begin
      end_point = 'http://ws.geeklab.com.ar/dolar/get-dolar-json.php'
      result = JSON.parse(RestClient.get(end_point))

      result['libre']
    rescue
      return 0.0
    end
  end
end