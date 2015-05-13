class SetorComercial < ActiveRecord::Base
	self.table_name = 'cadastro.setor_comercial'
	self.primary_key = 'stcm_id'

	belongs_to :localidade, class_name: 'Localidade', foreign_key: 'loca_id'
	has_many :rotas, class_name: 'Rota', foreign_key: 'stcm_id'

	alias_attribute 'id', 'stcm_id'
	alias_attribute 'setor_comercial', 'stcm_nmsetorcomercial'

	def self.localidades_por_setores_comerciais(setores_comerciais)
		setores_comerciais = where("stcm_id in (?)", setores_comerciais)

		localidades = []
		setores_comerciais.each do |setor_comercial|
			localidades << ["#{setor_comercial.localidade.id} - #{setor_comercial.localidade.loca_nmlocalidade}", setor_comercial.localidade.id]
		end

		localidades.uniq
	end
end
