# GSAN Batch Manager

Nova GUI para administrar os processos Batch do GSAN

### Instalar o gerenciador de versões Ruby (http://rvm.io)
    curl -sSL https://get.rvm.io | bash -s stable
    
### Usar a versão 2 do Ruby
    rvm install 2.3.0

### Fazer o clone do projeto
    git clone [URL DO REPOSITÓRIO]

### Acessar o projeto
    cd gsan-batch-manager

### Instalar as dependências do projeto
    bundle install
    
### Copiar o arquivo de acesso ao banco de dados e configurar os ambientes
    cp config/database.yml.exemplo config/database.yml

### Iniciar o servidor local
    rails server

### Em seu navegador, abra o endereço abaixo para testar a aplicação
    localhost:3000

### Para executar os testes
    rake test
