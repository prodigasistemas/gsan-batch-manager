class SetorComercial < ActiveRecord::Base
	self.table_name = 'cadastro.setor_comercial'
	self.primary_key = 'stcm_id'

	belongs_to :localidade, class_name: 'Localidade', foreign_key: 'loca_id'
	has_many :rotas, class_name: 'Rota', foreign_key: 'stcm_id'

	alias_attribute 'id', 'stcm_id'
	alias_attribute 'setor_comercial', 'stcm_nmsetorcomercial'
end