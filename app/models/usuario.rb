class Usuario < ActiveRecord::Base
  self.table_name='seguranca.usuario'
  self.primary_key='usur_id'

  has_many :processos_iniciados, class_name: 'ProcessoIniciado', foreign_key: "usur_id"

  alias_attribute 'id', 'usur_id'
  alias_attribute 'nome', 'usur_nmusuario'
end
