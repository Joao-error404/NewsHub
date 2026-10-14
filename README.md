# **NewsHub**
O NewsHub é um aplicativo de notícias para iOS desenvolvido em Swift. Ele permite acompanhar notícias recentes, explorar conteúdos por meio de pesquisa e filtros, consultar os detalhes de uma notícia e salvar matérias favoritas para acessá-las posteriormente.
**Funcionalidades**
- Início: exibe notícias recentes em português.
- Explorar: apresenta notícias por relevância e permite pesquisar por termos.
- Filtros por assunto: facilita a busca por temas como esportes, entretenimento, tecnologia, saúde e ciência.
- Detalhes da notícia: mostra as informações disponíveis sobre a matéria e permite abrir o artigo original.
- Favoritos: permite salvar e remover notícias favoritas.
- Persistência local: mantém os favoritos salvos no dispositivo usando UserDefaults.
- Navegação por abas: organiza as áreas Início, Explorar e Favoritos.
# **Tecnologias utilizadas**
- Swift
- UIKit para a construção da interface
- URLSession para requisições HTTP
- NewsAPI como fonte de notícias
- async/await para operações assíncronas
- JSONDecoder / JSONEncoder para decodificação e persistência de dados
- UserDefaults para armazenamento local dos favoritos
- Combine para observar mudanças na lista de favoritos
- SafariServices para abrir artigos dentro do aplicativo
- Xcode para desenvolvimento e execução
# **Arquitetura**
O aplicativo utiliza uma organização inspirada no padrão MVVM (Model-View-ViewModel), separando responsabilidades:
- Model: representa os dados das notícias e a estrutura da resposta da API.
- View: apresenta a interface e os componentes visuais.
- ViewController: coordena as interações da tela e conecta a interface ao ViewModel.
- ViewModel: intermedia a apresentação e o acesso aos dados.
- Service: centraliza as requisições à NewsAPI.
- Storage: gerencia o armazenamento local das notícias favoritas.
# **Fonte das notícias**
As notícias são obtidas pela NewsAPI. A disponibilidade dos conteúdos e o número de requisições dependem dos limites e das condições do plano utilizado na API. O NewsHub apresenta os dados retornados pela fonte e disponibiliza o acesso ao artigo original quando há uma URL válida.
# **Desenvolvimento**
Projeto desenvolvido em pair programming com foco na prática de desenvolvimento iOS, consumo de APIs e organização de código em Swift.
