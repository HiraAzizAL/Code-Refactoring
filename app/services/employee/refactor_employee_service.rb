module Employee
  class RefactorEmployeeService
    def update_or_create_employee(params, url, method)
      uri = URI("#{url}/#{params[:id]}")

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == 'https')

      request = method.new(uri.path)
      request['Content-Type'] = 'application/json'

      body = {
        "name": params[:name],
        "position": params[:position],
        "date_of_birth": params[:date_of_birth],
        "salary": params[:salary]
      }.to_json
      request.body = body

      response = http.request(request)

      if response.code == '200'
        employee = JSON.parse(response.body)
        return employee
      else
        return nil
      end
    end

    def self.update_employee(params, url)
      new.update_or_create_employee(params, url, Net::HTTP::Put)
    end

    def self.create_employee(params, url)
      new.update_or_create_employee(params, url, Net::HTTP::Post)
    end
  end
end
