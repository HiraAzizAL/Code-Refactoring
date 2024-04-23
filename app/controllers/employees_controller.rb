require 'net/http'
require 'net/https'

class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_url

    def index
      if params[:page].present?
        uri = URI("#{@url}?page=#{params[:page]}")
      else
        uri = URI('#{@url}')
      end
      @employees = parse_response(uri)
    end

    def edit
      uri = URI("#{@url}/#{params[:id]}")
      @employee = parse_response(uri)
    end

    def show
      uri = URI("#{@url}/#{params[:id]}")
      @employee = parse_response(uri)
    end

    def create
      @employee = Employee::RefactorEmployeeService.create_employee(params, @url)

      if @employee
        redirect_to employee_path(@employee.dig("id"))
      else
        flash[:error] = "Failed to create employee"
        redirect_to root_path
      end
    end

    def update
      @employee = Employee::RefactorEmployeeService.update_employee(params, @url)

      if @employee
        redirect_to edit_employee_path(@employee["id"])
      else
        flash[:error] = "Failed to update employee"
        redirect_to root_path
      end
    end

    private

    def set_url
      @url = "https://dummy-employees-api-8bad748cda19.herokuapp.com/employees"
    end

    def parse_response(uri)
      response = Net::HTTP.get(uri)
      JSON.parse(response)
    end
  end
end
