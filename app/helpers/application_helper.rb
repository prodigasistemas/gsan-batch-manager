module ApplicationHelper
  def alert_class_for(flash_type)
    {
      :success => 'alert-success',
      :error => 'alert-danger',
      :alert => 'alert-warning',
      :notice => 'alert-info'
    }[flash_type.to_sym] || flash_type.to_s
  end

  def log_processo processo
    begin
      log = File.readlines("/var/tmp/#{processo.id}_iniciado.log", encoding: "UTF-8") do |line|
        line
      end

      txt = ""
      log.each do |line|
        txt << line
      end

      txt
    rescue
      "Nenhum log encontrado!"
    end
  end
end
