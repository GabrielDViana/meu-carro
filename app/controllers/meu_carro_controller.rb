class MeuCarroController < ApplicationController
  def index
    @course = Course.first
  end
end
