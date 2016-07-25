class CotizacionDolar
  def blue
    begin 
      end_point = 'http://ws.geeklab.com.ar/dolar/get-dolar-json.php'
      result = JSON.parse(RestClient.get(end_point))

      result['blue']
    rescue
      nil
    end
  end

  def libre
    begin
      end_point = 'http://ws.geeklab.com.ar/dolar/get-dolar-json.php'
      result = JSON.parse(RestClient.get(end_point))

      result['libre']
    rescue
      nil
    end
  end
end