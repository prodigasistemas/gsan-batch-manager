class Localidade < ActiveRecord::Base
	self.table_name = 'cadastro.localidade'
	self.primary_key = 'loca_id'

	has_many :setor_comercial, class_name: 'SetorComercial', foreign_key: 'loca_id'

	alias_attribute 'id', 'loca_id'
	alias_attribute 'nome_localidade', 'loca_nmlocalidade'
end